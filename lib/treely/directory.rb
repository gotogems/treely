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
      @no_report   = options[:no_report]
      @ignore_p    = options[:ignore_p]
      @dirs_count  = 0
      @files_count = 0
      @file_limit  = -1
      @filters     = []
      @level       = options[:level].to_i

      add_filter(-> { directory?(_1) }) if     @only_dirs
      add_filter(-> { !hidden?(_1)   }) unless @show_hidden

      Array(@ignore_p).each do |re|
        add_filter(-> (p) { !p.match?(re) })
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

          if @dirs_first or @files_first
            paths.sort_by! {
              is_dir = directory?(_1)
              @dirs_first ? [is_dir ? 0 : 1, _1] : [is_dir ? 1 : 0, _1]
            }
          end

          unless @no_report
            dirs, files = paths.partition { directory?(_1) }
            @dirs_count += dirs.size
            @files_count += files.size
          end

          paths.each_with_index do |path, i|
            walk(path, level + 1, i.next == paths.length)
              .each { |t| emit << t }
          end
        end
      end
    end

    def summary
      return if @no_report
      puts "\n%s %s, %s %s" % [
        @dirs_count,  @dirs_count  == 1 ? 'directory' : 'directories',
        @files_count, @files_count == 1 ? 'file'      : 'files'
      ]
    end

    private

    def_delegator :File, :directory?
    def_delegator :File, :basename
    def_delegator :File, :join

    def add_filter(filter)
      @filters << filter
    end

    def descend?(level)
      @level <= 0 || level < @level
    end

    def hidden?(path)
      basename(path).start_with?('.')
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
