require_relative '../../test'

module Repla
  module Test
    # View helper
    module ViewHelper
      def make_views(filename)
        file_view = make_file_view(filename)
        url_view = make_url_view(filename)
        [file_view, url_view]
      end

      def make_file_view(filename)
        file = html_file(filename)
        view = Repla::Window.new
        view.load_file(file)
        view
      end

      def make_url_view(filename)
        file = html_server_url(filename)
        view = Repla::Window.new
        view.load_file(file)
        view
      end
    end
  end
end
