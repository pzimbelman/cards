require File.dirname(__FILE__) + '/game_constants.rb'
require File.dirname(__FILE__) + '/game_helpers.rb'

module Game
  class Card
    include CardHelpers
    include Comparable

    attr_reader :suit, :rank
    def initialize(rank, suit)
      @suit = suit
      @rank = rank
    end

    def to_s
      "#{rank} #{suit}"
    end

    def <=>(card)
      rank_index_of(self) <=> rank_index_of(card)
    end
  end
end 
