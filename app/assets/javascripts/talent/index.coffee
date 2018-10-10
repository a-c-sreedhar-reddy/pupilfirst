setupCompanyCarousel = ->
  $(".company-carousel").slick
    slidesToShow: 4
    slidesToScroll: 2
    dots: true
    arrows: true
    responsive: [
      {
        breakpoint: 992,
        settings: {
          slidesToShow: 2
        }
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 1
          slidesToScroll: 1
          arrows: false
        }
      }
    ]
    infinite: true

setupTestimonialCarousel = ->
  $(".testimonial-carousel").slick
    dots: true
    arrows: true
    infinite: true
    responsive: [
      {
        breakpoint: 992,
        settings: {
          arrows: false
        }
      }
    ]

  # $(".testimonial-carousel").on 'beforeChange', (event, slick, currentSlide, nextSlide) ->
  #   previousSlide = $(".testimonial-slide-item [data-slick-index='#{currentSlide}']")
  #   videoContent = previousSlide.find('iframe')[0].contentWindow
  #   videoContent.postMessage('{"event":"command","func":"stopVideo","args":""}', '*');

animateHeroHeadline = ->
  typed = new Typed(
    '.talent-hero__typed',
    stringsElement: '.talent-hero__typed-strings'
    typeSpeed: 20
    backSpeed: 20
    backDelay: 3000
    cursorChar: '|'
    smartBackspace: false
    loop: true
  )

showTalentFormOnError = ->
  talentFormModal = $('.invest-hire-modal')

  if talentFormModal.data('showOnLoad')
    talentFormModal.modal('show')

clearAllFormInterests = ->
  interestChoices = ['joining_svco_as_faculty', 'accelerating_startups', 'investing_in_startups', 'hiring_developers',
    'acquihiring_teams']

  $.each interestChoices, (index, selection) ->
    $("#talent_query_type_#{selection}").prop('checked', false)

handleActionButtonClicks = ->
  $('.talent-action-btn').click (event) ->
    selection = $(event.target).data('selection')
    clearAllFormInterests()
    $("#talent_query_type_#{selection}").prop('checked', true)
    $('.invest-hire-modal').modal('show')

pauseVideosOnTalentTabSwitch = ->
  if $('.talent-tab-content').length > 0
    $('a[data-toggle="tab"]').on 'hide.bs.tab', (event) ->
      oldTabId = $(event.target).attr('href')
      videoContent = $(oldTabId).find('iframe')[0].contentWindow
      videoContent.postMessage('{"event":"command","func":"stopVideo","args":""}', '*');

$(document).on 'turbolinks:load', ->
  if $('#talent__index').length > 0
    animateHeroHeadline()
    showTalentFormOnError()
    handleActionButtonClicks()
    pauseVideosOnTalentTabSwitch()
    setupCompanyCarousel()
    setupTestimonialCarousel()
