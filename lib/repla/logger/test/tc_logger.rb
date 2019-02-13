#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_setup'

require_relative 'lib/test_view_helper'
require_relative '../../logger'

# Test constants
class TestConstants < Test::Unit::TestCase
  def test_constants
    message_prefix = Repla::Logger::MESSAGE_PREFIX
    assert_not_nil(message_prefix)
    error_prefix = Repla::Logger::ERROR_PREFIX
    assert_not_nil(error_prefix)
  end
end

# Test unitialized logger
class TestUnintializedLogger < Test::Unit::TestCase
  def teardown
    Repla::Test::Helper.quit
    assert(!Repla::Test::Helper.app_running?,
           'The application should not be running.')
  end

  def test_uninitialized_logger
    logger = Repla::Logger.new

    # Test Message
    message = 'Testing log message'
    logger.info(message)
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed

    # Make sure the log messages before accessing the logger's `view_id` and
    # `window_id` because those run the logger. This test should test logging a
    # message and running the logger itself simultaneously. This is why the
    # `TestViewHelper` is intialized after logging the message.
    test_view_helper = TestViewHelper.new(logger.window_id, logger.view_id)

    test_message = test_view_helper.last_log_message
    assert_equal(message, test_message, 'The messages should match')
    test_class = test_view_helper.last_log_class
    assert_equal('message', test_class, 'The classes should match')
  end
end

# Test logger
class TestLogger < Test::Unit::TestCase
  def setup
    @logger = Repla::Logger.new
    @logger.show
    @test_view_helper = TestViewHelper.new(@logger.window_id, @logger.view_id)
  end

  def teardown
    Repla::Test::Helper.quit
    assert(!Repla::Test::Helper.app_running?)
  end

  def test_logger
    test_count = 0

    # Test Error
    message = 'Testing log error'
    @logger.error(message)
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('error', test_class)
    result_count = @test_view_helper.number_of_log_messages
    test_count += 1
    assert_equal(test_count, result_count)

    # Test Message
    message = 'Testing log message'
    @logger.info(message)
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('message', test_class)
    result_count = @test_view_helper.number_of_log_messages
    test_count += 1
    assert_equal(test_count, result_count)

    # Test Only Error Prefix
    # Note the trailing whitespace is trimmed
    message = Repla::Logger::ERROR_PREFIX.rstrip
    @logger.info(message)
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('message', test_class)
    result_count = @test_view_helper.number_of_log_messages
    test_count += 1
    assert_equal(test_count, result_count)

    # Test Only Message Prefix
    # Note the trailing whitespace is trimmed
    message = Repla::Logger::MESSAGE_PREFIX.rstrip
    @logger.info(message)
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('message', test_class)
    result_count = @test_view_helper.number_of_log_messages
    test_count += 1
    assert_equal(test_count, result_count)

    # Test Blank Spaces
    @logger.info("  \t")
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('message', test_class)

    # Test Empty String
    @logger.info('')
    sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    test_message = @test_view_helper.last_log_message
    assert_equal(message, test_message)
    test_class = @test_view_helper.last_log_class
    assert_equal('message', test_class)

    # TODO: Also add the following tests the `Log.wcplugin`

    # Test Whitespace
    # White space to the left should be preserved, whitespace to the right
    # should be removed This test fails because retrieving the `innerText`
    # doesn't preserve whitepace.

    # message = "\t Testing log message"
    # @logger.info(message + "\t ")
    # sleep Repla::Test::TEST_PAUSE_TIME # Pause for output to be processed
    # test_message = @test_view_helper.last_log_message
    # assert_equal(message, test_message, "The messages should match")
    # test_class = @test_view_helper.last_log_class
    # assert_equal("message", test_class, "The classes should match")
    # result_count = @test_view_helper.number_of_log_messages
    # test_count += 1
    # assert_equal(test_count, result_count)
  end

  def test_long_input
    message = '
Line 1

Line 2
Line 3
'
    @logger.info(message)
    sleep Repla::Test::TEST_PAUSE_TIME * 2 # Pause for output to be processed
    result_count = @test_view_helper.number_of_log_messages
    assert_equal(result_count, 3, 'The number of log messages should match')

    (1..3).each do |i|
      result = @test_view_helper.log_message_at_index(i - 1)
      test_result = "Line #{i}"
      assert_equal(result,
                   test_result,
                   'The number of log messages should match')
    end
  end
end
