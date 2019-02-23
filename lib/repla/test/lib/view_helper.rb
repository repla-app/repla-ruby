require_relative '../../test'

module Repla
  module Test
    # View helper
    module ViewHelper
      def self.make_views(filename)
        file_view = make_file_view(filename)
        url_view = make_url_view(filename)
        [file_view, url_view]
      end

      def self.make_file_view(filename)
        file = Repla::Test.html_file(filename)
        view = Repla::View.new
        view.load_file(file)
        view
      end

      def self.make_url_view(filename)
        url = Repla::Test.html_server_url(filename)
        view = Repla::View.new
        view.load_url(url)
        view
      end
    end
  end
end
