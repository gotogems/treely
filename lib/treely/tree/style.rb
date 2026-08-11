module Treely
  class Tree
    Style = Struct.new(
      :indent, :bar,
      :branch, :last_branch
    )

    Style::UNICODE = {
      :indent      => '    ',
      :bar         => '│   ',
      :branch      => '├── ',
      :last_branch => '└── '
    }

    Style::UNICODE_ROUNDED = {
      :indent      => '    ',
      :bar         => '│   ',
      :branch      => '├── ',
      :last_branch => '╰── '
    }

    Style::UNICODE_TRIANGLE = {
      :indent      => '  ',
      :bar         => '┆ ',
      :branch      => '▸ ',
      :last_branch => '▸ '
    }
  end
end
