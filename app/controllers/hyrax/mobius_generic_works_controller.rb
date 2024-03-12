# Generated via
#  `rails generate hyrax:work MobiusGenericWork`
module Hyrax
  # Generated controller for MobiusGenericWork
  class MobiusGenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::MobiusGenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::MobiusGenericWorkPresenter
  end
end
