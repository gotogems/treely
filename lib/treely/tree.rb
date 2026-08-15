require 'treely/tree/adapter'
require 'treely/tree/buffer'
require 'treely/tree/style'

module Treely
  class Tree
    attr_reader :style
    attr_reader :filter
    attr_reader :formatter

    def initialize(elems = [], config: Configuration.new)
      @style = Style.get_or_default(config.style)
      @buffer = Buffer.new(walk(elems))

      @formatter = -> { _1.to_s }
      @filter    = -> { _1 }

      @formatter = config.formatter if config.formatter.is_a?(Proc)
      @filter    = config.filter    if config.filter.is_a?(Proc)
    end

    def render
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

          emit << render_line(elem, indents.join, last_branch)
          was_last = last_branch
          depth = cur_depth
          i += 1
        end
      end
    end

    protected

    def render_line(elem, indent, last_branch, fn = @formatter)
      lines = fn.call(elem).lines(chomp: true)
      lines = [''] if lines.empty?

      branch = last_branch ? @style[:last_branch] : @style[:branch]
      bar    = last_branch ? @style[:indent]      : @style[:bar]

      lines.map.with_index do |line, i|
        indent + (i.zero? ? branch : bar) + line
      end.join("\n")
    end

    private

    def walk(elems, level = 0, maybe_last = true)
      last_leaf, end_marks = level_hints(elems)

      Enumerator.new do |emit|
        elems.each_with_index do |elem, i|
          if container?(elem)
            walk(elem, level + 1, end_marks.include?(i))
              .each { |t| emit << t }
          else
            emit << [
              elem,
              level,
              maybe_last && last_leaf == i
            ]
          end
        end
      end
    end

    def level_hints(elems)
      end_leaf = elems.rindex { !container?(_1) } || -1
      end_marks = Set.new

      elems.each_with_index do |elem, i|
        cur_is_cont = container?(elem)
        next_is_cont = container?(elems[i + 1])

        if cur_is_cont && !next_is_cont
          end_marks << i
        end
      end

      [end_leaf, end_marks]
    end

    def container?(elem)
      elem.is_a?(Array)
    end
  end
end
