# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource MobiusWork`
class MobiusWork < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:mobius_work)
  include Hyrax::Schema(:with_pdf_viewer)
  include Hyrax::Schema(:with_video_embed)
  include Hyrax::ArResource
  include Hyrax::NestedWorks

  prepend OrderAlready.for(:creator)
end
