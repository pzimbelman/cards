require File.dirname(__FILE__) + '/straight_comparisons.rb'
require File.dirname(__FILE__) + '/hand_helpers.rb'

module Game
  class InvalidHand < ArgumentError
  end

  class Hand
    extend Game::HandHelpers
    include Game::HandHelpers
    attr_reader :rank, :cards
    def initialize(cards)
      @cards = cards.sort { |a,b| b <=> a }
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
    def initialize(cards)
      @rank = 0
      super
    end

    def compare_same_rank(opponent)
      wins_by_high_card?(opponent)
    end

    def self.create(cards)
      self.new(cards)
    end
  end

  class Pair < Hand
    def initialize(cards)
      @rank = 1
      super
    end

    def self.create(cards)
      if duplicate_cards_of_count(cards, 2).size == 1
        return self.new(cards)
      end
      raise Game::InvalidHand 
    end

    private
    def compare_same_rank(opponent)
       my_pairs =  duplicate_cards_of_count(self.cards)
       opponents_pairs = opponent.duplicate_cards_of_count(opponent.cards) 
       if my_pairs.first == opponents_pairs.first
         return wins_by_high_card?(opponent)
       end
       return my_pairs.first > opponents_pairs.first
    end

  end

  class TwoPair < Hand

    def initialize(cards)
      @rank = 2
      super
    end

    private
    def compare_same_rank(opponent)
      my_pairs = duplicate_cards_of_count(cards)
      opponents_pairs = duplicate_cards_of_count(opponent.cards)
      if my_pairs.first == opponents_pairs.first
        if my_pairs.last == opponents_pairs.last
          return wins_by_high_card?(opponent)
        end
        return my_pairs.last > opponents_pairs.last
      end
      return my_pairs.first > opponents_pairs.first
    end
  end

  class ThreeOfAKind < Hand
    def initialize(cards)
      @rank = 3
      super
    end

    private
    def compare_same_rank(opponent)
      my_pairs = duplicate_cards_of_count(self.cards, 3)
      opponents_pairs = duplicate_cards_of_count(opponent.cards, 3)
       if my_pairs.first == opponents_pairs.first
         return wins_by_high_card?(opponent)
       end
      return my_pairs.first > opponents_pairs.first
    end
  end

  class Straight < Hand
    include Game::StraightComparisons
    def initialize(cards)
      @rank = 4
      super
    end
  end

  class Flush < Hand
    def initialize(cards)
      @rank = 5
      super
    end

    def compare_same_rank(opponent)
      wins_by_high_card?(opponent) 
    end
  end

  class FullHouse < Hand

    def initialize(cards)
      @rank = 6
      super
    end

    private
    def compare_same_rank(opponent)
      my_trips = duplicate_cards_of_count(self.cards, 3)
      opponent_trips = duplicate_cards_of_count(opponent.cards, 3)
      if my_trips.first == opponent_trips.first 
        my_pair = duplicate_cards_of_count(self.cards)
        opponents_pair = duplicate_cards_of_count(opponent.cards)
        return my_pair.first > opponents_pair.first
      else
        return my_trips.first > opponent_trips.first
      end
    end
  end

  class FourOfAKind < Hand
    def initialize(cards)
      @rank = 7
      super
    end

    private
    def compare_same_rank(opponent)
      my_quads = duplicate_cards_of_count(self.cards, 4).first
      opponent_quads = opponent.duplicate_cards_of_count(opponent.cards, 4).first
      if my_quads == opponent_quads 
        return wins_by_high_card?(opponent) 
      end
      return my_quads > opponent_quads
    end
  end

  class StraightFlush < Hand
    include Game::StraightComparisons
    def initialize(cards)
      @rank = 8
      super
    end
  end
end
