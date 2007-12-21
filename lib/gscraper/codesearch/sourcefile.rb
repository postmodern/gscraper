module GScraper
  module CodeSearch
    class SourceFile

      # Source file url
      attr_reader :url

      # Source file path
      attr_reader :path

      # Package the source file belongs to
      attr_reader :package

      # Directory containing the source file
      attr_reader :directory

      # Source code
      attr_reader :source

      def initialize(url,path,package,directory)
      end

      def to_s
        @code.to_s
      end

    end
  end
end
