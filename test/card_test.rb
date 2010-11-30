require 'test/unit'
require File.dirname(__FILE__) + '/../lib/card.rb'

class CardTest < Test::Unit::TestCase

  def test_can_create_card
    card = Game::Card.new(10, "Spades")
    assert_equal "Spades", card.suit
    assert_equal 10, card.rank
  end

  def test_spaceship_operator_on_cards
    assert_equal 1, Game::Card.new("A", "Clubs") <=> Game::Card.new(2, "Spades")
    assert_equal 0, Game::Card.new(10, "Clubs") <=> Game::Card.new(10, "Spades")
    assert_equal -1, Game::Card.new("J", "Clubs") <=> Game::Card.new("Q", "Spades")
  end

  def test_to_string
    card = Game::Card.new(10, "Spades")
    assert_equal "10 Spades", "#{card}"
  end

  def test_card_equality
    assert Game::Card.new(2, "Clubs") == Game::Card.new(2, "Clubs")
    assert !(Game::Card.new("A", "Clubs") == Game::Card.new(10, "Clubs"))
  end

  def test_card_less_than_comparison
    assert Game::Card.new(2, "Clubs") < Game::Card.new(3, "Spades")
    assert Game::Card.new(10, "Clubs") < Game::Card.new("J", "Spades")
    assert Game::Card.new("J", "Clubs") < Game::Card.new("Q", "Spades")
    assert Game::Card.new("J", "Clubs") < Game::Card.new("K", "Spades")
    assert !(Game::Card.new("A", "Spades") < Game::Card.new("J", "Clubs"))
  end

  def test_card_greater_than_comparison
    assert Game::Card.new(6, "Clubs") > Game::Card.new(3, "Spades")
    assert Game::Card.new("A", "Clubs") > Game::Card.new("K", "Spades")
    assert Game::Card.new("J", "Clubs") > Game::Card.new(10, "Spades")
    assert Game::Card.new("A", "Clubs") > Game::Card.new("J", "Spades")
    assert !(Game::Card.new("Q", "Clubs") > Game::Card.new("K", "Spades"))
  end
end





