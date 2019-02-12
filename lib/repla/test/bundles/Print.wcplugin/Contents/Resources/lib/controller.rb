require_relative 'view'
require_relative '../../../../../../lib/escape'

module Repla::Print
  using Escape
  class Controller < Repla::Controller
    def initialize
      @view = View.new
    end

    def parse_line(line)
      line.chomp!
      line.javascript_escape!
      javascript = %[addOutput('#{line}');]
      @view.do_javascript(javascript)
    end
  end
end
