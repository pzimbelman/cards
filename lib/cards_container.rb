module Game

  class CardsContainer
    attr_reader :cards
    def initialize(cards)
      @cards = cards
    end

    def combination(n)
      cards.combination(n).map { |combo| self.class.new(combo) }
    end

    def size
      cards.size
    end

    def first
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

    def self.create(cards)
      cards.sort! { |a,b| b <=> a }
      self.new(cards)
    end
  end
end
