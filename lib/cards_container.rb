module Game

  class CardsContainer
    attr_reader :cards
    def initialize(cards=[])
      @cards = cards
      order_cards
    end

    def five_card_combos 
      cards.combination(5).map { |combo| self.class.new(combo) }
    end

    def size
      cards.size
    end

    def high_card
      first
    end

    def first
      cards.first
    end

    def last
      cards.last
    end

    def each(&block)
      cards.each(&block)
    end

    def [](index)
      cards[index]
    end

    def ranks
      cards.map(&:rank)
    end

    def suits
      cards.map(&:suit)
    end

    def <<(card)
      cards << card
      order_cards
    end

    def delete_if(&block)
      cards.delete_if(&block)
    end

    def empty?
      cards.empty?
    end
 
    private
    def order_cards
      cards.sort! { |a,b| b <=> a }
    end
  end
end
