#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "../lib/repla"

require_relative "../test/resources/lib/repla_tests.rb"
require Repla::Tests::TEST_HELPER_FILE

class TestReplaProperties < Test::Unit::TestCase

  def test_window_id
    Repla::load_plugin(Repla::Tests::HELLOWORLD_PLUGIN_FILE)
    
    # Test the window_id is nil before running the plugin
    window_id = Repla::window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id, "The window_id should be nil")

    Repla::run_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    window_id = Repla::window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(window_id, "The window_id should not be nil")

    window = Repla::Window.new(window_id)
    window.close

    # Test the window_id is nil after closing the window
    window_id = Repla::window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(!window_id, "The window_id should be nil")
  end

  def test_exists
    exists = Repla::application_exists
    assert(exists, "The Web Console application should exist.")
  end

  # Shared Resources

  SHAREDRESOURCESPLUGIN_NAME = "Shared Resources"
  def test_resource_path_for_plugin
    resource_path = Repla::resource_path_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_file = File.join(resource_path, Repla::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  def test_shared_resources_path
    resource_path = Repla::shared_resources_path
    test_file = File.join(resource_path, Repla::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end
  SHARED_TEST_RESOURCE_PATH_COMPONENT = "ruby/test_constants.rb"
  def test_shared_test_resources_path
    resource_path = Repla::shared_test_resources_path
    test_file = File.join(resource_path, SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(test_file), "The test file should exist.")
  end

  def test_shared_resource
    resource_path = Repla::shared_resource(Repla::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  def test_shared_test_resource
    resource_path = Repla::shared_test_resource(SHARED_TEST_RESOURCE_PATH_COMPONENT)
    assert(File.file?(resource_path), "The test file should exist.")
  end
  
  require 'open-uri'
  def test_resource_url
    resource_url = Repla::resource_url_for_plugin(SHAREDRESOURCESPLUGIN_NAME)
    test_url = URI.join(resource_url, Repla::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_url_string = test_url.to_s
    test_url_string.sub!(%r{^file:}, '')
    test_url_string.sub!(%r{^//localhost}, '') # For 10.8
    test_file = URI.unescape(test_url_string)

    assert(File.file?(test_file), "The test file should exist.")
  end
  def test_shared_resources_url
    resource_url = Repla::shared_resources_url
    test_url = URI.join(resource_url, Repla::Tests::TEST_SHARED_RESOURCE_PATH_COMPONENT)

    # Ruby doesn't handle file URLs so convert the file URL to a path
    # File URLs aren't supported by 'open-uri' but file paths are
    test_url_string = test_url.to_s
    test_url_string.sub!(%r{^file:}, '')
    test_url_string.sub!(%r{^//localhost}, '') # For 10.8
    test_file = URI.unescape(test_url_string)

    assert(File.file?(test_file), "The test file should exist.")
  end
end

class TestReplaRunPlugin < Test::Unit::TestCase

  def teardown
    @window.close
  end

  def test_run_plugin
    Repla::load_plugin(Repla::Tests::HELLOWORLD_PLUGIN_FILE)
    Repla::run_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)

    window_id = Repla::window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    assert(window_id != nil, "The plugin should have a window.")

    # Clean up
    window_id = Repla::window_id_for_plugin(Repla::Tests::HELLOWORLD_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)
  end

  def test_run_plugin_in_directory_with_arguments
    arguments = "1 2 3"    
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla::load_plugin(DATA_PLUGIN_FILE)
    Repla::run_plugin(DATA_PLUGIN_NAME, path, arguments.split(" "))    
    window_id = Repla::window_id_for_plugin(DATA_PLUGIN_NAME)
    @window = Repla::Window.new(window_id)

    sleep Repla::Tests::TEST_PAUSE_TIME # Give time for script to run

    path_result = @window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_PATH_KEY}');])
    arguments_result = @window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');])

    assert_equal(path_result, path, "The path result should match the path.")
    assert_equal(arguments_result, arguments, "The arguments result should match the arguments.")
  end

end

