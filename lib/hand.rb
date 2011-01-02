require File.dirname(__FILE__) + '/straight_comparisons.rb'
require File.dirname(__FILE__) + '/card_info.rb'

module Game
  class Hand
    include Comparable
    attr_reader :rank, :cards, :card_info

    def self.create(cards)
      card_info = Game::CardInfo.info_for(cards)
      if valid?(card_info)
        return self.new(cards, card_info)
      end
    end

    def initialize(cards, card_info)
      @cards = cards
      @card_info = card_info
    end

    def ranks
      cards.ranks
    end

    def high_card
      cards.high_card
    end

   def <=>(opponent)
     return  1 if beats?(opponent)
     return -1 if opponent.beats?(self)
     0
   end
  
    protected
    def beats?(opponent)
      return compare_same_rank(opponent) if rank == opponent.rank
      rank > opponent.rank
    end

    def high_pair
      card_info.high_pair
    end

    def low_pair
      card_info.low_pair
    end

    private
    def wins_by_high_card?(opponent)
      cards.size.times do |index|
        if cards[index] != opponent.cards[index]
          return cards[index] > opponent.cards[index]
        end
      end
      false
    end
  end

  class HighCard < Hand
    def initialize(cards, card_info)
      @rank = 0
      super
    end

    def self.valid?(card_info)
      !(card_info.pairs || card_info.trips || card_info.quads ||
           card_info.flush? || card_info.straight?)
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
      card_info.pairs && card_info.pair_count == 1 && !card_info.trips
    end

    private
    def compare_same_rank(opponent)
       if high_pair == opponent.high_pair
         return wins_by_high_card?(opponent)
       end
       return high_pair > opponent.high_pair
    end
  end

  class TwoPair < Hand

    def initialize(cards, card_info)
      @rank = 2
      super
    end

    def self.valid?(card_info)
      card_info.pairs && card_info.pair_count == 2
    end


    private
    def compare_same_rank(opponent)
      if high_pair == opponent.high_pair
        if low_pair == opponent.low_pair
          return wins_by_high_card?(opponent)
        end
        return low_pair > opponent.low_pair
      end
      return high_pair > opponent.high_pair
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
       if trips == opponent.trips
         return wins_by_high_card?(opponent)
       end
      return trips > opponent.trips
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
  

    private
    def compare_same_rank(opponent)
      if trips == opponent.trips 
        return high_pair > opponent.high_pair
      else
        return trips > opponent.trips
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
