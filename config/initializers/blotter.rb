module ActiveRecord
  class Base
    def self.blotter(blotter_art_method)
      blotter_model = caller[0][/`<class:([^']*)>'/, 1]
      Blotter.register_blotter_model(blotter_model.safe_constantize)
      Blotter.register_blotter_art_method(blotter_art_method)
    end
  end
end