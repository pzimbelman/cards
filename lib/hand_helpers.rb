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
  end
end
