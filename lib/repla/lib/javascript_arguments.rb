module JavaScriptArguments
  module IntegerJavaScriptArgument
    def javascript_argument
      to_s
    end
  end

  module StringJavaScriptArgument
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

  refine String do
    include StringJavaScriptArgument
  end

  refine Integer do
    include IntegerJavaScriptArgument
  end
end
