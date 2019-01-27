require_relative 'extension_constants'
require REPLA_FILE

module Repla

  class Logger
    MESSAGE_PREFIX = 'MESSAGE '
    ERROR_PREFIX = 'ERROR '
    LOG_PLUGIN_NAME = 'Log'

    # Toggle

    SHOW_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "show_log.scpt")
    def show
      Repla::run_applescript(SHOW_LOG_SCRIPT, [window_id])
    end
    
    HIDE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "hide_log.scpt")
    def hide
      Repla::run_applescript(HIDE_LOG_SCRIPT, [window_id])
    end
    
    TOGGLE_LOG_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "toggle_log.scpt")
    def toggle
      Repla::run_applescript(TOGGLE_LOG_SCRIPT, [window_id])
    end

    # Messages

    def info(message)
      message = message.dup
      message.gsub!(%r{^}, MESSAGE_PREFIX) # Prefix all lines
      # Strip trailing white space
      # Add a line break
      log_message(message)
    end

    def error(message)
      message = message.dup
      message.gsub!(%r{^}, ERROR_PREFIX)
      log_message(message)
    end

    # Properties

    def window_id
      @window_id ||= ENV.has_key?(WINDOW_ID_KEY) ? ENV[WINDOW_ID_KEY] : Repla::create_window
    end
  
    def view_id
      @view_id ||= Repla::split_id_in_window(window_id, LOG_PLUGIN_NAME)
      return @view_id unless @view_id.nil?

      @view_id = Repla::split_id_in_window_last(window_id)
      Repla::run_plugin_in_split(LOG_PLUGIN_NAME, window_id, @view_id)
      @view_id  
    end

    private

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, "read_from_standard_input.scpt")  
    def log_message(message)
      message.rstrip!
      message += "\n"
      Repla::run_applescript(READ_FROM_STANDARD_INPUT_SCRIPT, [message, window_id, view_id])
    end
  
  end
end
