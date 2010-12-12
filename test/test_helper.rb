require File.dirname(__FILE__) + '/../lib/card.rb'
module TestHelper

  def assert_invalid_hand_of_type(klass, *cards)
    cards = create_cards(*cards)
    assert_raise Game::InvalidHand do
      klass.create(cards) 
    end
  end

  def create_cards(*cards)
    hand = []
    cards.each do |c| 
       rank, suit = c.split(" ") 
       rank = rank.to_i if rank < "A"
       hand << Game::Card.new(rank, suit)
    end
    return hand 
  end

  def two_pair_hand_from(*cards)
    cards = create_cards(*cards)
    Game::TwoPair.create(cards)
  end

  def high_card_hand_from(*cards)
    cards = create_cards(*cards)
    Game::HighCard.create(cards)
  end

  def pair_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Pair.create(cards)
  end

  def trip_hand_from(*cards)
    cards = create_cards(*cards)
    Game::ThreeOfAKind.create(cards)
  end

  def straight_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Straight.create(cards)
  end

  def flush_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Flush.create(cards)
  end

  def full_house_hand_from(*cards)
    cards = create_cards(*cards)
    Game::FullHouse.create(cards)
  end

  def quads_hand_from(*cards)
    cards = create_cards(*cards)
    Game::FourOfAKind.create(cards)
  end
  def straight_flush_from(*cards)
    cards = create_cards(*cards)
    Game::StraightFlush.create(cards)
  end
end
