# frozen_string_literal: true

module SiteDecorator
  def available_works
    concerns_to_remove = if account.mobius?
                           Hyrax.config.registered_curation_concern_types - MOBIUS_CONCERNS
                         else
                           MOBIUS_CONCERNS
                         end

    super - concerns_to_remove
  end
end

Site.prepend(SiteDecorator)
