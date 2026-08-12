require 'treely/configuration'
require 'treely/tree'
require 'treely/version'

module Treely
  def self.tree(elems)
    tree = Tree.new
    tree.follow(tree.flatten(elems))
  end
end
