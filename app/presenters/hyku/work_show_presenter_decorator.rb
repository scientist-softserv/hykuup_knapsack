# frozen_string_literal: true

# OVERRIDE Hyku to delegate Mobius properties
Hyku::WorkShowPresenter.class_eval do
  delegate :date_published, to: :solr_document
end
