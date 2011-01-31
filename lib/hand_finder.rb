require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class HandFinder
    HANDS_WORST_TO_BEST = [ Game::HighCard, Game::Pair, Game::TwoPair,
                            Game::ThreeOfAKind, Game::Straight, 
                            Game::Flush, Game::FullHouse, 
                            Game::FourOfAKind, Game::StraightFlush ]
    class << self
      def best_possible_hand_from(cards)
        possible_hands_from(cards).max
      end

      private

      def find_hand_for(cards)
        HANDS_WORST_TO_BEST.each do |hand_class|
          hand = hand_class.create(cards)
          break hand if hand
        end
      end

      def possible_hands_from(cards)
        cards.five_card_combos.map do |five_card_combo|
          find_hand_for(five_card_combo)
        end
      end
    end
  end
end
