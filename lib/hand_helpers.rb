module Game
  module HandHelpers
    def duplicate_cards_of_count(cards, count=2)
      duplicate_cards_of_count = []
      pairs = Hash.new(0)
      cards.each do |card|
        pairs[card.rank] += 1 
        duplicate_cards_of_count << card if pairs[card.rank] == count
      end
      duplicate_cards_of_count.delete_if { |c| pairs[c.rank] > count }
      duplicate_cards_of_count
    end

    def all_same_suit?(cards)
      (cards.size - 2).times do |index|
        return false if cards[index].suit != cards[index + 1].suit
      end
      return true
    end

    def is_a_straight?(cards)
      cards.sort! { |a,b| b <=> a }
      return true if is_ace_to_five?(cards)
      (cards.size - 2).times do |index|
        return false unless in_order?(cards[index], cards[index+1])
      end
      return true
    end

    def is_ace_to_five?(cards)
      ranks = cards.map { |card| card.rank }
      ranks == ["A", 5, 4, 3, 2]
    end

    def in_order?(card, next_card)
      (Game::RANKS.find_index(card.rank) - 1 ) == Game::RANKS.find_index(next_card.rank)
    end
  end
end
