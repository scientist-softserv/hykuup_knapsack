# frozen_string_literal: true

# OVERRIDE Account to add utility method to check if a tenant is apart of Mobius
module AccountDecorator
  MOBIUS_TENANTS = %w[
    atsu
    ccis
    covenant
    crowder
    eastcentral
    jewell
    kenrick
    mbts
    mobap
    mobius-search
    moval
    mssu
    nwmsu
    sbuniv
    stlcc
    truman
    webster
  ].freeze

  def mobius?
    MOBIUS_TENANTS.include?(name)
  end
end

Account.prepend(AccountDecorator)
