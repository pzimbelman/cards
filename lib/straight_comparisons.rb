module Game
  module StraightComparisons
    protected
    def is_ace_to_five?
      if high_card.rank == "A" && @cards[1].rank == 5
        return true
      end
    end

    private
    def compare_same_rank(opponent)
      if is_ace_to_five?
        return false
      elsif opponent.is_ace_to_five?
        return true
      end
      return self.high_card > opponent.high_card
    end
  end
end
