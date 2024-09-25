# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource UncaWork`
class UncaWork < EtdResource
  include Hyrax::Schema(:etd_resource)
  include Hyrax::Schema(:unca_work)
end