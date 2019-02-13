module Repla
  module Test
    # General
    TEST_PAUSE_TIME = 2.00

    # Ruby
    REPLA_FILE = File.join(File.dirname(__FILE__), '../repla')
    TEST_DIRECTORY = File.join(File.dirname(__FILE__), 'test')
    LIB_DIRECTORY = File.join(TEST_DIRECTORY, 'lib')
    HELPER_FILE = File.join(LIB_DIRECTORY, 'helper')

    # Test Assets

    # Plugins
    TEST_PLUGIN_DIRECTORY = File.join(TEST_DIRECTORY, 'bundles')
    HELLOWORLD_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY,
                                       'HelloWorld.wcplugin')
    HELLOWORLD_PLUGIN_NAME = 'HelloWorld'.freeze
    PRINT_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, 'Print.wcplugin')
    PRINT_PLUGIN_NAME = 'Print'.freeze
    TESTLOG_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, 'TestLog.wcplugin')
    TESTLOG_PLUGIN_NAME = 'TestLog'.freeze
    INVALID_PLUGIN_FILE = File.join(TEST_PLUGIN_DIRECTORY, 'Invalid.wcplugin')
    INVALID_PLUGIN_NAME = 'Invalid'.freeze

    # HTML
    TEST_HTML_DIRECTORY = File.join(TEST_DIRECTORY, 'html')
    INDEX_HTML_FILE = File.join(TEST_HTML_DIRECTORY, 'index.html')
    INDEXJQUERY_HTML_FILE = File.join(TEST_HTML_DIRECTORY, 'indexjquery.html')
    INDEX_HTML_TITLE = 'Index'.freeze
    INDEXJQUERY_HTML_TITLE = 'Index JQuery'.freeze

    # JavaScript
    TEST_ASSETS_JAVASCRIPT_DIRECTORY = File.join(TEST_DIRECTORY, 'js')
    TITLE_JAVASCRIPT_FILE = File.join(TEST_ASSETS_JAVASCRIPT_DIRECTORY,
                                      'title.js')

    # Local Asssets

    # JavaScript
    TEST_JAVASCRIPT_DIRECTORY = File.join(LIB_DIRECTORY, '../js')
    LASTCODE_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                         'lastcode.js')
    FIRSTCODE_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                          'firstcode.js')
    NODOM_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, 'nodom.js')
    TEXT_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, 'text.js')
    TEXTJQUERY_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                           'textjquery.js')
  end
end
