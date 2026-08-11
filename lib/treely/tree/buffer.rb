module Treely
  class Tree
    class Buffer
      def initialize(source)
        @iterator = source.each
        @buffer   = []
      end

      def [](i)
        while @buffer.size <= i
          begin
            @buffer << @iterator.next
          rescue StopIteration
            break
          end
        end

        @buffer[i]
      end
    end
  end
end
