# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource UncaWork`
class UncaWork < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:unca_work)
  include Hyrax::Schema(:with_pdf_viewer)
  include Hyrax::Schema(:with_video_embed)
  include Hyrax::ArResource
  include Hyrax::NestedWorks

  prepend OrderAlready.for(:creator)
end
