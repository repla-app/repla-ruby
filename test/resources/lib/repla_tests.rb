module Repla
  module Tests
    # General
    TEST_PAUSE_TIME = 2.00

    # Ruby
    LIB_DIRECTORY = File.dirname(__FILE__)
    TEST_HELPER_FILE = File.join(LIB_DIRECTORY, 'test_helper')

    # Plugins
    TEST_PLUGIN_DIRECTORY = File.join(LIB_DIRECTORY, '../TestBundles/')
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
    TEST_HTML_DIRECTORY = File.join(LIB_DIRECTORY, '..', 'html')
    INDEX_HTML_FILE = File.join(TEST_HTML_DIRECTORY, 'index.html')
    INDEXJQUERY_HTML_FILE = File.join(TEST_HTML_DIRECTORY, 'indexjquery.html')

    # JavaScript
    TEST_JAVASCRIPT_DIRECTORY = File.join(LIB_DIRECTORY, '..', 'js')
    BODY_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY, 'body.js')
    BODYJQUERY_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                           'bodyjquery.js')
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
