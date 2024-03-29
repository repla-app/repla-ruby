module Repla
  module REPL
    # Output controller
    class OutputController < Repla::Controller
      attr_accessor :view
      def initialize(view)
        @view = view
      end

      def parse_output(output)
        output = output.dup
        output.gsub!(/\x1b[^mhl]*[mhl]/, '') # Remove escape sequences
        output.strip!
        output.lstrip!
        @view.add_output(output) unless output.strip.empty? # Ignore empty lines
      end
    end
  end
end
