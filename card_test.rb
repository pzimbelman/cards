require 'test/unit'
require 'card'

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

class HandTest < Test::Unit::TestCase
  def test_should_create_high_card
   cards = create_cards("A Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "8 Diamonds")
   hand = Game::Hand.best_possible(cards)
   assert_equal Game::HighCard, hand.class 
   assert_equal "A Hearts", hand.high_card.to_s
  end

  def test_should_define_ranks_for_hands
    assert_equal 0, Game::HighCard.new([]).rank
    assert_equal 1, Game::Pair.new([]).rank
    assert_equal 2, Game::TwoPair.new([]).rank
  end

  def test_pair_should_beat_high_card
    pair  = pair_hand_from("2 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    high_card_hand = high_card_hand_from("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert pair > high_card_hand 
    assert !(high_card_hand >  pair)
  end

  def test_two_pair_should_beat_inferior_hands
    pair  = pair_hand_from("9 Spades", "9 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "Q Hearts")
    high_card_hand = high_card_hand_from("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")

    assert two_pair > pair 
    assert !(pair > two_pair) 
    assert two_pair > high_card_hand
    assert !(high_card_hand > two_pair)
  end

  def test_two_pair_against_other_two_pair
    losing_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "Q Hearts")
    better_two_pair = two_pair_hand_from("J Spades", "J Clubs", "7 Spades",
                                   "9 Diamonds", "9 Hearts")
    assert better_two_pair > losing_two_pair

    losing_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    better_two_pair = two_pair_hand_from("J Spades", "J Clubs", "7 Spades",
                                   "9 Diamonds", "9 Hearts")
    assert !(losing_two_pair > better_two_pair)
  end

  def test_pair_should_beat_lower_pair
    pair  = pair_hand_from("2 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    higher_pair = pair_hand_from("J Spades", "J Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert !(pair > higher_pair) 
    assert higher_pair > pair 
  end

  def test_should_define_greater_than_on_high_card
   first_hand = high_card_hand_from("A Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "8 Diamonds")
   second_hand = high_card_hand_from("K Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "8 Diamonds")
   assert first_hand > second_hand

   second_hand = high_card_hand_from("A Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "8 Diamonds")
   assert !(first_hand > second_hand)

   first_hand = high_card_hand_from("10 Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "8 Diamonds")
   assert second_hand > first_hand
  end


  def two_pair_hand_from(*cards)
    cards = create_cards(*cards)
    Game::TwoPair.new(cards)
  end

  def high_card_hand_from(*cards)
    cards = create_cards(*cards)
    Game::HighCard.new(cards)
  end
  def pair_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Pair.new(cards)
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
end



