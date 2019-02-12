#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_setup'

require_relative '../lib/input_controller'
require_relative '../lib/view'

class TestInputController < Test::Unit::TestCase
  def test_input_controller
    view = Repla::REPL::View.new
    input_controller = Repla::REPL::InputController.new(view)

    test_text = 'Some test text'
    input_controller.parse_input(test_text)

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = input_controller.view.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!

    assert_equal(test_text, result, 'The test text should equal the result.')

    input_controller.view.close
  end
end
