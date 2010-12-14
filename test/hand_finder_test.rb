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

  def test_should_get_best_straight_from_more_than_5_cards
    hand = best_possible_hand_from("7 Diamonds", "8 Spades", "10 Clubs",
                                   "J Spades", "9 Spades", "Q Hearts", 
                                   "K Spades")
    assert_equal Game::Straight, hand.class
    assert_equal ["K", "Q", "J", 10, 9], hand.ranks
  end

  def test_should_get_best_flush_from_more_than_5_cards
    hand = best_possible_hand_from("2 Spades", "3 Spades", "10 Spades",
                                   "J Spades", "9 Spades", "Q Spades", 
                                   "A Diamonds")
    assert_equal Game::Flush, hand.class
    assert_equal ["Q", "J", 10, 9, 3], hand.ranks
  end

  def test_should_get_best_full_house_from_more_than_5_cards
    hand = best_possible_hand_from("2 Spades", "2 Clubs", "A Spades",
                                   "J Spades", "A Diamonds", "2 Hearts", 
                                   "A Clubs")
    assert_equal Game::FullHouse, hand.class
    assert_equal ["A", "A", "A", 2, 2], hand.ranks
  end

  def test_should_get_four_of_a_kind_from_more_than_5_cards
    hand = best_possible_hand_from("2 Spades", "2 Clubs", "A Spades",
                                   "A Hearts", "2 Diamonds", "2 Hearts", 
                                   "A Clubs")
    assert_equal Game::FourOfAKind, hand.class
    assert_equal ["A", 2, 2, 2, 2], hand.ranks
  end


  def test_should_error_when_given_fewer_than_five_cards
    assert_raise Game::TooFewCards do
      best_possible_hand_from("2 Spades", "2 Clubs", "A Spades", "3 Hearts")
    end

  end
  def best_possible_hand_from(*cards)
    cards = create_cards(*cards)
    Game::HandFinder.best_possible_hand_from(cards)
  end
end
