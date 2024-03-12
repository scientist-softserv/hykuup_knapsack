Hyrax.config do |config|
  # Injected via `rails g hyrax:work MobiusGenericWork`
  config.register_curation_concern :mobius_generic_work
  # Injected via `rails g hyrax:work MobiusImage`
  config.register_curation_concern :mobius_image
end
