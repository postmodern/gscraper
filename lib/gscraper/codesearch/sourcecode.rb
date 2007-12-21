module GScraper
  module CodeSearch
    class SourceCode

      # Source comments
      attr_accessor :comments

      # Source code
      attr_accessor :code

      def initialize
        @comments = {}
        @code = {}
      end

      def [](index)
        self.text[index]
      end

      def text
        @comments.merge(@code).values
      end

      def to_hash
        @comments.merge(@code)
      end

      def to_a
        self.text
      end

      def to_s
        self.text.join("\n")
      end

    end
  end
end
