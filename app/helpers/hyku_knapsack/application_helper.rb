# frozen_string_literal: true

module HykuKnapsack
  module ApplicationHelper
    def tenant_registered_curation_concern_types
      if current_account.mobius?
        MOBIUS_CONCERNS
      else
        Hyrax.config.registered_curation_concern_types - MOBIUS_CONCERNS
      end
    end
  end
end
