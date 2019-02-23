require_relative '../../test'
require 'test/unit'

module Repla
  module Test
    # View helper
    module ViewHelper
      def self.make_windows(filename)
        file_view = make_file_view(filename, Window.new)
        url_view = make_url_view(filename, Window.new)
        raise unless file_view.class == Window

        raise unless url_view.class == Window

        [file_view, url_view]
      end

      def self.make_views(filename)
        file_view = make_file_view(filename)
        url_view = make_url_view(filename)
        raise unless file_view.class == View

        raise unless url_view.class == View

        [file_view, url_view]
      end

      def self.make_file_view(filename, initializer = View.new)
        file = Repla::Test.html_file(filename)
        view = initializer
        view.load_file(file)
        view
      end

      def self.make_url_view(filename, initializer = View.new)
        url = Repla::Test.html_server_url(filename)
        view = initializer
        view.load_url(url)
        view
      end
    end
  end
end
