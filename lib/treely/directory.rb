module Treely
  class Directory
    extend Forwardable

    def initialize
    end

    def_delegator :File, :file?
    def_delegator :File, :directory?

    def level_hints(paths)
      last_file = paths.rindex { file?(_1) } || -1
      dir_marks = Set.new

      paths.each_with_index do |path, i|
        next_path = paths[i + 1]
        next_is_dir = next_path && directory?(next_path)

        if directory?(path) && !next_is_dir
          dir_marks << i
        end
      end

      [last_file, dir_marks]
    end
  end
end
