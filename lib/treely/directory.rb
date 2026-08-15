module Treely
  class Directory
    extend Forwardable

    attr_reader :root
    attr_reader :dirs_count
    attr_reader :files_count

    def initialize(root, options = {})
      @root = root || Dir.pwd
      @dirs_count  = 0
      @files_count = 0
      @file_limit  = -1
      @filters     = []
      @level       = -1
    end

    def to_tree
      tree = Treely.dir_tree
      tree.walk_dir = self
      tree
    end

    def walk(root, level = 0, maybe_last = true)
      Enumerator.new do |emit|
        emit << [basename(root), level, maybe_last]

        if directory?(root)
          paths = Dir.children(root)
            .sort.map { join(root, _1) }

          paths.each_with_index do |path, i|
            walk(path, level + 1, i.next == paths.length)
              .each { |t| emit << t }
          end
        end
      end
    end

    private

    def_delegator :File, :directory?
    def_delegator :File, :basename
    def_delegator :File, :join
  end

  if defined?(Tree)
    Tree.include(Tree::Adapter::PathWalker)
  end
end
