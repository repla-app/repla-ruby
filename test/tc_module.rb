#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

class TestModuleProperties < Minitest::Test
  def test_window_id
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)

    # Test the window_id is nil before running the plugin
    window_id = Repla.window_id_for_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    assert(!window_id, 'The window_id should be nil')

    Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    window_id = Repla.window_id_for_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    assert(window_id, 'The window_id should not be nil')

    window = Repla::Window.new(window_id)
    window.close

    # Test the window_id is nil after closing the window
    window_id = Repla.window_id_for_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    assert_nil(window_id, 'The window_id should be nil')
  end

  def test_exists
    exists = Repla.application_exists
    assert(exists, 'The Repla application should exist.')
  end
end

class TestModuleRunPlugin < Minitest::Test
  def teardown
    @window.close
  end

  def test_environment
    Repla.load_plugin(Repla::Test::TEST_ENVIRONMENT_PLUGIN_FILE)
    Repla.run_plugin(Repla::Test::TEST_ENVIRONMENT_PLUGIN_NAME)

    window_id = Repla.window_id_for_plugin(
      Repla::Test::TEST_ENVIRONMENT_PLUGIN_NAME
    )
    refute_nil(window_id)

    # Clean up
    @window = Repla::Window.new(window_id)
  end

  def test_run_plugin
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)
    Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)

    window_id = Repla.window_id_for_plugin(
      Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
    )
    refute_nil(window_id)

    # Clean up
    @window = Repla::Window.new(window_id)
  end

  def test_run_plugin_in_directory_with_arguments
    arguments = '1 2 3'
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla.load_plugin(DATA_PLUGIN_FILE)
    Repla.run_plugin(DATA_PLUGIN_NAME, path, arguments.split(' '))
    window_id = Repla.window_id_for_plugin(DATA_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)

    javascript = %[valueForKey('#{DATA_PLUGIN_PATH_KEY}');]
    path_result = nil
    Repla::Test.block_until do
      path_result = @window.do_javascript(javascript)
      path == path_result
    end

    javascript = %[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');]
    arguments_result = @window.do_javascript(javascript)

    assert_equal(path_result, path)
    assert_equal(arguments_result, arguments)
  end
end
