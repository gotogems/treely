require 'treely/tree/buffer'
require 'treely/tree/style'
require 'set'

module Treely
  class Tree
    attr_reader :style
    attr_writer :formatter

    def initialize(elems = [], style: :unicode)
      @style = Style.get(style) || Style::UNICODE
      @buffer = Buffer.new(walk(elems))
      @formatter = -> { _1.to_s }
    end

    def each_line
      depth = 0
      i = 0

      Enumerator.new do |emit|
        was_last = false
        indents  = []

        loop do
          current = @buffer[i]
          break if current.nil?

          elem, cur_depth, maybe_last = current
          last_branch = if maybe_last
            has_sibling = false
            j = i + 1

            loop do
              t = @buffer[j]
              break if t.nil?
              break if t[1] < cur_depth

              if t[1] == cur_depth
                has_sibling = true
                break
              end

              j += 1
            end

            !has_sibling
          else
            false
          end

          if cur_depth > depth
            if was_last
              indents << @style[:indent]
            else
              indents << @style[:bar]
            end
          elsif cur_depth < depth
            indents = indents.take(cur_depth)
          end

          emit << render(elem, indents.join, last_branch)
          was_last = last_branch
          depth = cur_depth
          i += 1
        end
      end
    end

    def walk(elems, depth = 0, maybe_last = true)
      last_leaf, end_marks = find_last_hint(elems)

      Enumerator.new do |emit|
        elems.each_with_index do |elem, i|
          if container?(elem)
            walk(elem, depth + 1, end_marks.include?(i))
              .each { |t| emit << t }
          else
            emit << [
              elem,
              depth,
              maybe_last && last_leaf == i
            ]
          end
        end
      end
    end

    def render(elem, indent, last_branch, fn = @formatter)
      lines = fn.call(elem).lines(chomp: true)
      lines = [''] if lines.empty?

      branch = last_branch ? @style[:last_branch] : @style[:branch]
      bar    = last_branch ? @style[:indent]      : @style[:bar]

      lines.map.with_index do |line, i|
        indent + (i.zero? ? branch : bar) + line
      end.join("\n")
    end

    alias_method :follow, :each_line
    alias_method :depths, :walk

    private

    def find_last_hint(elems)
      last_leaf = -1
      end_marks = Set.new

      elems.each_with_index do |elem, i|
        next_elem = elems[i + 1]
        cur_is_cont = container?(elem)
        next_is_cont = container?(next_elem)

        if cur_is_cont && !next_is_cont
          end_marks << i
        end

        if next_elem && !next_is_cont
          last_leaf = i + 1
        elsif !cur_is_cont
          last_leaf = i
        end
      end

      [last_leaf, end_marks]
    end

    def container?(elem)
      elem.is_a?(Array)
    end
  end
end
