#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'minitest/autorun'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require Repla::Test::VIEW_HELPER_FILE
require_relative 'lib/test_javascript_constants'

class TestWindowAttributes < Minitest::Test
  def test_window_id
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    assert(!window_id.nil?, 'The window_id should not be nil')
    name = Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
    assert(Repla.window_id_for_plugin(name) == window_id)
    window = Repla::Window.new(window_id)
    assert(window_id == window.window_id, "The window id's should be equal.")
    window.close
  end

  def test_dark_mode
    key = Repla::DARK_MODE_KEY
    window = Repla::Window.new
    assert_nil(ENV[key])
    refute(window.dark_mode)
    window.close
    ENV[key] = '1'
    window = Repla::Window.new
    assert(window.dark_mode)
    window.close
    ENV[key] = '0'
    window = Repla::Window.new
    refute(window.dark_mode)
    window.close
  end
end

class TestWindowClose < Minitest::Test
  def test_close
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    window = Repla::Window.new(window_id)
    window.close
    assert_nil(Repla.window_id_for_plugin(
                 Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
               ))
  end
end

class TestWindowBadURL < Minitest::Test
  def test_no_server
    window = Repla::Window.new
    window.load_url(Repla::Test::NO_SERVER_URL, should_clear_cache: true)
    window.close
  end
end

class TestWindowDoJavaScript < Minitest::Test
  def setup
    @window = Repla::Window.new
    @window.load_file(Repla::Test::INDEX_HTML_FILE)
  end

  def teardown
    @window.close
  end

  def test_do_javascript
    javascript = File.read(Repla::Test::NODOM_JAVASCRIPT_FILE)
    result = @window.do_javascript(javascript)
    expected = Repla::Test::Helper.run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i)
  end
end

class TestWindowLoadHTML < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::TEST_SERVER_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_SERVER_PLUGIN_NAME,
                                 Repla::Test::TEST_HTML_DIRECTORY)
    @window = Repla::Window.new(window_id)
    assert(window_id == @window.window_id)
  end

  def teardown
    @window.close
  end

  def test_load_file_and_url
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)

    @window.load_file(Repla::Test::INDEX_HTML_FILE)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)

    @window.load_url(Repla::Test::INDEXJQUERY_HTML_URL,
                     should_clear_cache: true)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEXJQUERY_HTML_TITLE)
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

class TestWindowClearingCache < Minitest::Test
  def test_clearing_cache
    Repla.load_plugin(Repla::Test::TEST_SERVER_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_SERVER_PLUGIN_NAME,
                                 Repla::Test::TEST_HTML_DIRECTORY)
    window = Repla::Window.new(window_id)

    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      window.load_url(Repla::Test::INDEX_HTML_URL, should_clear_cache: true)
      result = Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
    window.close

    # Confirm loading the URL in a new window after the server has been killed
    # fails
    window_two = Repla::Window.new
    window_two.load_url(Repla::Test::INDEX_HTML_URL,
                        should_clear_cache: true)
    result = window_two.do_javascript(javascript)
    refute_equal(result, Repla::Test::INDEX_HTML_TITLE)
    window_two.close
  end
end

class TestWindowLoadHTMLWithRootAccessDirectory < Minitest::Test
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

class TestReplaPluginReadFromStandardInput < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::PRINT_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
  end

  def test_read_from_standard_input
    test_text = 'This is a test string'
    @window.read_from_standard_input(test_text + "\n")

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      !result.nil?
    end
    result.strip!

    assert_equal(test_text, result, 'The test text should equal the result.')
  end
end

class TestTwoWindows < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::PRINT_PLUGIN_FILE)

    # Window One
    window_id_one = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window_one = Repla::Window.new(window_id_one)

    # Window Manager Two
    window_id_two = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    @window_two = Repla::Window.new(window_id_two)

    refute_equal(window_id_one, window_id_two)
  end

  def teardown
    @window_one.close
    @window_two.close
  end

  def test_two_windows
    test_text_one = 'The first test string'
    test_text_two = 'The second test string'
    @window_one.read_from_standard_input(test_text_one + "\n")
    @window_two.read_from_standard_input(test_text_two + "\n")

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result_one = nil
    result_two = nil
    Repla::Test.block_until do
      result_one = @window_one.do_javascript(javascript)
      result_two = @window_two.do_javascript(javascript)
      !result_one.nil? && !result_two.nil?
    end

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
    refute_equal(window_id_before,
                 window_id_after,
                 'The front window should have changed.')
    result_one.strip!
    result_two.strip!
    assert_equal(test_text_one, result_one)
    assert_equal(test_text_two, result_two)
  end
end
