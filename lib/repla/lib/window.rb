module Repla
  class Window
    require_relative 'constants'

    attr_accessor :root_access_directory_path
    def initialize(window_id = nil)
      @window_id = window_id
    end

    # Properties

    def window_id
      @window_id ||= ENV.key?(WINDOW_ID_KEY) ? ENV[WINDOW_ID_KEY] : Repla.create_window
    end

    # Web

    LOAD_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'load.scpt')
    LOADWITHROOTACCESSDIRECTORY_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'load_with_root_access_directory.scpt')
    def load_file(file)
      arguments = [file]

      script = LOAD_SCRIPT

      if @root_access_directory_path
        script = LOADWITHROOTACCESSDIRECTORY_SCRIPT
        arguments.push(@root_access_directory_path)
      end

      run_script(script, arguments)
    end

    DOJAVASCRIPT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'do_javascript.scpt')
    def do_javascript(javascript)
      run_script(DOJAVASCRIPT_SCRIPT, [javascript])
    end

    READ_FROM_STANDARD_INPUT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'read_from_standard_input.scpt')
    def read_from_standard_input(text)
      run_script(READ_FROM_STANDARD_INPUT_SCRIPT, [text])
    end

    # Window

    CLOSEWINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'close_window.scpt')
    def close
      Repla.run_applescript(CLOSEWINDOW_SCRIPT, [window_id])
    end

    def split_id
      Repla.split_id_in_window(window_id)
    end

    def split_id_last
      Repla.split_id_in_window_last(window_id)
    end

    private

    def run_script(script, arguments = [])
      arguments = arguments_with_target(arguments)
      Repla.run_applescript(script, arguments)
    end

    def arguments_with_target(arguments)
      arguments.push(window_id)
    end
  end
end
