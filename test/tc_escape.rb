#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative '../lib/repla/lib/escape.rb'

class TestEscape < Test::Unit::TestCase
  using Escape
end

