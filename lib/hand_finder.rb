require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class HandFinder
    HANDS_WORST_TO_BEST = [ Game::HighCard, Game::Pair, Game::TwoPair,
                            Game::ThreeOfAKind, Game::Straight, 
                            Game::Flush, Game::FullHouse, 
                            Game::FourOfAKind, Game::StraightFlush ]
    class << self
      def best_possible_hand_from(cards)
        best_of(possible_hands_from(cards))
      end

      private
      def best_of(hands)
        hands.sort! { |a,b| b <=> a }.first
      end

      def find_hand_for(cards)
        HANDS_WORST_TO_BEST.each do |hand_class|
          hand = hand_class.create(cards)
          break hand if hand
        end
      end

      def possible_hands_from(cards)
        possible_hands = []
        cards.five_card_combos.each do |five_card_combo|
          possible_hands << find_hand_for(five_card_combo)
        end
        possible_hands
      end
    end
  end
end
