#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/test_constants"
require REPLA_FILE

require Repla::shared_test_resource("ruby/test_constants")
require Repla::Tests::TEST_HELPER_FILE

class TestClass < Test::Unit::TestCase

  def test_run_plugin_in_directory_with_arguments
    arguments = "1 2 3"    
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla::load_plugin(DATA_PLUGIN_FILE)
    Repla::run_plugin(DATA_PLUGIN_NAME, path, arguments.split(" "))    

    window_id = Repla::window_id_for_plugin(DATA_PLUGIN_NAME)
    window = Repla::Window.new(window_id)

    sleep Repla::Tests::TEST_PAUSE_TIME # Give time for script to run
    
    path_result = window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_PATH_KEY}');])
    arguments_result = window.do_javascript(%Q[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');])
    
    assert_equal(path_result, path, "The path result should match the path.")
    assert_equal(arguments_result, arguments, "The arguments result should match the arguments.")
    window.close
  end

end
