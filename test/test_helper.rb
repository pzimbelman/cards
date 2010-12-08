require File.dirname(__FILE__) + '/../lib/card.rb'
module TestHelper
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
