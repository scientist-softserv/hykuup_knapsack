# frozen_string_literal: true

# OVERRIDE Hyku to delegate Mobius properties

Hyku::WorkShowPresenter.delegate :rights, :relation, :coverage, :file_format, to: :solr_document
