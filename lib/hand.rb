require File.dirname(__FILE__) + '/straight_comparisons.rb'
require File.dirname(__FILE__) + '/hand_helpers.rb'
require File.dirname(__FILE__) + '/card_info.rb'

module Game
  class InvalidHand < ArgumentError
  end

  class Hand
    extend Game::HandHelpers
    include Game::HandHelpers
    attr_reader :rank, :cards, :card_info

    def self.create(cards)
      card_info = Game::CardInfo.info_for(cards)
      if valid?(card_info)
        return self.new(cards, card_info)
      end
      raise Game::InvalidHand 
    end
    
    def self.valid?(card_info)
      false
    end

    def initialize(cards, card_info)
      @cards = cards.sort { |a,b| b <=> a }
      @card_info = card_info
    end

    def high_card
      @cards.first
    end

    def >(opponent)
      determine_winner(opponent) { compare_same_rank(opponent) }
    end

    def ==(opponent)
      self.rank == opponent.rank
    end

    def <=>(opponent)
      if self > opponent
        return 1
      elsif self == opponent
        return 0
      end
      return -1
    end
  
    protected
    def beats?(opponent)
      self.rank > opponent.rank 
    end

    def wins_by_high_card?(opponent)
      @cards.size.times do |index|
        if @cards[index] != opponent.cards[index]
          return @cards[index] > opponent.cards[index]
        end
      end
      false
    end

    private
    def determine_winner(opponent)
      if self == opponent
        return yield 
      end
      self.beats?(opponent)
    end
  end

  class HighCard < Hand
    def initialize(cards, card_info)
      @rank = 0
      super
    end

    def self.valid?(card_info)
      true
    end

    private
    def compare_same_rank(opponent)
      wins_by_high_card?(opponent)
    end

  end

  class Pair < Hand
    def initialize(cards, card_info)
      @rank = 1
      super
    end

    def self.valid?(card_info)
      card_info.pairs && card_info.pairs.size == 1 && !card_info.trips
    end

    protected
    def pair
      return card_info.pairs.first
    end

    private
    def compare_same_rank(opponent)
       if self.pair == opponent.pair
         return wins_by_high_card?(opponent)
       end
       return self.pair > opponent.pair
    end
  end

  class TwoPair < Hand

    def initialize(cards, card_info)
      @rank = 2
      super
    end

    def self.valid?(card_info)
      card_info.pairs && card_info.pairs.size == 2
    end

    protected
    def high_pair
      card_info.pairs.first
    end

    def low_pair
      card_info.pairs.last
    end

    private
    def compare_same_rank(opponent)
      if self.high_pair == opponent.high_pair
        if self.low_pair == opponent.low_pair
          return wins_by_high_card?(opponent)
        end
        return self.low_pair > opponent.low_pair
      end
      return self.high_pair > opponent.high_pair
    end
  end

  class ThreeOfAKind < Hand
    def initialize(cards, card_info)
      @rank = 3
      super
    end

    def self.valid?(card_info)
      card_info.trips && !card_info.pairs
    end

    protected
    def trips
      card_info.trips.first
    end

    private
    def compare_same_rank(opponent)
       if self.trips == opponent.trips
         return wins_by_high_card?(opponent)
       end
      return self.trips > opponent.trips
    end
  end

  class Straight < Hand
    include Game::StraightComparisons
    def initialize(cards, card_info)
      @rank = 4
      super
    end

    def self.valid?(card_info)
      card_info.straight? && !card_info.flush?
    end
  end

  class Flush < Hand
    def initialize(cards, card_info)
      @rank = 5
      super
    end

    def self.valid?(card_info)
      card_info.flush? && !card_info.straight?
    end

    def compare_same_rank(opponent)
      wins_by_high_card?(opponent) 
    end
  end

  class FullHouse < Hand

    def initialize(cards, card_info)
      @rank = 6
      super
    end

    def self.valid?(card_info)
      card_info.trips && card_info.pairs
    end

    protected
    def trips
      card_info.trips.first
    end
  
    def pair
      card_info.pairs.first
    end

    private
    def compare_same_rank(opponent)
      if self.trips == opponent.trips 
        return self.pair > opponent.pair
      else
        return self.trips > opponent.trips
      end
    end
  end

  class FourOfAKind < Hand
    def initialize(cards, card_info)
      @rank = 7
      super
    end

    def self.valid?(card_info)
      card_info.quads 
    end

    protected
    def quads
      card_info.quads.first
    end

    private
    def compare_same_rank(opponent)
      if self.quads == opponent.quads 
        return wins_by_high_card?(opponent) 
      end
      return self.quads > opponent.quads
    end
  end

  class StraightFlush < Hand
    include Game::StraightComparisons
    def initialize(cards, card_info)
      @rank = 8
      super
    end

    def self.valid?(card_info)
      card_info.flush? && card_info.straight?
    end
  end
end
