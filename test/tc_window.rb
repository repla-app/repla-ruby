#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require Repla::Test::VIEW_HELPER_FILE
require_relative 'lib/test_javascript_constants'

class TestWindowAttributes < Test::Unit::TestCase
  def test_window_id
    Repla.load_plugin(Repla::Test::HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id.nil?, 'The window_id should not be nil')
    name = Repla::Test::HELLOWORLD_PLUGIN_NAME
    assert(Repla.window_id_for_plugin(name) == window_id)
    window = Repla::Window.new(window_id)
    assert(window_id == window.window_id, "The window id's should be equal.")
    window.close
  end
end

class TestWindowClose < Test::Unit::TestCase
  def test_close
    Repla.load_plugin(Repla::Test::HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::HELLOWORLD_PLUGIN_NAME)
    window = Repla::Window.new(window_id)
    window.close
    assert(Repla.window_id_for_plugin(Repla::Test::HELLOWORLD_PLUGIN_NAME).nil?,
           'The plugin should not have a window.')
  end
end

class TestWindowDoJavaScript < Test::Unit::TestCase
  def test_do_javascript
    windows = Repla::Test::ViewHelper.make_windows(
      Repla::Test::INDEX_HTML_FILENAME
    )
    windows.each do |window|
      javascript = File.read(Repla::Test::NODOM_JAVASCRIPT_FILE)
      result = window.do_javascript(javascript)
      expected = Repla::Test::Helper.run_javascript(javascript)
      assert_equal(expected.to_i, result.to_i)
      window.close
    end
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
    @window.load_file(Repla::Test::INDEX_HTML_FILE)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end

  def test_load_file_twice
    @window.load_file(Repla::Test::INDEX_HTML_FILE)
    @window.root_access_directory_path = Repla::Test::TEST_HTML_DIRECTORY
    @window.load_file(Repla::Test::INDEXJQUERY_HTML_FILE)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)

    # Also confirm that the jQuery resource loaded properly
    javascript = File.read(Repla::Test::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    test_javascript = File.read(Repla::Test::TEXT_JAVASCRIPT_FILE)
    expected = @window.do_javascript(test_javascript)

    assert_equal(expected, result, 'The result should equal expected result.')
  end
end

class TestWindowLoadHTMLWithRootAccessDirectory < Test::Unit::TestCase
  def setup
    @window = Repla::Window.new
    @window.root_access_directory_path = Repla::Test::TEST_HTML_DIRECTORY
    @window.load_file(Repla::Test::INDEXJQUERY_HTML_FILE)
  end

  def teardown
    @window.close
  end

  def test_root_access_directory
    javascript = File.read(Repla::Test::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)

    test_javascript = File.read(Repla::Test::TEXT_JAVASCRIPT_FILE)
    expected = @window.do_javascript(test_javascript)

    assert_equal(expected, result, 'The result should equal expected result.')
  end
end

class TestReplaPluginReadFromStandardInput < Test::Unit::TestCase
  def setup
    Repla.load_plugin(Repla::Test::PRINT_PLUGIN_FILE)
    Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    window_id = Repla.window_id_for_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
  end

  def test_read_from_standard_input
    test_text = 'This is a test string'
    @window.read_from_standard_input(test_text + "\n")
    # Give read from standard input time to run
    sleep Repla::Test::TEST_PAUSE_TIME

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    assert_not_nil(result)
    result.strip!

    assert_equal(test_text, result, 'The test text should equal the result.')
  end
end

class TestTwoWindows < Test::Unit::TestCase
  def setup
    Repla.load_plugin(Repla::Test::PRINT_PLUGIN_FILE)

    # Window One
    window_id_one = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window_one = Repla::Window.new(window_id_one)

    # Window Manager Two
    window_id_two = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window_two = Repla::Window.new(window_id_two)

    assert_not_equal(window_id_one, window_id_two)
  end

  def teardown
    @window_one.close
    @window_two.close
  end

  def test_two_windows
    test_text_one = 'The first test string'
    test_text_two = 'The second test string'

    @window_one.read_from_standard_input(test_text_one + "\n")
    # Give read from standard input time to run
    sleep Repla::Test::TEST_PAUSE_TIME

    @window_two.read_from_standard_input(test_text_two + "\n")
    # Give read from standard input time to run
    sleep Repla::Test::TEST_PAUSE_TIME

    # Swap the two windows to test that the window numbers persist even
    # after the window changes.
    window_id_before = Repla::Test::Helper.window_id
    assert_equal(window_id_before,
                 @window_two.window_id,
                 'The second window should be in front.')
    Repla::Test::Helper.switch_windows
    window_id_after = Repla::Test::Helper.window_id
    assert_equal(window_id_after,
                 @window_one.window_id,
                 'The first window should be in front.')
    assert_not_equal(window_id_before,
                     window_id_after,
                     'The front window should have changed.')

    # Read the window contents
    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)

    # Window Manager One
    result_one = @window_one.do_javascript(javascript)
    assert_not_nil(result_one)
    result_one.strip!

    # Window Manager Two
    result_two = @window_two.do_javascript(javascript)
    assert_not_nil(result_two)
    result_two.strip!

    assert_equal(test_text_one, result_one)
    assert_equal(test_text_two, result_two)
  end
end
