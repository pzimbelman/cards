require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/card_info.rb'

class CardInfoTest < Test::Unit::TestCase
  include TestHelper

  def test_should_error_when_given_too_many_cards
    assert_raise Game::NotFiveCards do
      card_info_for("3 Spades", "2 Hearts", "5 Clubs",
                     "A Diamonds", "K Diamonds", "5 Hearts")
    end
  end

  def test_should_error_when_given_too_few_cards
    assert_raise Game::NotFiveCards do
      card_info_for("5 Clubs", "A Diamonds", "K Diamonds", "5 Hearts")
    end
  end

  def test_should_have_no_pairs
    info = card_info_for("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert_nil info.pairs
  end

  def test_should_have_two_pairs
    info = card_info_for("3 Spades", "A Hearts", "5 Clubs",
                                "A Diamonds", "3 Diamonds")
    assert_equal 2, info.pairs.size
    assert_equal "A", info.pairs.first.rank
    assert_equal 3, info.pairs.last.rank
  end

  def test_should_have_trips_and_pair
    info = card_info_for("3 Spades", "A Hearts", "A Clubs",
                                "A Diamonds", "3 Diamonds")
    assert_equal 1, info.pairs.size
    assert_equal 1, info.trips.size
    assert_equal "A", info.trips.first.rank
  end

  def test_should_have_quads
    info = card_info_for("3 Spades", "A Hearts", "A Clubs",
                                "A Diamonds", "A Spades")
    assert_equal 1, info.quads.size
    assert_equal "A", info.quads.first.rank
  end

  def test_should_not_count_quads_as_pair_or_trips
    info = card_info_for("3 Spades", "A Hearts", "A Clubs",
                                "A Diamonds", "A Spades")
    assert_nil info.trips
    assert_nil info.pairs
  end

  def test_should_not_count_trips_as_pair
    info = card_info_for("3 Spades", "A Hearts", "A Clubs",
                                "Q Diamonds", "A Spades")
    assert_nil info.pairs
  end

  def test_should_be_a_flush
    info = card_info_for("3 Spades", "2 Spades", "5 Spades",
                                "A Spades", "K Spades")
    assert info.flush?
  end

  def test_should_not_be_a_flush
    info = card_info_for("3 Spades", "2 Spades", "5 Spades",
                                "A hearts", "K Spades")
    assert !info.flush?
  end

  def test_should_not_be_a_straight
    info = card_info_for("10 Spades", "J Diamonds", "2 Spades",
                                "9 hearts", "K Spades")
    assert !info.straight?
  end

  def test_should_be_a_straight
    info = card_info_for("10 Spades", "J Diamonds", "Q Spades",
                                "9 hearts", "K Spades")
    assert info.straight?
  end

  def test_ace_to_five_straight
    info = card_info_for("2 Spades", "3 Diamonds", "4 Spades",
                                "5 hearts", "A Spades")
    assert info.straight?
  end

  def card_info_for(*cards)
    cards = create_cards(*cards)
    Game::CardInfo.info_for(cards)
  end

end
