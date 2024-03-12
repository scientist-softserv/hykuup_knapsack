# Generated via
#  `rails generate hyrax:work MobiusImage`
module Hyrax
  # Generated controller for MobiusImage
  class MobiusImagesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::MobiusImage

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::MobiusImagePresenter
  end
end
