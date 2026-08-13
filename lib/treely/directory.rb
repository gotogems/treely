module Treely
  class Directory
    extend Forwardable

    def initialize
      @dirs_count  = 0
      @files_count = 0
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
end
