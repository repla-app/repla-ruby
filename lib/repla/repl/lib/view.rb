module Repla::REPL
  class View < Repla::View

    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')
    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_erb_from_path(VIEW_TEMPLATE)
    end

    ADD_INPUT_JAVASCRIPT_FUNCTION = "WcREPL.addInput"
    def add_input(input)
      do_javascript_function(ADD_INPUT_JAVASCRIPT_FUNCTION, [input])      
    end
    
    ADD_OUTPUT_JAVASCRIPT_FUNCTION = "WcREPL.addOutput"
    def add_output(output)
      do_javascript_function(ADD_OUTPUT_JAVASCRIPT_FUNCTION, [output])      
    end

    # Helpers to allow easy loading of REPL resource even from another base URL

    def repl_header_tags
      %Q[
    #{repl_stylesheet_link_tag}
    #{repl_handlebars_template_tags}
    #{shared_javascript_include_tag("handlebars")}
  	#{shared_javascript_include_tag("zepto")}
    #{repl_javascript_include_tag}
      ]
    end

    def repl_handlebars_template_tags
      %Q[
    <script id="output-template" type="text/x-handlebars-template">
  		<pre class="output"><code>{{code}}</code></pre>
  	</script>
  	<script id="input-template" type="text/x-handlebars-template">
  		<pre><code>{{code}}</code></pre>
  	</script>]
    end

    def repl_stylesheet_link_tag
      path = File.join(repl_base_resource_path, "css/style.css")
      url = repl_url_for_path(path)
      stylesheet_link_tag(url)
    end

    def repl_javascript_include_tag
      path = File.join(repl_base_resource_path, "js/wcrepl.js")
      url = repl_url_for_path(path)
      javascript_include_tag(url)
    end

    require 'open-uri'
    def repl_url_for_path(path)
      uri = URI::encode(path)
      "file://" + uri
    end

    def repl_base_resource_path
      File.expand_path(File.join(File.dirname(__FILE__), "../"))
    end

  end
end
