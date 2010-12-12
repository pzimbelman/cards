require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/cards_container.rb'

class CardsContainerTest < Test::Unit::TestCase
  include TestHelper

  def test_can_create_container
    container = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert container.cards
    assert_equal 5, container.size
  end

  def test_should_return_ranks
    container = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert_equal [9,9,6,2,2], container.ranks
  end

  def test_cards_should_be_sorted_descending
    container = create_cards("3 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "2 Hearts")
    assert_equal ["A",9,6,3,2], container.ranks
    assert_equal "A", container.first.rank
  end

  def test_should_return_suits
    container = create_cards("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    assert_equal ["Spades","Clubs", "Spades", "Spades", "Hearts"], 
                  container.suits

  end
end
