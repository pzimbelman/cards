module Game

  class CardsContainer
    attr_reader :cards
    def initialize(cards)
      cards.sort! { |a,b| b <=> a }
      @cards = cards
    end

    def five_card_combos 
      cards.combination(5).map { |combo| self.class.new(combo) }
    end

    def size
      cards.size
    end

    def high_card
      cards.first
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
  end
end
