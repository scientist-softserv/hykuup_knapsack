# frozen_string_literal: true

# OVERRIDE Hyku to delegate Mobius properties
Hyku::WorkShowPresenter.delegate :rights, :relation, :coverage, :file_format, :date_published, to: :solr_document
