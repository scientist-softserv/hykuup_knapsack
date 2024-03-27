# frozen_string_literal: true

# Ensure Knapsack version gets loaded after Hyku's bulkrax.rb
Rails.application.config.after_initialize do
  # OVERRIDE Bulkrax v5.4.1
  # Override default split regex to only split on unescaped comma and pipe chars
  Bulkrax.instance_variable_set(:@multi_value_element_split_on, /\s*(?<!\\)[,|]\s*/)

  Bulkrax.setup do |config|
    hyku_csv_field_mappings = config.field_mappings['Bulkrax::CsvParser']

    config.field_mappings['Bulkrax::CsvParser'] = hyku_csv_field_mappings.merge({
      'contributor' => { from: %w[sm_contributor contributor], split: true },
      'creator' => { from: %w[sm_creator creator], split: true },
      'date_created' => { from: %w[sm_date date_created], split: true },
      'description' => { from: %w[tm_description description], split: true },
      'identifier' => { from: %w[identifier], split: true, source_identifier: true },
      'language' => { from: %w[sm_language language], split: true },
      'parents' => { from: %w[sm_collection parents], split: true, related_parents_field_mapping: true },
      'publisher' => { from: %w[sm_publisher publisher], split: true },
      'resource_type' => { from: %w[sm_type resource_type], split: true },
      'source' => { from: %w[sm_source source], split: true },
      'subject' => { from: %w[sm_subject subject], split: true },
      'title' => { from: %w[sm_title title], split: true },
      # Custom property mappings
      'coverage' => { from: %w[sm_coverage coverage], split: true },
      'file_format' => { from: %w[sm_format file_format], split: true },
      'relation' => { from: %w[sm_relation relation], split: true },
      'rights' => { from: %w[sm_rights rights], split: true }
    })
  end
end
