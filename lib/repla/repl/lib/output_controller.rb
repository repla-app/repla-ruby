module Repla::REPL
  class OutputController < Repla::Controller

    attr_accessor :view
    def initialize(view)
      @view = view
    end

    def parse_output(output)
      output = output.dup
      output.gsub!(/\x1b[^m]*m/, "") # Remove escape sequences
      output.chomp!
      if !output.strip.empty? # Ignore empty lines
        @view.add_output(output)
      end
    end

  end
end
