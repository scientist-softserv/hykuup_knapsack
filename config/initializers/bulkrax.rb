# frozen_string_literal: true

# Ensure Knapsack version gets loaded after Hyku's bulkrax.rb
Rails.application.config.after_initialize do
  Bulkrax.setup do |config|
    hyku_csv_field_mappings = config.field_mappings['Bulkrax::CsvParser']

    config.field_mappings['Bulkrax::CsvParser'] = hyku_csv_field_mappings.merge({
      # FIXME: these split configs don't fully work as intended
      'contributor' => { from: %w[sm_contributor contributor], split: /\s*(?<!\\),\s*/ },
      'creator' => { from: %w[sm_creator creator], split: /\s*(?<!\\),\s*/ },
      'date_created' => { from: %w[sm_date date_created], split: /\s*(?<!\\),\s*/ },
      'description' => { from: %w[tm_description description], split: /\s*(?<!\\),\s*/ },
      'identifier' => { from: %w[ss_pid identifier], split: /\s*(?<!\\),\s*/, source_identifier: true },
      'language' => { from: %w[sm_language language], split: /\s*(?<!\\),\s*/ },
      'parents' => { from: %w[sm_collection parents], split: /\s*(?<!\\),\s*/, related_parents_field_mapping: true },
      'publisher' => { from: %w[sm_publisher publisher], split: /\s*(?<!\\),\s*/ },
      'resource_type' => { from: %w[sm_type resource_type], split: /\s*(?<!\\),\s*/ },
      'source' => { from: %w[sm_source source], split: /\s*(?<!\\),\s*/ },
      'subject' => { from: %w[sm_subject subject], split: /\s*(?<!\\),\s*/ },
      'title' => { from: %w[sm_title title], split: /\s*(?<!\\),\s*/ },
      # Custom property mappings
      'collection' => { from: %w[bs_iscollection collection], split: /\s*(?<!\\),\s*/ },
      'community' => { from: %w[bs_iscommunity community], split: /\s*(?<!\\),\s*/ },
      'coverage' => { from: %w[sm_coverage coverage], split: /\s*(?<!\\),\s*/ },
      'file_format' => { from: %w[sm_format file_format], split: /\s*(?<!\\),\s*/ },
      'relation' => { from: %w[sm_relation relation], split: /\s*(?<!\\),\s*/ },
      'rights' => { from: %w[sm_rights rights], split: /\s*(?<!\\),\s*/ }
    })
  end
end
