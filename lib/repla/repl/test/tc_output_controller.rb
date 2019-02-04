#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require "test/unit"

require_relative "lib/test_setup"

require_relative "../lib/output_controller"
require_relative "../lib/view"

class TestOutputController < Test::Unit::TestCase
  
  def setup
    view = Repla::REPL::View.new
    @output_controller = Repla::REPL::OutputController.new(view)
  end
  
  def teardown
    @output_controller.view.close
  end

  def test_output_controller
    test_text = "Some test text"
    @output_controller.parse_output(test_text)
    
    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = @output_controller.view.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end

  def test_remove_escape_sequence
    test_text = "Some test text"
    @output_controller.parse_output("\x1b0000m" + test_text)
    
    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = @output_controller.view.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!

    assert_equal(test_text, result, "The test text should equal the result.")
  end
end
