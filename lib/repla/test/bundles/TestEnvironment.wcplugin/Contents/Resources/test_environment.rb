#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative '../../../../../../lib/repla'
require_relative 'constants'
require_relative '../../../../../lib/escape'

class TestEnviroment < Test::Unit::TestCase
  using Escape
  def test_plugin_name_key
    assert(ENV.key?(Repla::PLUGIN_NAME_KEY), 'The plugin name key should exist.')
    plugin_name = ENV[Repla::PLUGIN_NAME_KEY]
    assert_equal(plugin_name, TEST_PLUGIN_NAME, 'The plugin name should equal the test plugin name.')
  end

  def test_split_id_key
    assert(ENV.key?(Repla::SPLIT_ID_KEY), 'The split id key should exist.')
    window_id = ENV[Repla::SPLIT_ID_KEY]
    assert(!window_id.integer?, 'The split id should not be an integer.')
  end

  def test_window_id_key
    assert(ENV.key?(Repla::WINDOW_ID_KEY), 'The window id key should exist.')
    window_id = ENV[Repla::WINDOW_ID_KEY]
    assert(window_id.integer?, 'The window id should be an integer.')
    assert(window_id.to_i > 0, 'The window id should be greater than zero.')
  end
end
