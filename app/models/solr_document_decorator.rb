# frozen_string_literal: true

module SolrDocumentDecorator
  def rights
    self['rights_tesim']
  end
end

SolrDocument.prepend(SolrDocumentDecorator)
