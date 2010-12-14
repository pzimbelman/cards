require File.dirname(__FILE__) + '/../lib/hand.rb'

module Game
  class HandFinder
    HANDS = [Game::StraightFlush, Game::FourOfAKind, Game::FullHouse, 
             Game::Flush, Game:: Straight, Game::ThreeOfAKind,
             Game::TwoPair, Game::Pair, Game::HighCard] 

    def self.best_possible_from(cards)
      HANDS.each do |hand_class|
        if hand = hand_class.create(cards)
          return hand
        end
      end
    end

  end
end
