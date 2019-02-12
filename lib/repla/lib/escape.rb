require 'Shellwords'

module Escape
  module FloatEscape
    def javascript_argument
      to_s
    end
  end
  module IntegerEscape
    def javascript_argument
      to_s
    end
  end

  module StringEscape
    def javascript_argument
      "'#{StringEscape.javascript_escape(self)}'"
    end

    def javascript_escape
      StringEscape.javascript_escape(self)
    end

    def javascript_escape!
      replace(StringEscape.javascript_escape(self))
    end

    def float?
      true if Float(self)
    rescue StandardError
      false
    end

    def integer?
      to_i.to_s == self
    end

    def shell_escape
      StringEscape.shell_escape(self)
    end

    def shell_escape!
      replace(StringEscape.shell_escape(self))
    end

    private

    def self.javascript_escape(string)
      string.gsub('\\', '\\\\\\\\').gsub("\n", '\\\\n').gsub("'", "\\\\'")
    end

    def self.shell_escape(string)
      Shellwords.escape(string)
    end
  end

  refine String do
    include StringEscape
  end

  refine Integer do
    include IntegerEscape
  end

  refine Float do
    include FloatEscape
  end
end
