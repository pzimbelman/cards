require File.dirname(__FILE__) + '/game_constants.rb'

module Game
  class Card
    attr_reader :suit, :rank
    def initialize(rank, suit)
      @suit = suit
      @rank = rank
    end

    def to_s
      "#{rank} #{suit}"
    end

    def ==(opponent)
      self.rank == opponent.rank
    end

    def <(opponent)
      opponent.beats?(self)
    end

    def >(opponent)
      self.beats?(opponent)
    end
    
    def <=>(card)
      if self > card
        return 1
      elsif self < card
        return -1
      end
      return 0
    end

    protected
    def beats?(opponent)
      RANKS.find_index(rank) > RANKS.find_index(opponent.rank)
    end
  end
end 
