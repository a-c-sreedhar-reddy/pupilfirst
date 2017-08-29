module Founders
  class SlackConnectService
    include RoutesResolvable
    include Loggable

    def initialize(founder)
      @founder = founder
    end

    # @return [String] URL to redirect to where user will be asked to sign in with Slack and grant required permissions.
    def redirect_url
      params = oauth_params.merge(scope: 'users.profile:write')

      "https://#{Rails.application.secrets.slack[:name]}.slack.com/oauth?#{params.to_query}"
    end

    # Completes OAuth flow by exchanging OAuth code for OAuth access token.
    #
    # @param code [Hash] 'Code', received from Slack in redirect.
    def connect(code)
      params = oauth_params.merge(
        client_secret: Rails.application.secrets.slack.dig(:app, :client_secret),
        code: code
      )

      response = api.get('oauth.access', params: params)

      if response['team_id'] != Rails.application.secrets.slack.dig(:team_ids, :public_slack)
        raise Founders::SlackConnectService::TeamMismatchException
      end

      @founder.slack_access_token = response['access_token']
      @founder.slack_user_id = response['user_id']
      @founder.save!

      log "Successfully assigned Slack access token to Founder##{@founder.id}."

      perform_post_connect_tasks

      log 'All done.'
    end

    # Disconnects a founder from his / her Slack account.
    def disconnect
      # Attempt to revoke the access token.
      api(@founder.slack_access_token).get('auth.revoke')

      log "Successfully revoked Slack access token belonging to Founder##{@founder.id}."
    rescue PublicSlack::OperationFailureException # rubocop:disable Lint/HandleExceptions
      # It's okay if that fails.
    ensure
      # But make sure we delete the token from the database.
      @founder.slack_access_token = nil
      @founder.save!
    end

    # Checks whether a supplied Slack OAuth access token is still valid.
    #
    # @param access_token [String] Slack token to test.
    # @return [true, false] Returns true for valid, and false for not.
    def token_valid?(access_token)
      api(access_token).get('auth.test')
      true
    rescue PublicSlack::OperationFailureException
      false
    end

    private

    def perform_post_connect_tasks
      update_slack_username

      # Update their Slack profile name.
      Founders::UpdateSlackNameJob.perform_later(@founder)

      # Invite them to all channels.
      Founders::InviteToSlackChannelsJob.perform_later(@founder)

      # Tag the user on Intercom as having connected to Slack.
      Intercom::FounderTaggingJob.perform_later(@founder, 'Connected Slack Account')
    end

    def update_slack_username
      log 'Fetching username from Slack...'

      response = api(Rails.application.secrets.slack.dig(:app, :oauth_token)).get('users.info', params: { user: @founder.slack_user_id })

      @founder.slack_username = response['user']['name']
      @founder.save!
    end

    def oauth_params
      {
        client_id: Rails.application.secrets.slack.dig(:app, :client_id),
        redirect_uri: url_helpers.founder_slack_callback_url
      }
    end

    def api(token = nil)
      PublicSlack::ApiService.new(token: token)
    end
  end
end