module Game
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
  SUITS = ["Hearts", "Spades", "Diamonds", "Clubs"]

  class EmptyDeck < RuntimeError
  end

  class Card
    attr_reader :suit, :rank
    def initialize(rank, suit)
      @suit = suit
      @rank = rank
    end

    def to_s
      "#{rank} #{suit}"
    end

    def ==(opponent)
      !self.beats?(opponent) && !opponent.beats?(self)
    end

    def <(opponent)
      opponent.beats?(self)
    end

    def >(opponent)
      self.beats?(opponent)
    end
    
    def <=>(card)
      if self > card
        return 1
      elsif self < card
        return -1
      end
      return 0
    end

    protected
    def beats?(opponent)
      RANKS.find_index(rank) > RANKS.find_index(opponent.rank)
    end
  end


  class Deck
    def initialize
      @cards = {}
      create_cards
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
      @cards.values.size
    end

    def remaining_cards
      @cards.values
    end

    private
    def create_cards
      RANKS.each do |rank|
        SUITS.each do |suit|
          card = Card.new(rank, suit)
          @cards[card.to_s] = card
        end
      end
    end
  end

  class Hand
    attr_reader :rank, :cards
    def initialize(cards)
      @cards = cards.sort { |a,b| b <=> a }
    end

    def self.best_possible(cards)
      return HighCard.new(cards)
    end

    def high_card
      @cards.first
    end
  
    protected
    def beats?(opponent)
      self.rank > opponent.rank 
    end

    def determine_winner_by(opponent)
      if self.rank == opponent.rank
        return yield 
      end
      self.beats?(opponent)
    end

    def wins_by_high_card?(opponent)
      @cards.size.times do |index|
        if @cards[index] != opponent.cards[index]
          return @cards[index] > opponent.cards[index]
        end
      end
      false
    end

    def duplicate_cards_of_count(count=2)
      duplicate_cards_of_count = []
      pairs = Hash.new(0)
      @cards.each do |card|
        pairs[card.rank] += 1 
        if pairs[card.rank] == 2
          duplicate_cards_of_count << card
        end
      end
      duplicate_cards_of_count
    end
  end

  class HighCard < Hand
    def initialize(cards)
      @rank = 0
      super
    end

    def >(opponent)
      determine_winner_by(opponent) { wins_by_high_card?(opponent) }
    end
  end

  class Pair < Hand
    def initialize(cards)
      @rank = 1
      super
    end

    def >(opponent)
      determine_winner_by(opponent) { compare_pairs(opponent) }
    end

    private
    def compare_pairs(opponent)
       my_pairs =  duplicate_cards_of_count
       opponents_pairs = opponent.duplicate_cards_of_count 
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

    def >(opponent)
      determine_winner_by(opponent) { compare_pairs(opponent) }
    end

    private
    def compare_pairs(opponent)
      my_pairs = duplicate_cards_of_count
      opponents_pairs = opponent.duplicate_cards_of_count
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

    def >(opponent)
      determine_winner_by(opponent) { compare_trips(opponent) }
    end

    def compare_trips(opponent)
      my_pairs = duplicate_cards_of_count(3)
      opponents_pairs = opponent.duplicate_cards_of_count(3)
       if my_pairs.first == opponents_pairs.first
         return wins_by_high_card?(opponent)
       end
      return my_pairs.first > opponents_pairs.first
    end
  end
end 
