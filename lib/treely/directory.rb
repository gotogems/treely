module Treely
  class Directory
    extend Forwardable

    attr_reader :root
    attr_reader :dirs_count
    attr_reader :files_count

    def initialize(root, options = {})
      @root = root || Dir.pwd
      @dirs_first  = options[:dirs_first]
      @files_first = options[:files_first]
      @only_dirs   = options[:only_dirs]
      @show_hidden = options[:show_hidden]
      @ignore_path = options[:ignore_p]
      @dirs_count  = 0
      @files_count = 0
      @file_limit  = -1
      @filters     = []
      @level       = options[:level].to_i

      add_filter(-> { directory?(_1) }) if     @only_dirs
      add_filter(-> { !hidden?(_1)   }) unless @show_hidden

      if @ignore_path.is_a?(Array)
        @ignore_path.each do |re|
          add_filter(-> { !match?(re, _1) })
        end
      end
    end

    def to_tree
      tree = Treely.dir_tree
      tree.walk_dir = self
      tree
    end

    def walk(root, level = 0, maybe_last = true)
      Enumerator.new do |emit|
        emit << [basename(root), level, maybe_last]

        if directory?(root) && descend?(level)
          paths = Dir.children(root)
            .sort.map { join(root, _1) }
            .select { |p| @filters.all? { |f| f.call(p) } }

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

    def add_filter(filter)
      @filters << filter
    end

    def descend?(level)
      @level < 0 || level < @level
    end

    def hidden?(path)
      basename(path).start_with?('.')
    end

    def match?(re, p)
      p.match?(re)
    end

    module Source
      def self.included(base)
        base.attr_reader :walk_dir
      end

      def walk_dir=(dir)
        @walk_dir = dir
        @buffer = Tree::Buffer.new(source)
      end

      def source
        @source ||= @walk_dir.walk(root)
      end

      def root
        @root ||= @walk_dir.root
      end
    end
  end

  if defined?(Tree)
    Tree.include(Directory::Source)
  end

  def self.dir(*args)
    Directory.new(*args)
  end
end
