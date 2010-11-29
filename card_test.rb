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

  def setup
    @trips = trip_hand_from("2 Spades", "2 Hearts", "2 Clubs", 
                           "7 Clubs", "J Spades") 
    @pair  = pair_hand_from("9 Spades", "9 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    @two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "Q Hearts")
    @high_card = high_card_hand_from("3 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    @straight = straight_hand_from("5 Spades", "6 Clubs", "7 Clubs", 
                                   "8 Hearts", "9 Clubs")
    @flush = flush_hand_from("K Clubs", "6 Clubs", "7 Clubs", 
                                   "8 Clubs", "9 Clubs")
    @full_house = full_house_hand_from("K Clubs", "K Hearts", "K Spades", 
                                   "9 Diamonds", "9 Clubs")
    @four_of_a_kind = quads_hand_from("K Clubs", "K Hearts", "K Spades", 
                                   "K Diamonds", "9 Clubs")
  end

  def test_should_define_high_card
    assert_equal "A Diamonds", @high_card.high_card.to_s
    assert_equal "J Spades", @trips.high_card.to_s
  end

  def test_should_define_ranks_for_hands
    assert_equal 0, @high_card.rank
    assert_equal 1, @pair.rank
    assert_equal 2, @two_pair.rank
    assert_equal 3, @trips.rank
    assert_equal 4, @straight.rank
    assert_equal 5, @flush.rank
    assert_equal 6, @full_house.rank
    assert_equal 7, @four_of_a_kind.rank
  end


  def test_four_of_a_kind_should_beat_inferior_hands
    assert @four_of_a_kind > @trips
    assert @four_of_a_kind > @straight
    assert @four_of_a_kind> @full_house
  end


  def test_quads_against_other_quads
    losing_quads = quads_hand_from("8 Clubs", "8 Hearts", "8 Spades", 
                                   "8 Diamonds", "9 Clubs")
    winning_quads = quads_hand_from("K Clubs", "K Hearts", "K Spades", 
                                   "K Diamonds", "9 Clubs")
    assert winning_quads > losing_quads
  end

  def test_quads_against_other_quads_win_by_high_card
    losing_quads = quads_hand_from("K Clubs", "K Hearts", "K Spades", 
                                   "K Diamonds", "9 Clubs")
    winning_quads = quads_hand_from("K Clubs", "K Hearts", "K Spades", 
                                   "K Diamonds", "A Clubs")
    assert winning_quads > losing_quads
  end
  def test_full_house_should_beat_inferior_hands
    assert @full_house > @high_card
    assert @full_house > @pair
    assert @full_house > @two_pair
    assert @full_house > @trips
    assert @full_house > @straight
    assert !(@full_house > @four_of_a_kind)
  end

  def test_flush_should_beat_inferior_hands
    assert @flush > @high_card
    assert @flush > @pair
    assert @flush > @two_pair
    assert @flush > @trips
    assert @flush > @straight
    assert !(@flush > @full_house)
  end

  def test_full_house_against_other_full_house
    losing_full_house = full_house_hand_from("Q Clubs", "Q Spades", "Q Hearts",
                                         "J Diamonds", "J Clubs")
    better_full_house = full_house_hand_from("A Clubs", "A Spades", 
                                      "A Hearts", "J Diamonds", "J Clubs")
    assert better_full_house > losing_full_house
    assert !(losing_full_house > better_full_house)
  end

  def test_full_house_against_other_full_house_down_to_pair
    losing_full_house = full_house_hand_from("Q Clubs", "Q Spades", "Q Hearts",
                                         "8 Diamonds", "8 Clubs")
    better_full_house = full_house_hand_from("Q Clubs", "Q Spades", 
                                      "Q Hearts", "J Diamonds", "J Clubs")
    assert better_full_house > losing_full_house
    assert !(losing_full_house > better_full_house)
  end

  def test_flush_against_other_flush
    losing_flush = flush_hand_from("6 Clubs", "7 Clubs", "2 Clubs",
                                         "9 Clubs", "J Clubs")
    better_flush = flush_hand_from("6 Clubs", "7 Clubs", "2 Clubs",
                                         "9 Clubs", "A Clubs")
    assert better_flush > losing_flush
    assert !(losing_flush > better_flush)
  end

  def test_flush_against_other_flush_compare_several_cards
    losing_flush = flush_hand_from("5 Clubs", "7 Clubs", "2 Clubs",
                                         "9 Clubs", "A Clubs")
    better_flush = flush_hand_from("6 Clubs", "7 Clubs", "2 Clubs",
                                         "9 Clubs", "A Clubs")
    assert better_flush > losing_flush
    assert !(losing_flush > better_flush)
  end

  def test_straight_should_beat_inferior_hands
    assert @straight > @high_card
    assert @straight > @pair
    assert @straight > @two_pair
    assert @straight > @trips
    assert !(@straight > @flush)
  end

  def test_straight_against_other_straight
    losing_straight = straight_hand_from("6 Clubs", "7 Clubs", "8 Hearts",
                                         "9 Spades", "10 Spades")
    better_straight = straight_hand_from("8 Hearts", "9 Spades", "10 Spades",
                                         "J Diamonds", "Q Clubs")
    assert better_straight > losing_straight
    assert !(losing_straight > better_straight)
  end

  def test_A_to_5_straight_against_other_straight
    losing_straight = straight_hand_from("A Clubs", "2 Clubs", "3 Hearts",
                                         "4 Spades", "5 Spades")
    better_straight = straight_hand_from("2 Hearts", "3 Spades", "4 Spades",
                                         "5 Diamonds", "6 Clubs")
    assert better_straight > losing_straight
    assert !(losing_straight > better_straight)
  end

  def test_three_of_a_kind_should_beat_inferior_hands
    assert @trips > @high_card
    assert @trips > @pair 
    assert @trips > @two_pair
    assert !(@trips > @straight)
  end

  def test_three_of_a_kind_against_other_trips
    trip_hand = trip_hand_from("2 Spades", "2 Hearts", "2 Clubs", 
                           "10 Clubs", "6 Spades") 
    better_trip_hand = trip_hand_from("8 Spades", "8 Hearts", "8 Clubs", 
                           "7 Clubs", "J Spades") 
    
    assert better_trip_hand > trip_hand
    trip_hand = trip_hand_from("K Spades", "K Hearts", "K Clubs", 
                           "7 Clubs", "J Spades") 
    better_trip_hand = trip_hand_from("A Spades", "A Hearts", "A Clubs", 
                           "2 Clubs", "4 Spades") 
    
    assert !(trip_hand > better_trip_hand)
  end

  def test_three_of_a_kind_win_by_high_card
    trip_hand = trip_hand_from("K Spades", "K Hearts", "K Clubs", 
                           "7 Clubs", "J Spades") 
    better_trip_hand = trip_hand_from("K Spades", "K Hearts", "K Clubs", 
                           "2 Clubs", "A Spades") 
    
    assert better_trip_hand > trip_hand
  end

  def test_two_pair_should_beat_inferior_hands
    assert @two_pair > @pair 
    assert !(@pair > @two_pair) 
    assert @two_pair > @high_card
    assert !(@high_card > @two_pair)
  end

  def test_two_pair_against_other_two_pair
    losing_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "A Hearts")
    better_two_pair = two_pair_hand_from("J Spades", "J Clubs", "7 Spades",
                                   "A Diamonds", "A Clubs")
    assert better_two_pair > losing_two_pair

    losing_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "2 Spades", "2 Hearts")
    better_two_pair = two_pair_hand_from("J Spades", "J Clubs", "7 Spades",
                                   "9 Diamonds", "9 Hearts")
    assert !(losing_two_pair > better_two_pair)

    better_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "A Hearts")
    losing_two_pair = two_pair_hand_from("8 Spades", "8 Clubs", "7 Spades",
                                   "Q Diamonds", "Q Clubs")
    assert better_two_pair > losing_two_pair
  end

  def test_two_pair_win_by_high_card
    losing_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "6 Spades",
                                   "A Spades", "A Hearts")
    better_two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "10 Spades",
                                   "A Diamonds", "A Clubs")
    assert better_two_pair > losing_two_pair
  end

  def test_pair_should_beat_lower_pair
    pair  = pair_hand_from("2 Spades", "2 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    higher_pair = pair_hand_from("J Spades", "J Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert !(pair > higher_pair) 
    assert higher_pair > pair 
  end

  def test_pair_win_by_high_card
    lower_pair  = pair_hand_from("J Spades", "J Hearts", "5 Clubs",
                                "A Diamonds", "Q Diamonds")
    higher_pair = pair_hand_from("J Spades", "J Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    assert higher_pair > lower_pair
  end

  def test_pair_beats_inferior_hands
    assert @pair > @high_card
    assert !(@pair > @two_pair)
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

   second_hand = high_card_hand_from("10 Hearts", "J Hearts", "2 Clubs", 
                       "4 Spades", "9 Diamonds")
   assert second_hand > first_hand
  end

  def test_high_card_cannot_beat_better_hands
    assert !(@high_card > @pair)
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

  def trip_hand_from(*cards)
    cards = create_cards(*cards)
    Game::ThreeOfAKind.new(cards)
  end

  def straight_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Straight.new(cards)
  end

  def flush_hand_from(*cards)
    cards = create_cards(*cards)
    Game::Flush.new(cards)
  end
  def full_house_hand_from(*cards)
    cards = create_cards(*cards)
    Game::FullHouse.new(cards)
  end
  def quads_hand_from(*cards)
    cards = create_cards(*cards)
    Game::FourOfAKind.new(cards)
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



