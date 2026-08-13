require 'forwardable'
require 'set'
require 'treely/configuration'
require 'treely/tree'
require 'treely/version'

module Treely
  def self.tree(elems)
    Tree.new(elems)
      .each_line.to_a.join("\n")
  end
end
