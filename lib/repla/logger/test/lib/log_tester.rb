module Repla
  # Test
  module Test
    MESSAGES = [
      'Testing log error',
      'Testing log message',
      'ERROR',
      'MESSAGE',
      'Done'
    ].freeze
    def self.test_log(window)
      test_message = 'Done'
      test_log_helper = Repla::Test::LogHelper.new(window.window_id)
      message = nil
      Repla::Test.block_until do
        message = test_log_helper.last_log_message
        message == test_message
      end
      (0..MESSAGES.count).each do |i|
        result = test_log_helper.log_message_at(i)
        message = MESSAGES[i]
        if result != message
          STDERR.puts "Expected #{message} instead of #{result}"
          return false
        end
      end
      true
    end
  end
end
