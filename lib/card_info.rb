require File.dirname(__FILE__) + '/game_helpers.rb'

module Game

  NotFiveCards = Class.new(ArgumentError)

  class CardInfo
    extend StraightHelpers
    extend FlushHelpers
    extend CardHelpers

    def initialize(groupings, is_flush, is_straight)
      @groupings = groupings
      @is_flush = is_flush
      @is_straight = is_straight
    end

    def flush?
      @is_flush
    end

    def straight?
      @is_straight
    end

    def pairs
      @groupings[2]
    end

    def trips 
      @groupings[3]
    end

    def quads
      @groupings[4]
    end

    def self.info_for(cards)
      raise NotFiveCards unless cards.size == 5
      groupings = Groupings.new(cards)
      is_flush = all_same_suit?(cards)
      is_straight = is_a_straight?(cards)
      self.new(groupings, is_flush, is_straight) 
    end
  end

  Grouping = Array
  CardCountHash = Hash

  class Groupings
    def initialize(cards)
      @groupings = (0..4).map { Grouping.new }
      counts = CardCountHash.new(0)
      cards.each do |card|
        counts[card.rank] += 1
        add(card, counts[card.rank])
        delete(card, counts[card.rank] - 1)
      end
    end

    def [](index)
      @groupings[index].empty? ? nil : @groupings[index]
    end

    def add(card, index)
      @groupings[index] << card
      @groupings[index].sort { |a,b| b <=> a }
    end

    def delete(card, index)
      @groupings[index].delete_if { |c| c.rank == card.rank }
    end
  end
end
