module Game
  module Helpers
    def all_same_suit?(cards)
      cards.suits.uniq.size == 1
    end

    def is_a_straight?(cards)
      return true if is_ace_to_five?(cards)
      (cards.size - 2).times do |index|
        return false unless in_order?(cards[index], cards[index+1])
      end
      return true
    end

    def is_ace_to_five?(cards)
      cards.ranks == ["A", 5, 4, 3, 2]
    end

    def in_order?(card, next_card)
      (rank_index_of(card) - 1 ) == rank_index_of(next_card)
    end

    def rank_index_of(card)
      RANKS.find_index(card.rank)
    end
  end
end