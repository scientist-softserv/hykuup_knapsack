# frozen_string_literal: true
# Use this to override any Hyrax configuration from the Knapsack
Rails.application.config.after_initialize do
  Hyrax.config do |config|
    config.register_curation_concern :mobius_work
  end
end
