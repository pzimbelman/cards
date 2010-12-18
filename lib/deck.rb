require File.dirname(__FILE__) + '/game_constants.rb'
require File.dirname(__FILE__) + '/card.rb'

module Game
  EmptyDeck = Class.new(RuntimeError) 

  class Deck
    def initialize
      @cards = create_cards
    end

    def next_card
     index = rand(self.card_count)
     card_to_select =  remaining_cards[index]
     select_card(card_to_select.to_s)
    end

    def select_card(id)
      raise EmptyDeck unless card_count > 0
      @cards.delete(id)
    end

    def card_count
      @cards.size
    end

    def remaining_cards
      @cards.values
    end

    private
    def create_cards
      cards = {}
      RANKS.each do |rank|
        SUITS.each do |suit|
          card = Card.new(rank, suit)
          cards[card.to_s] = card
        end
      end
      cards
    end
  end
end
