module Treely
  class Tree
    module Adapter
      module PathWalker
        def self.included(base)
          base.attr_reader :walk_dir
        end

        def walk_dir=(dir)
          @walk_dir = dir
          @buffer = dir.root.then { dir.walk(_1) }
                            .then { Tree::Buffer.new(_1) }
        end
      end
    end
  end
end
