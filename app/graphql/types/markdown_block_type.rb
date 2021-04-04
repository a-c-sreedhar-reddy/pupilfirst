module Types
  class MarkdownBlockType < Types::BaseObject
    field :markdown, String, null: false
    field :wysiwyg, Boolean, null: true
  end
end
