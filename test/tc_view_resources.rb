#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require "test/unit"

require_relative "lib/test_constants"
require_relative "lib/test_javascript_constants"

require_relative "../lib/repla"
require Repla::shared_test_resource("ruby/test_constants")
require Repla::Tests::TEST_HELPER_FILE


class TestViewBaseURL < Test::Unit::TestCase
  def test_base_url
    view = Repla::View.new
    view.root_access_directory_url = TEST_ROOT_ACCESS_URL
    view.load_file(TEST_TEMPLATE_FILE)
    result = view.do_javascript_function(TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME)
    assert_equal(result, TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, "The result should equal the expected result.")
    view.close
  end
end

class TestViewEnvironmentVariables < Test::Unit::TestCase

  def test_shared_resource_url_from_environment_variable  

    shared_resource_url = Repla::shared_resources_url.to_s
    ENV[Repla::SHARED_RESOURCES_URL_KEY] = shared_resource_url
    view = Repla::View.new
    view.load_erb_from_path(TEST_TEMPLATE_FILE)
    Repla::Tests::Helper::quit
  
    sleep Repla::Tests::TEST_PAUSE_TIME # Give time for application to quit

    result_shared_resource_url = view.send(:shared_resources_url)  
    
    assert_equal(result_shared_resource_url, shared_resource_url, "The result shared resource URL should equal the shared resource URL.")
    assert(!Repla::Tests::Helper::is_running, "Web Console should not be running.")
  end

end

class TestViewTitle < Test::Unit::TestCase

  def test_no_title
    view = Repla::View.new
    view.root_access_directory_url = TEST_ROOT_ACCESS_URL
    view.load_file(TEST_TEMPLATE_FILE)
    
    assert_nil(view.title, "The views title should be nil.")
    
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert(title_result == nil, "The title result should be nil.")
    view.close
  end

  def test_set_title
    view = Repla::View.new
    view.root_access_directory_url = TEST_ROOT_ACCESS_URL
    view.title = TEST_TITLE
    view.load_file(TEST_TEMPLATE_FILE)
    
    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")
  
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert_equal(title_result, TEST_TITLE, "The title result should equal the test title.")
    view.close
  end
  

  def test_title_environment_variable
    view = Repla::View.new
    view.root_access_directory_url = TEST_ROOT_ACCESS_URL
    ENV[Repla::PLUGIN_NAME_KEY] = TEST_TITLE
    view.load_file(TEST_TEMPLATE_FILE)
    
    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")
  
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert_equal(title_result, TEST_TITLE, "The title result should equal the test title.")
    view.close
  end

end
