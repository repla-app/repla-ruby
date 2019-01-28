module Repla::REPL
  class View < Repla::View

    ROOT_ACCESS_PATH = File.join(File.dirname(__FILE__), "../html")
    VIEW_TEMPLATE = File.join(ROOT_ACCESS_PATH, 'index.html')
    def initialize
      super
      self.root_access_directory_path = File.expand_path(ROOT_ACCESS_PATH)
      load_file(VIEW_TEMPLATE)
    end

    ADD_INPUT_JAVASCRIPT_FUNCTION = "WcREPL.addInput"
    def add_input(input)
      do_javascript_function(ADD_INPUT_JAVASCRIPT_FUNCTION, [input])      
    end
    
    ADD_OUTPUT_JAVASCRIPT_FUNCTION = "WcREPL.addOutput"
    def add_output(output)
      do_javascript_function(ADD_OUTPUT_JAVASCRIPT_FUNCTION, [output])      
    end

  end
end
