TEST_LIB_DIRECTORY = File.dirname(__FILE__)

# Template
TEST_TEMPLATE_FILE = File.join(TEST_LIB_DIRECTORY, "../html/index.html")

require "uri"
TEST_ROOT_ACCESS_PATH = File.expand_path(File.join(TEST_LIB_DIRECTORY, ".."))
TEST_ROOT_ACCESS_URL = URI.encode("file://" + TEST_ROOT_ACCESS_PATH)

# Data Plugin
TEST_DATA_DIRECTORY = File.join(TEST_LIB_DIRECTORY, "../data")
DATA_PLUGIN_FILE = File.join(TEST_DATA_DIRECTORY, "Data.wcplugin")
DATA_PLUGIN_NAME = "Data"
DATA_PLUGIN_PATH_KEY = "Path"
DATA_PLUGIN_ARGUMENTS_KEY = "Arguments"

# Test Data
TEST_TITLE = "Test"
TEST_TITLE_JAVASCRIPT = "document.title"

TEST_SHARED_RESOURCE_PATH_COMPONENT = 'js/zepto.js'.freeze
