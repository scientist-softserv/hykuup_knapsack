# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work MobiusGenericWork`
class MobiusGenericWork < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include IiifPrint.model_configuration(
    pdf_split_child_model: self
  )

  validates :title, presence: { message: 'Your work must have a title.' }

  self.indexer = GenericWorkIndexer
end
