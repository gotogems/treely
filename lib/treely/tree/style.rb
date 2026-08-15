module Treely
  class Tree
    module Style
      UNICODE = {
        :indent      => '    ',
        :bar         => '│   ',
        :branch      => '├── ',
        :last_branch => '└── '
      }

      UNICODE_ROUNDED = {
        :indent      => '    ',
        :bar         => '│   ',
        :branch      => '├── ',
        :last_branch => '╰── '
      }

      UNICODE_TRIANGLE = {
        :indent      => '  ',
        :bar         => '┆ ',
        :branch      => '▸ ',
        :last_branch => '▸ '
      }

      STYLES = {
        :unicode          => UNICODE,
        :unicode_rounded  => UNICODE_ROUNDED,
        :unicode_triangle => UNICODE_TRIANGLE
      }

      def self.get_or_default(style)
        STYLES[style] or UNICODE
      end

      def self.get(style)
        STYLES[style]
      end
    end
  end
end
