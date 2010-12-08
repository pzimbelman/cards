require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/card_info.rb'

class CardInfoTest < Test::Unit::TestCase
  include TestHelper

  def test_should_have_no_pairs
    cards = create_cards("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    info = Game::CardInfo.info_for(cards)
    assert_nil info.pairs
  end

  def test_should_have_two_pairs
    cards = create_cards("3 Spades", "A Hearts", "5 Clubs",
                                "A Diamonds", "3 Diamonds")
    info = Game::CardInfo.info_for(cards)
    assert_equal 2, info.pairs.size
    assert_equal "A", info.pairs.first.rank
    assert_equal 3, info.pairs.last.rank
  end

  def test_should_have_trips_and_pair
    cards = create_cards("3 Spades", "A Hearts", "A Clubs",
                                "A Diamonds", "3 Diamonds")
    info = Game::CardInfo.info_for(cards)
    assert_equal 1, info.pairs.size
    assert_equal 1, info.trips.size
    assert_equal "A", info.trips.first.rank
  end

  def test_should_have_quads
    cards = create_cards("3 Spades", "A Hearts", "A Clubs",
                                "A Diamonds", "A Spades")
    info = Game::CardInfo.info_for(cards)
    assert_equal 1, info.quads.size
    assert_equal "A", info.quads.first.rank
  end

  def test_should_be_a_flush
    cards = create_cards("3 Spades", "2 Spades", "5 Spades",
                                "A Spades", "K Spades")
    info = Game::CardInfo.info_for(cards)
    assert info.flush?
  end
end
