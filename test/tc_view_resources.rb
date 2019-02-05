#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'test/unit'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require_relative "lib/test_javascript_constants"

require Repla::Test::HELPER_FILE

class TestViewRootAccessDirectory < Test::Unit::TestCase
  def test_root_access_directory
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    view.load_file(TEST_TEMPLATE_FILE)
    result = view.do_javascript_function(TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME)
    assert_equal(result, TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, 'The result should equal the expected result.')
    view.close
  end
end

class TestViewTitle < Test::Unit::TestCase
  def test_no_title
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    view.load_file(TEST_TEMPLATE_FILE)

    assert_nil(view.title, 'The views title should be nil.')

    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert(title_result.nil?, 'The title result should be nil.')
    view.close
  end

  def test_set_title
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    view.title = TEST_TITLE
    view.load_file(TEST_TEMPLATE_FILE)

    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")

    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert_equal(title_result, TEST_TITLE, 'The title result should equal the test title.')
    view.close
  end

  def test_title_environment_variable
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    ENV[Repla::PLUGIN_NAME_KEY] = TEST_TITLE
    view.load_file(TEST_TEMPLATE_FILE)

    assert_equal(view.title, TEST_TITLE, "The view's title should equal the test title.")

    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert_equal(title_result, TEST_TITLE, 'The title result should equal the test title.')
    view.close
  end
end
