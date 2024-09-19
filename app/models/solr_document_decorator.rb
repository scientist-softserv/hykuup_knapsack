# frozen_string_literal: true

module SolrDocumentDecorator
  def rights
    self['rights_tesim']
  end

  def coverage
    self['coverage_tesim']
  end

  def relation
    self['relation_tesim']
  end

  def file_format
    self['file_format_tesim']
  end

  def date_issued
    self['date_issued_tesim']
  end

  def document_relationship
    self['document_relationship_tesim']
  end

  def content_type
    self['content_type_tesim']
  end

  def coverage_geographic
    self['coverage_geographic_tesim']
  end

  def coverage_historic
    self['coverage_historic_tesim']
  end

  def notes
    self['notes_tesim']
  end

  def item_mask
    self['item_mask_tesim']
  end

  def item_embargo
    self['item_embargo_tesim']
  end

  def file_name
    self['file_name_tesim']
  end

  def thesis_type
    self['thesis_type_tesim']
  end

  def degree_name
    self['degree_name_tesim']
  end

  def degree_level
    self['degree_level_tesim']
  end

  def discipline
    self['discipline_tesim']
  end

  def advisor_last_name
    self['advisor_last_name_tesim']
  end

  def advisor_first_name
    self['advisor_first_name_tesim']
  end
end

SolrDocument.prepend(SolrDocumentDecorator)
