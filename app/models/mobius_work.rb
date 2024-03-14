# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource MobiusWork`
class MobiusWork < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:mobius_work)
end
