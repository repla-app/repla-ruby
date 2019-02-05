module Repla::Print
  class View < Repla::View
    ROOT_ACCESS_DIRECTORY = File.join(File.dirname(__FILE__), '..')
    HTML_DIRECTORY = File.join(ROOT_ACCESS_DIRECTORY, 'html')
    VIEW_TEMPLATE = File.join(HTML_DIRECTORY, 'index.html')

    def initialize
      super
      self.root_access_directory_path = File.expand_path(ROOT_ACCESS_DIRECTORY)
      load_file(VIEW_TEMPLATE)
    end
  end
end
