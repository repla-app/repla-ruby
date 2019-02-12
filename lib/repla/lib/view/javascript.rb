module Repla
  class View < Window
    def do_javascript_function(function, arguments = nil)
      javascript = self.class.javascript_function(function, arguments)
      do_javascript(javascript)
    end

    def self.javascript_function(function, arguments = nil)
      function = function.dup
      function << '('

      if arguments
        arguments.each do |argument|
          function << if argument
                        argument.javascript_argument
                      else
                        'null'
                      end
          function << ', '
        end
        function = function[0...-2]
      end

      function << ');'
    end

    private

    class ::Fixnum
      def javascript_argument
        to_s
      end
    end

    class ::String
      def javascript_argument
        "'#{javascript_escape}'"
      end

      def javascript_escape
        gsub('\\', '\\\\\\\\').gsub("\n", '\\\\n').gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(javascript_escape)
      end
    end
  end
end
