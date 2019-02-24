#!/usr/bin/env ruby

require "minitest/autorun"

require_relative 'lib/test_setup.rb'

class TestClass < Minitest::Test
  def test_run_plugin_in_directory_with_arguments
    arguments = '1 2 3'
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla.load_plugin(DATA_PLUGIN_FILE)
    Repla.run_plugin(DATA_PLUGIN_NAME, path, arguments.split(' '))

    window_id = Repla.window_id_for_plugin(DATA_PLUGIN_NAME)
    window = Repla::Window.new(window_id)

    sleep Repla::Test::TEST_PAUSE_TIME # Give time for script to run

    javascript = %[valueForKey('#{DATA_PLUGIN_PATH_KEY}');]
    path_result = window.do_javascript(javascript)
    javascript = %[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');]
    arguments_result = window.do_javascript(javascript)

    assert_equal(path, path_result)
    assert_equal(arguments, arguments_result)
    window.close
  end
end
