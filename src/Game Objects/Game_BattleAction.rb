#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Action Value Evaluation (for automatic battle)
  #    @value and @target_index are automatically set.
  #--------------------------------------------------------------------------
  def evaluate
    if attack?
      evaluate_attack
    elsif skill?
      evaluate_skill
    elsif item?
      evaluate_item
    else
      @value = 0
    end
    if @value > 0
      @value + rand(nil)
    end
  end

  #--------------------------------------------------------------------------
  # * Item Evaluation
  #--------------------------------------------------------------------------
  def evaluate_item
    @value = 0
    unless $game_party.item_can_use?(item)
      return
    end
    if item.for_opponent?
      targets = opponents_unit.existing_members
    elsif item.for_user?
      targets = [battler]
    elsif item.for_dead_friend?
      targets = friends_unit.dead_members
    else
      targets = friends_unit.existing_members
    end
    for target in targets
      value = evaluate_item_with_target(target)
      if item.for_all?
        @value += value
      elsif value > @value
        @value = value
        @target_index = target.index
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Item Evaluation (target designation)
  #     target : Target battler
  #--------------------------------------------------------------------------
  def evaluate_item_with_target(target)
    target.clear_action_results
    target.make_obj_damage_value(battler, item)
    if item.for_opponent?
      return target.hp_damage.to_f / [target.hp, 1].max
    else
      recovery = [-target.hp_damage, target.maxhp - target.hp].min
      return recovery.to_f / target.maxhp
    end
  end
  
end
