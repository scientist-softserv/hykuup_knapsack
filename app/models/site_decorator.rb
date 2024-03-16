# frozen_string_literal: true

# OVERRIDE Hyku to set tenants with appropriate works

module SiteDecorator
  def instance
    return NilSite.instance if Account.global_tenant?

    first_or_create do |site|
      account = Account.find_by(tenant: Apartment::Tenant.current)
      if account.mobius?
        site.available_works = MOBIUS_CONCERNS
      else
        site.available_works = Hyrax.config.registered_curation_concern_types - MOBIUS_CONCERNS
      end
    end
  end
end

Site.singleton_class.send(:prepend, SiteDecorator)
