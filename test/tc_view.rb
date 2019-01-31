#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_constants'
require_relative '../lib/repla'
require_relative 'resources/lib/repla_tests.rb'
require_relative 'resources/lib/repla_tests_helper.rb'

class TestViewAttributes < Test::Unit::TestCase
  def test_view_id
    Repla.load_plugin(Repla::Tests::HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id.nil?)
    split_id = Repla.split_id_in_window(window_id)
    assert(!split_id.nil?)
    split_id_two = Repla.split_id_in_window(window_id,
                                            Repla::Tests::
                                            HELLOWORLD_PLUGIN_NAME)
    assert(!split_id_two.nil?)
    assert(split_id == split_id_two)
    split_id_three = Repla.split_id_in_window_last(window_id)
    assert(split_id != split_id_three)

    view = Repla::View.new(window_id, split_id)
    assert(split_id == view.view_id)
    assert(window_id == view.window_id)

    view.close
  end
end

class TestViewDoJavaScript < Test::Unit::TestCase
  def setup
    @view = Repla::Window.new
    @view.load_file(Repla::Tests::INDEX_HTML_FILE)
  end

  def teardown
    @view.close
  end

  def test_do_javascript
    javascript = File.read(Repla::Tests::NODOM_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)
    expected = Repla::Tests::Helper.run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i,
                 'The result should match expected result.')
  end
end

class TestTwoViews < Test::Unit::TestCase
  def setup
    window = Repla::Window.new
    @view_one = Repla::View.new(window.window_id, window.split_id)
    @view_two = Repla::View.new(window.window_id, window.split_id_last)
  end

  def teardown
    @view_one.close
  end

  def test_load_file
    @view_one.load_file(Repla::Tests::INDEX_HTML_FILE)
    @view_two.load_file(Repla::Tests::INDEXJQUERY_HTML_FILE)

    javascript = File.read(Repla::Tests::TITLE_JAVASCRIPT_FILE)
    result = @view_one.do_javascript(javascript)
    assert_equal(result, Repla::Tests::INDEX_HTML_TITLE)

    result = @view_two.do_javascript(javascript)
    assert_equal(result, Repla::Tests::INDEXJQUERY_HTML_TITLE)
  end
end

class TestTwoViewsReadFromStandardInput < Test::Unit::TestCase
  def setup
    Repla.load_plugin(Repla::Tests::PRINT_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Tests::PRINT_PLUGIN_NAME)
    window = Repla::Window.new(window_id)

    split_id = Repla.run_plugin_in_split(Repla::Tests::PRINT_PLUGIN_NAME,
                                         window_id, window.split_id_last)
    assert(window.split_id_last, split_id)

    @view_one = Repla::View.new(window.window_id, window.split_id)
    @view_two = Repla::View.new(window.window_id, window.split_id_last)
  end

  def teardown
    @view_one.close
    Repla::Tests::Helper.confirm_dialog
  end

  def test_read_from_standard_input
    test_text_one = 'This is a test string'
    @view_one.read_from_standard_input(test_text_one + "\n")
    # Give read from standard input time to run
    sleep Repla::Tests::TEST_PAUSE_TIME

    test_text_two = 'This is a test string two'
    @view_two.read_from_standard_input(test_text_two + "\n")
    # Give read from standard input time to run
    sleep Repla::Tests::TEST_PAUSE_TIME

    javascript = File.read(Repla::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @view_one.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!
    assert_equal(test_text_one, result,
                 'The test text should equal the result.')

    result = @view_two.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!
    assert_equal(test_text_two, result,
                 'The test text should equal the result.')
  end
end
