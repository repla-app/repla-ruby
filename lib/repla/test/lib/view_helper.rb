module Repla
  module Test
    # View helper
    module ViewHelper
      def make_views(filename)
      end
      def make_view(filename)
        view = Repla::Window.new
        view.load_file(file)
        view
      end
    end
  end
end

