require File.dirname(__FILE__) + '/hand_helpers.rb'

module Game

  class TooManyCards < ArgumentError 
  end

  class CardInfo
    extend Game::HandHelpers

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
      raise TooManyCards unless cards.size == 5
      groupings = Groupings.create(cards)
      is_flush = all_same_suit?(cards)
      is_straight = is_a_straight?(cards)
      self.new(groupings, is_flush, is_straight) 
    end
  end

  class Groupings
    def self.create(cards)
      groupings = self.new
      counts = Hash.new(0)
      cards.each do |card|
        counts[card.rank] += 1
        groupings.add(card, counts[card.rank])
        groupings.delete(card, counts[card.rank] - 1)
      end
      groupings
    end

    def initialize
      @groupings = []
      (0..4).each do |index|
        @groupings[index] = []
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
