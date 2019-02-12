require 'Shellwords'
module Repla
  LOAD_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'load_plugin.scpt')
  def self.load_plugin(path)
    run_applescript(LOAD_PLUGIN_SCRIPT, [path])
  end

  EXISTS_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'exists.scpt')
  def self.application_exists
    result = run_applescript(EXISTS_SCRIPT)
    result == 'true'
  end

  RUN_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'run_plugin.scpt')
  def self.run_plugin(name, directory = nil, arguments = nil)
    parameters = [name]
    parameters.push(directory) unless directory.nil?
    parameters += arguments unless arguments.nil?
    run_applescript(RUN_PLUGIN_SCRIPT, parameters)
  end

  RUN_PLUGIN_IN_SPLIT_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'run_plugin_in_split.scpt')
  def self.run_plugin_in_split(name, window_id, split_id)
    parameters = [name, window_id, split_id]
    run_applescript(RUN_PLUGIN_IN_SPLIT_SCRIPT, parameters)
  end

  WINDOW_ID_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'window_id_for_plugin.scpt')
  def self.window_id_for_plugin(name)
    run_applescript(WINDOW_ID_FOR_PLUGIN_SCRIPT, [name])
  end

  SPLIT_ID_IN_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'split_id_in_window.scpt')
  def self.split_id_in_window(window_id, pluginName = nil)
    arguments = [window_id]
    arguments.push(pluginName) unless pluginName.nil?
    run_applescript(SPLIT_ID_IN_WINDOW_SCRIPT, arguments)
  end

  SPLIT_ID_IN_WINDOW_LAST_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'split_id_in_window_last.scpt')
  def self.split_id_in_window_last(window_id)
    arguments = [window_id]
    run_applescript(SPLIT_ID_IN_WINDOW_LAST_SCRIPT, arguments)
  end

  CREATE_WINDOW_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'create_window.scpt')
  def self.create_window
    run_applescript(CREATE_WINDOW_SCRIPT)
  end

  # Resources

  RESOURCE_PATH_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'resource_path_for_plugin.scpt')
  def self.resource_path_for_plugin(name)
    run_applescript(RESOURCE_PATH_FOR_PLUGIN_SCRIPT, [name])
  end

  RESOURCE_URL_FOR_PLUGIN_SCRIPT = File.join(APPLESCRIPT_DIRECTORY, 'resource_url_for_plugin.scpt')
  def self.resource_url_for_plugin(name)
    run_applescript(RESOURCE_URL_FOR_PLUGIN_SCRIPT, [name])
  end

  private

  def self.run_applescript(script, arguments = nil)
    command = "osascript #{script.shell_escape}"

    if arguments
      command += ' ' + arguments.compact.map(&:to_s).map(&:shell_escape).join(' ')
    end

    result = `#{command}`

    result.chomp!

    return nil if result.empty?
    return result.to_i if result.is_integer?
    return result.to_f if result.is_float?

    result
  end

  class ::String
    def is_float?
      true if Float(self)
    rescue StandardError
      false
    end

    def is_integer?
      to_i.to_s == self
    end

    def shell_escape
      Shellwords.escape(self)
    end

    def shell_escape!
      replace(shell_escape)
    end
  end

  class ::Float
    alias javascript_argument to_s
  end

  class ::Integer
    alias javascript_argument to_s
  end
end
