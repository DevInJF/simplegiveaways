require 'mustache'

module Views
  module FacebookPages  
    class Show < Mustache

      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TagHelper
      include ActionController::PolymorphicRoutes
      include ActionController::UrlWriter

      attr_accessor :page

      def initialize(page)
        @page = page
      end

      def path
        url_for(page)
      end

      def name
        @page.name
      end

      def avatar_square
        @page.avatar_square
      end

      def likes
        @page.likes
      end
    end
  end
end