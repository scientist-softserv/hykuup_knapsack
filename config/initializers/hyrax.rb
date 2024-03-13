MOBIUS_CONCERNS = %w[
  MobiusGenericWork
  MobiusImage
].freeze

Hyrax.config do |config|
  config.register_curation_concern [MOBIUS_CONCERNS.map { |c| c.underscore.to_sym }]
end
