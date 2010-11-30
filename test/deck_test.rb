require 'test/unit'
require File.dirname(__FILE__) + '/../lib/deck.rb'

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Game::Deck.new
  end

  def test_can_create_deck
    assert_equal 52, @deck.card_count
  end

  def test_select_card
    card = @deck.select_card("10 Spades")
    assert_equal 10, card.rank
    assert_equal "Spades", card.suit
    assert_equal 51, @deck.card_count
    
    card = @deck.select_card("K Hearts")
    assert_equal "K", card.rank
    assert_equal "Hearts", card.suit
    assert_equal 50, @deck.card_count
  end

  def test_next_card
    card = @deck.next_card
    assert card.rank
    assert card.suit
  end

  def test_next_card_decrementing
    51.times { @deck.next_card }
    assert_equal 1, @deck.card_count
  end

  def test_should_error_when_out_of_cards_for_next
    assert_raise Game::EmptyDeck do
      53.times { @deck.next_card }
    end
  end

  def test_should_error_when_out_of_cards_for_select
    all_cards = @deck.remaining_cards 
    assert_raise Game::EmptyDeck do
      all_cards.each { |c| @deck.select_card(c.to_s) }
      @deck.select_card("foo bar")
    end
  end
end
