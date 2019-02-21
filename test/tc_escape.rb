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
    string = 'This is a test string
'
    result = string.shell_escape
    test_result = 'This\ is\ a\ test\ string\'
\''
    assert_equal(test_result, result)
  end

  def test_shell_escape_code
    string = 'var codeTags = document.getElementsByTagName(\'code\');
var lastCodeTag = codeTags[codeTags.length - 1];
lastCodeTag.innerHTML;'
    result = string.shell_escape
    test_result = 'var\ codeTags\ \=\ document.'\
'getElementsByTagName\(\\\'code\\\'\)\;\'
\'var\ lastCodeTag\ \=\ codeTags\[codeTags.length\ -\ 1\]\;\'
\'lastCodeTag.innerHTML\;'
    assert_equal(test_result, result)
  end

  def test_javascript_argument_word
    string = 'one'
    result = string.javascript_argument
    test_result = '\'one\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_words
    string = '1 2 3'
    result = string.javascript_argument
    test_result = '\'1 2 3\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_punctuation
    string = 'irb(main):001:0> 1 + 1'
    result = string.javascript_argument
    test_result = '\'irb(main):001:0> 1 + 1\''
    assert_equal(test_result, result)
  end

  def test_javascript_argument_html
    string = 'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew '\
      'install asdf</code>'
    result = string.javascript_argument
    test_result = '\'Using <a href="http://brew.sh/">Homebrew</a>, <code>brew '\
      'install asdf</code>\''
    assert_equal(test_result, result)
  end

  def test_javascript_escape_slashes
    string = '    eiusmod self.gsub("\'", "\\\\\\\\\'")'
    string.javascript_escape!
    test_result = '    eiusmod self.gsub("\\\'", "\\\\\\\\\\\\\\\\\\\'")'
    assert_equal(test_result, string)
  end

end

# TODO: Add test with full multi-line HTML

# ESCAPE self.javascript_escape, string =     eiusmod self.gsub("'", "\\\\'"), result =     eiusmod self.gsub("\'", "\\\\\\\\\'")
# ESCAPE javascript_escape!, self =     eiusmod self.gsub("'", "\\\\'"), result =     eiusmod self.gsub("\'", "\\\\\\\\\'")

# ESCAPE self.javascript_escape, string = WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", 'eiusmod.rb'), result = WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", \'eiusmod.rb\')
# ESCAPE javascript_escape!, self = WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", 'eiusmod.rb'), result = WCSEARCH_FILE = File.join(File.dirname(__FILE__), "..", \'eiusmod.rb\')
