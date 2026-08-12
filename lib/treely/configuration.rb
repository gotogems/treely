module Treely
  class Configuration
    attr_accessor :style

    def initialize
      @style = Tree::Style::UNICODE
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
