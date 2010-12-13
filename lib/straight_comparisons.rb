module Game
  module StraightComparisons

    private
    def compare_same_rank(opponent)
      if is_ace_to_five?(cards)
        return false
      elsif is_ace_to_five?(opponent.cards)
        return true
      end
      return self.high_card > opponent.high_card
    end
  end
end
