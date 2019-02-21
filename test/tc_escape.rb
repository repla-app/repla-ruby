#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative '../lib/repla/lib/escape.rb'

# Test escape
class TestEscape < Test::Unit::TestCase
  using Escape
  def test_shell_escape_path
    string = '/../../applescript/exists.scpt'
    result = string.shell_escape
    test_result = '/../../applescript/exists.scpt'
    assert_equal(test_result, result)
  end

  def test_shell_escape_string
    string = 'This is a test string'
    result = string.shell_escape
    test_result = 'result = This\ is\ a\ test\ string\'
\''
    assert_equal(test_result, result)
  end
end
