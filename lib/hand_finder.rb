require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game

  class TooFewCards < ArgumentError
  end

  class HandFinder

    HANDS_WORST_TO_BEST = [ Game::HighCard, Game::Pair, Game::TwoPair,
                            Game::ThreeOfAKind, Game::Straight, 
                            Game::Flush, Game::FullHouse, 
                            Game::FourOfAKind, Game::StraightFlush ]
    class << self
      def best_possible_hand_from(cards)
        raise TooFewCards unless cards.size >= 5
        best_of(possible_hands_from(cards))
      end

      private
      def best_of(hands)
        hands.sort! { |a,b| b <=> a }.first
      end

      def find_hand_for(cards)
        HANDS_WORST_TO_BEST.each do |hand_class|
          if hand = hand_class.create(cards)
            return hand
          end
        end
      end

      def possible_hands_from(cards)
        possible_hands = []
        cards.combination(5).each do |five_card_combo|
          possible_hands << find_hand_for(five_card_combo)
        end
        possible_hands
      end
    end
  end
end
