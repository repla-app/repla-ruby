#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'
require_relative '../lib/repla/logger/test/lib/log_helper'
require_relative '../lib/repla/test/packages/TestEnvironment.replaplugin/'\
  'Contents/Resources/constants.rb'

class TestModuleProperties < Minitest::Test
  def test_window_id
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)

    # Test the window_id is nil before running the plugin
    window_id = Repla.window_id_for_plugin(
      Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
    )
    assert(!window_id, 'The window_id should be nil')

    Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    window_id = Repla.window_id_for_plugin(
      Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
    )
    assert(window_id, 'The window_id should not be nil')

    window = Repla::Window.new(window_id)
    window.close

    # Test the window_id is nil after closing the window
    window_id = Repla.window_id_for_plugin(
      Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME
    )
    assert_nil(window_id, 'The window_id should be nil')
  end

  def test_exists
    exists = Repla.application_exists
    assert(exists, 'The Repla application should exist.')
  end

  def test_clean_path
    test_path_prefix = Repla::Test::TEST_DIRECTORY + ':'
    refute_nil(ENV['PATH'])
    original_path = ENV['PATH']
    assert_nil(ENV[Repla::PATH_PREFIX])
    ENV['PATH'] = test_path_prefix + ENV['PATH']
    ENV[Repla::PATH_PREFIX] = test_path_prefix
    result = `echo $PATH`
    assert(result.start_with?(test_path_prefix))
    Repla.clean_path
    result = `echo $PATH`
    refute(result.start_with?(test_path_prefix))
    assert_equal(ENV['PATH'], original_path)
  end
end

class TestModuleRunPlugin < Minitest::Test
  # def teardown
  #   @window.close
  # end

  TEST_ENVIRONMENT_END_REGEXP = Regexp.new('^\d*.\d\d tests.*').freeze
  TEST_ENVIRONMENT_OFFSET = 4
  TEST_ENVIRONMENT_FAILURES_INDEX = 2
  TEST_ENVIRONMENT_ERRORS_INDEX = 3
  def test_environment
    Repla.load_plugin(Repla::Test::TEST_ENVIRONMENT_PLUGIN_FILE)
    window_id = Repla.run_plugin_with_environment(
      Repla::Test::TEST_ENVIRONMENT_PLUGIN_NAME,
      "#{TEST_MESSAGE_KEY}=#{TEST_MESSAGE_VALUE}"
    )
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)

    test_log_helper = Repla::Test::LogHelper.new(window_id)
    summary_message = nil
    default_timeout = Repla::Test::TEST_TIMEOUT_TIME
    timeout = default_timeout * 2.0
    Repla::Test.block_until_with_timeout(timeout, default_timeout) do
      message_count = test_log_helper.number_of_log_messages
      next if message_count < TEST_ENVIRONMENT_OFFSET

      ending_index = message_count
      starting_index = message_count - TEST_ENVIRONMENT_OFFSET
      (starting_index..ending_index).each do |i|
        message = test_log_helper.log_message_at(i)
        if message =~ TEST_ENVIRONMENT_END_REGEXP
          summary_message = message
          next true
        end
      end
    end
    puts "summary_message = #{summary_message}"
    refute_nil(summary_message)
    stats = summary_message.split(',')
    errors_message = stats[TEST_ENVIRONMENT_ERRORS_INDEX]
    failures_message = stats[TEST_ENVIRONMENT_FAILURES_INDEX]
    errors_message.strip!
    failures_message.strip!
    assert_equal('0', errors_message[0])
    assert_equal('0', failures_message[0])
  end

  def test_run_plugin
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    refute_nil(window_id)

    # Clean up
    @window = Repla::Window.new(window_id)
  end

  def test_run_plugin_in_directory_with_arguments
    arguments = '1 2 3'
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla.load_plugin(DATA_PLUGIN_FILE)
    window_id = Repla.run_plugin(DATA_PLUGIN_NAME, path, arguments.split(' '))
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
