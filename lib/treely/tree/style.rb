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
        :default  => UNICODE,
        :rounded  => UNICODE_ROUNDED,
        :triangle => UNICODE_TRIANGLE
      }

      def self.get(style)
        STYLES[style]
      end
    end
  end
end
