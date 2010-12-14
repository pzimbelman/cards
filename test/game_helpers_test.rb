require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/game_helpers.rb'

class HandHelpersTest < Test::Unit::TestCase
  include TestHelper
  include Game::FlushHelpers

  def test_not_all_same_suit
    cards = create_cards("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert !all_same_suit?(cards)
  end

  def test_all_same_suit_should_be_true
    cards = create_cards("3 Diamonds", "2 Diamonds", "5 Diamonds",
                                "A Diamonds", "K Diamonds")
    assert all_same_suit?(cards)
  end
end
