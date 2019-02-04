#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require "test/unit"

require_relative "lib/test_setup"

require Repla::Tests::TEST_HELPER_FILE

require_relative "../../repl"

class TestREPL < Test::Unit::TestCase
  def test_repl
    wrapper = Repla::REPL::Wrapper.new("irb")

    test_text = "1 + 1"
    test_result = "2"

    wrapper.parse_input(test_text + "\n")

    sleep Repla::Tests::TEST_PAUSE_TIME # Pause for output to be processed

    window_id = Repla::Tests::Helper::window_id
    window = Repla::Window.new(window_id)

    # Test Wrapper Input
    javascript = File.read(Repla::Tests::FIRSTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!
    assert_equal(test_text, result, "The test text should equal the result.")

    # Test Wrapper Output
    javascript = File.read(Repla::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!
    result.sub!("=&gt; ", "") # Remove the prompt that irb adds    
    assert_equal(result, test_result, "The test result should equal the result.")

    window.close
  end

end
