# frozen_string_literal: true

module Bulkrax
  # OVERRIDE Bulkax v7.0.0 to add model to collections so CsvCollectionEntry objects are properly created
  module CsvParserDecorator
    def records(_opts = {})
      super unless Account.find_by(tenant: Apartment::Tenant.current).mobius?

      records = super
      records.each do |record|
        if (record[:bs_isCommunity] || record[:bs_isCollection])&.downcase == 'true'
          record[:model] =
            Hyrax.config.collection_model
        end
      end
    end
  end
end

Bulkrax::CsvParser.prepend(Bulkrax::CsvParserDecorator)
