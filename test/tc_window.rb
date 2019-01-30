#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_constants'
require_relative '../lib/repla'
require Repla.shared_test_resource('ruby/test_constants')
require Repla::Tests::TEST_HELPER_FILE

class TestWindowAttributes < Test::Unit::TestCase
  def test_window_id
    Repla.load_plugin(Repla::Tests::HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id.nil?, 'The window_id should not be nil')
    assert(Repla.window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME) == window_id, "The window_id's should be equal")
    window = Repla::Window.new(window_id)
    assert(window_id == window.window_id, "The window id's should be equal.")
    window.close
  end
end

class TestWindowClose < Test::Unit::TestCase
  def test_close
    Repla.load_plugin(Repla::Tests::HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    window = Repla::Window.new(window_id)
    window.close
    assert(Repla.window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME).nil?, 'The plugin should not have a window.')
  end
end

class TestWindowDoJavaScript < Test::Unit::TestCase
  def setup
    @window = Repla::Window.new
    @window.load_file(Repla::Tests::INDEX_HTML_FILE)
  end

  def teardown
    @window.close
  end

  def test_do_javascript
    javascript = File.read(Repla::Tests::NODOM_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    expected = Repla::Tests::Helper.run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i, 'The result should match expected result.')
  end
end

class TestWindowLoadHTML < Test::Unit::TestCase
  def setup
    window_id = Repla.create_window
    @window = Repla::Window.new(window_id)
    assert(window_id == @window.window_id)
  end

  def teardown
    @window.close
  end

  def test_load_file
    test_text = 'This is a test string'
    html = '<html><body>' + test_text + '</body></html>'
    @window.load_html(html)

    javascript = File.read(Repla::Tests::BODY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    assert_equal(test_text, result, 'The result should match the test string.')
  end

  def test_load_file_twice
    test_text = 'This is a test string'
    html = '<html><body>' + test_text + '</body></html>'
    @window.load_html(html)

    test_text = 'This is a test string 2'
    html = '<html><body>' + test_text + '</body></html>'
    @window.load_html(html)

    javascript = File.read(Repla::Tests::BODY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    assert_equal(test_text, result, 'The result should match the test string.')
  end
end

class TestWindowLoadHTMLWithBaseURL < Test::Unit::TestCase
  def setup
    @window = Repla::Window.new
    @window.root_access_directory_url = Repla::Tests::TEST_HTML_DIRECTORY
    @window.load_file(Repla::Tests::INDEXJQUERY_HTML_FILE)
  end

  def teardown
    @window.close
  end

  def test_load_with_base_url
    javascript = File.read(Repla::Tests::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    test_javascript = File.read(Repla::Tests::TEXT_JAVASCRIPT_FILE)
    expected = @window.do_javascript(test_javascript)

    assert_equal(expected, result, 'The result should equal expected result.')
  end
end

class TestReplaPluginReadFromStandardInput < Test::Unit::TestCase
  def setup
    Repla.load_plugin(Repla::Tests::PRINT_PLUGIN_FILE)
    Repla.run_plugin(Repla::Tests::PRINT_PLUGIN_NAME)
    window_id = Repla.window_id_for_plugin(Repla::Tests::PRINT_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Repla::Tests::Helper.confirm_dialog
  end

  def test_read_from_standard_input
    test_text = 'This is a test string'
    @window.read_from_standard_input(test_text + "\n")
    sleep Repla::Tests::TEST_PAUSE_TIME # Give read from standard input time to run

    javascript = File.read(Repla::Tests::LASTCODE_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!

    assert_equal(test_text, result, 'The test text should equal the result.')
  end
end

class TestTwoWindows < Test::Unit::TestCase
  def setup
    Repla.load_plugin(Repla::Tests::PRINT_PLUGIN_FILE)

    # Window One
    window_id_one = Repla.run_plugin(Repla::Tests::PRINT_PLUGIN_NAME)
    @window_one = Repla::Window.new(window_id_one)

    # Window Manager Two
    window_id_two = Repla.run_plugin(Repla::Tests::PRINT_PLUGIN_NAME)
    @window_two = Repla::Window.new(window_id_two)

    assert_not_equal(window_id_one, window_id_two, 'Window managers one and two should have different window ids.')
  end

  def teardown
    @window_one.close
    Repla::Tests::Helper.confirm_dialog

    @window_two.close
    Repla::Tests::Helper.confirm_dialog
  end

  def test_two_windows
    test_text_one = 'The first test string'
    test_text_two = 'The second test string'

    @window_one.read_from_standard_input(test_text_one + "\n")
    sleep Repla::Tests::TEST_PAUSE_TIME # Give read from standard input time to run

    @window_two.read_from_standard_input(test_text_two + "\n")
    sleep Repla::Tests::TEST_PAUSE_TIME # Give read from standard input time to run

    # Swap the two windows to test that the window numbers persist even
    # after the window changes.
    window_id_before = Repla::Tests::Helper.window_id
    assert_equal(window_id_before, @window_two.window_id, 'The second window should be in front.')
    Repla::Tests::Helper.switch_windows
    window_id_after = Repla::Tests::Helper.window_id
    assert_equal(window_id_after, @window_one.window_id, 'The first window should be in front.')
    assert_not_equal(window_id_before, window_id_after, 'The front window should have changed.')

    # Read the window contents
    javascript = File.read(Repla::Tests::LASTCODE_JAVASCRIPT_FILE)

    # Window Manager One
    result_one = @window_one.do_javascript(javascript)
    assert_not_nil(result_one)
    result_one.strip!

    # Window Manager Two
    result_two = @window_two.do_javascript(javascript)
    assert_not_nil(result_two)
    result_two.strip!

    assert_equal(test_text_one, result_one, 'The first test text should equal the first result.')
    assert_equal(test_text_two, result_two, 'The second test text should equal the second result.')
  end
end
