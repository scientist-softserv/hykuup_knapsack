MOBIUS_CONCERNS = ['MobiusWork'].freeze

Hyrax.config do |config|
  config.register_curation_concern MOBIUS_CONCERNS.map { |concern| concern.underscore.to_sym }
end
