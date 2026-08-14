require 'forwardable'
require 'set'
require 'treely/configuration'
require 'treely/tree'
require 'treely/version'

module Treely
  def self.tree(elems)
    Tree.new(elems).render.to_a.join("\n")
  end
end
