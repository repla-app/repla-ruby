module Repla::Data
  class View < Repla::View
    ROOT_ACCESS_DIRECTORY = File.join(File.dirname(__FILE__), "../html")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'index.html')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_file(VIEW_TEMPLATE)
    end

    ADD_KEY_VALUE_JAVASCRIPT_FUNCTION = "addKeyValue"
    def add_key_value(key, value)
      do_javascript_function(ADD_KEY_VALUE_JAVASCRIPT_FUNCTION, [key, value])
    end
    
    VALUE_FOR_KEY_JAVASCRIPT_FUNCTION = "valueForKey"
    def value_for_key(key)
      value = do_javascript_function(VALUE_FOR_KEY_JAVASCRIPT_FUNCTION, [key])
      value.chomp!
      return value
    end
  end
end
