# frozen_string_literal: true

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
end

Account.prepend(AccountDecorator)
