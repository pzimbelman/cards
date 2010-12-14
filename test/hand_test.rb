require 'test/unit'
require File.dirname(__FILE__) + '/../lib/hand.rb'
require File.dirname(__FILE__) + '/test_helper.rb'

class HandTest < Test::Unit::TestCase
  include TestHelper
  def setup
    @trips = trip_hand_from("2 Spades", "2 Hearts", "2 Clubs", 
                           "7 Clubs", "J Spades") 
    @pair  = pair_hand_from("9 Spades", "9 Hearts", "5 Clubs",
                                "A Diamonds", "K Diamonds")
    @two_pair = two_pair_hand_from("9 Spades", "9 Clubs", "Q Spades",
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
    @straight_flush = straight_flush_from("5 Clubs", "6 Clubs", "7 Clubs", 
                                   "8 Clubs", "9 Clubs")
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
    assert_equal 8, @straight_flush.rank
  end

  def test_straight_flush_should_beat_inferior_hands
    assert @straight_flush > @trips
    assert @straight_flush > @straight
    assert @straight_flush > @four_of_a_kind
  end

  def test_straight_comparisons_with_spaceship
    losing_straight = straight_hand_from("8 Spades", "9 Hearts", "10 Clubs",
                                         "J Spades", "Q Spades")
    better_straight = straight_hand_from("K Spades", "9 Hearts", "10 Clubs",
                                         "J Spades", "Q Spades")
    assert_equal -1, losing_straight <=> better_straight
  end

  def test_should_implement_spaceship_operator
    assert_equal 0, @trips <=> @trips
    assert_equal -1, @pair <=> @flush
    assert_equal 1, @full_house <=> @two_pair 
  end

  def test_A_to_5_straight_flush
    losing_straight_flush = straight_flush_from("A Clubs", "2 Clubs", "3 Clubs",
                                         "4 Clubs", "5 Clubs")
    better_straight_flush = straight_flush_from("2 Clubs", "3 Clubs", "4 Clubs",
                                         "5 Clubs", "6 Clubs")
    assert better_straight_flush > losing_straight_flush
    assert !(losing_straight_flush > better_straight_flush)
  end

  def test_straight_flush_against_other_straight_flush
    losing_straight_flush = straight_flush_from("10 Clubs", "6 Clubs", 
                                         "7 Clubs", "8 Clubs", "9 Clubs")
    winning_straight_flush = straight_flush_from("8 Clubs", "9 Clubs", 
                                         "10 Clubs", "J Clubs", "Q Clubs")

    assert winning_straight_flush > losing_straight_flush 
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

  def test_should_error_for_invalid_straight_flush_hand
   assert_invalid_hand_of_type(Game::StraightFlush, "7 Spades", "8 Spades",
                               "9 Spades", "10 Hearts", "J Spades")
   assert_invalid_hand_of_type(Game::StraightFlush, "7 Spades", "8 Spades",
                               "9 Spades", "A Spades", "J Spades")
  end

  def test_should_error_if_invalid_flush_hand
   assert_invalid_hand_of_type(Game::Flush, "7 Spades", "8 Spades",
                               "2 Diamonds", "Q Spades", "J Spades")
   assert_invalid_hand_of_type(Game::Flush, "7 Spades", "8 Spades",
                               "9 Spades", "10 Spades", "J Spades")
  end

  def test_should_error_if_invalid_four_of_a_kind_hand
   assert_invalid_hand_of_type(Game::FourOfAKind, "7 Spades", "8 Spades",
                               "7 Diamonds", "Q Spades", "7 Clubs")
  end

  def test_should_error_if_invalid_full_house_hand
   assert_invalid_hand_of_type(Game::FullHouse, "7 Spades", "8 Spades",
                               "7 Diamonds", "Q Spades", "7 Clubs")
   assert_invalid_hand_of_type(Game::FullHouse, "2 Spades", "8 Spades",
                               "7 Diamonds", "Q Spades", "7 Clubs")
  end
  def test_should_error_if_invalid_straight_hand
   assert_invalid_hand_of_type(Game::Straight, "7 Spades", "8 Diamonds",
                               "2 Hearts", "10 Diamonds", "J Spades")
   assert_invalid_hand_of_type(Game::Straight, "7 Hearts", "8 Hearts",
                               "9 Hearts", "10 Hearts", "J Hearts")
  end

  def test_should_error_if_invalid_two_pair_hand
   assert_invalid_hand_of_type(Game::TwoPair, "7 Spades", "7 Diamonds",
                               "10 Hearts", "Q Diamonds", "J Spades")
  end


  def test_should_error_if_invalid_three_of_a_kind
   assert_invalid_hand_of_type(Game::ThreeOfAKind, "7 Spades", "7 Diamonds",
                               "8 Hearts", "Q Diamonds", "K Spades")
   assert_invalid_hand_of_type(Game::ThreeOfAKind, "7 Spades", "7 Diamonds",
                               "7 Hearts", "Q Diamonds", "Q Spades")
  end

  def test_should_give_error_if_not_a_valid_pair_hand
   assert_invalid_hand_of_type(Game::Pair, "5 Spades", "7 Diamonds",
                               "10 Hearts", "Q Diamonds", "J Spades")
   assert_invalid_hand_of_type(Game::Pair, "10 Spades", "10 Diamonds",
                               "10 Hearts", "J Diamonds", "J Spades")
  end

  def test_should_not_be_valid_for_high_card_hands
   assert_invalid_hand_of_type(Game::HighCard, "Q Spades", "7 Diamonds",
                               "10 Hearts", "Q Diamonds", "J Spades")
   assert_invalid_hand_of_type(Game::HighCard, "Q Spades", "7 Diamonds",
                               "Q Hearts", "Q Diamonds", "J Spades")
   assert_invalid_hand_of_type(Game::HighCard, "Q Spades", "7 Diamonds",
                               "Q Hearts", "Q Diamonds", "Q Clubs")
   assert_invalid_hand_of_type(Game::HighCard, "J Spades", "7 Spades",
                               "A Spades", "2 Spades", "8 Spades")
   assert_invalid_hand_of_type(Game::HighCard, "J Spades", "7 Spades",
                               "9 Clubs", "10 Spades", "8 Spades")
  end

  def test_cannot_create_base_hand
    assert_invalid_hand_of_type(Game::Hand, "10 Spades", "3 Hearts", 
                          "4 Hearts", "J Diamonds", "8 Spades")
  end

  def test_high_card_cannot_beat_better_hands
    assert !(@high_card > @pair)
    assert !(@high_card > @straight)
  end
end
