# frozen_string_literal: true

# OVERRIDE Hyku to delegate Mobius properties
# OVERRIDE Hyku to delegate Mobius property :date_published
Hyku::WorkShowPresenter.delegate :rights, :relation, :coverage, :file_format, :date_published, to: :solr_document
