require_relative 'view'

module Repla::Print
  class Controller < Repla::Controller

    def initialize
      @view = View.new
    end

    def parse_line(line)
      line.chomp!
      line.javascript_escape!
      javascript = %Q[addOutput('#{line}');]
      @view.do_javascript(javascript)
    end

  end
end
