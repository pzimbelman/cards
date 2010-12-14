require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/hand_finder.rb'

class HandFinderTest < Test::Unit::TestCase
  include TestHelper

  def test_should_create_high_card_hand
    hand = best_possible_hand_from("2 Spades", "5 Spades", "J Hearts",
                                   "Q Clubs", "8 Spades")
    assert_equal Game::HighCard, hand.class
  end

  def test_should_create_pair_hand
    hand = best_possible_hand_from("2 Spades", "8 Spades", "J Hearts",
                                   "Q Clubs", "8 Hearts")
    assert_equal Game::Pair, hand.class
  end

  def test_should_create_two_pair_hand
    hand = best_possible_hand_from("2 Spades", "8 Spades", "Q Hearts",
                                   "Q Clubs", "8 Hearts")
    assert_equal Game::TwoPair, hand.class
  end

  def test_should_create_three_of_a_kind_hand
    hand = best_possible_hand_from("2 Spades", "Q Spades", "Q Hearts",
                                   "Q Clubs", "8 Spades")
    assert_equal Game::ThreeOfAKind, hand.class
  end

  def test_should_create_straight_hand
    hand = best_possible_hand_from("7 Spades", "8 Spades", "J Hearts",
                                   "10 Clubs", "9 Spades")
    assert_equal Game::Straight, hand.class
  end

  def test_should_create_flush_hand
    hand = best_possible_hand_from("7 Spades", "8 Spades", "2 Spades",
                                   "10 Spades", "9 Spades")
    assert_equal Game::Flush, hand.class
  end

  def test_should_create_full_house
    hand = best_possible_hand_from("7 Clubs", "7 Spades", "Q Spades",
                                   "7 Diamonds", "Q Hearts")
    assert_equal Game::FullHouse, hand.class
  end

  def test_should_create_four_of_a_kind
    hand = best_possible_hand_from("7 Clubs", "7 Spades", "Q Spades",
                                   "7 Diamonds", "7 Hearts")
    assert_equal Game::FourOfAKind, hand.class
  end

  def test_should_create_straight_flush_hand
    hand = best_possible_hand_from("7 Spades", "8 Spades", "10 Spades",
                                   "J Spades", "9 Spades")
    assert_equal Game::StraightFlush, hand.class
  end

  def best_possible_hand_from(*cards)
    cards = create_cards(*cards)
    Game::HandFinder.best_possible_from(cards)
  end
end
