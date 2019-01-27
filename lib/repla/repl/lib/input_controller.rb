module Repla::REPL
  class InputController < Repla::Controller

    attr_accessor :view
    def initialize(view)
      @view = view
    end

    def parse_input(input)
      input = input.dup
      input.chomp!
      if !input.strip.empty? # Ignore empty lines
        @view.add_input(input)
      end
    end

  end
end
