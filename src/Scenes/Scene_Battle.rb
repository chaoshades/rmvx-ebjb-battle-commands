#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_ebjb start unless $@
  def start
    start_ebjb
    
    @actor_command_window.width = 200
    @actor_command_window.x = -200
    
    @autobattle = false
  end
  
  #--------------------------------------------------------------------------
  # * Update window movement
  #--------------------------------------------------------------------------
  def update_window_movement()
    # Actor command window position
    if @actor_command_window.active
      @actor_command_window.visible = true
      if @actor_command_window.x < 0
        @actor_command_window.x += 20
      end
    else
      if @actor_command_window.x > -200
        @actor_command_window.x -= 20
      else
        @actor_command_window.visible = false
      end
    end
    
    # Skill window position
    if @skill_window.active
      @skill_window.visible = true
      if @skill_window.y > 288+16
        @skill_window.y -= 16
      end
    else
      if @skill_window.y < 480
        @skill_window.y += 16
      else
        @skill_window.visible = false
      end
    end
      
    # Item window position
    if @item_window.active
      @item_window.visible = true
      if @item_window.y > 288+16
        @item_window.y -= 16
      end
    else
      if @item_window.y < 480
        @item_window.y += 16
      else
        @item_window.visible = false
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_auto_action
  #--------------------------------------------------------------------------
  alias make_auto_action_ebjb make_auto_action unless $@
  def make_auto_action(battler)
    action_made = make_auto_action_ebjb(battler)
    if !action_made && @autobattle
      battler.make_autobattle_action
      battler.battle_animation.do_ani_stand unless battler.battle_animation.is_running?
      return true
    end
    return action_made
  end
  
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_input
  #--------------------------------------------------------------------------
  alias update_actor_command_input_ebjb update_actor_command_input unless $@
  def update_actor_command_input
    update_autobattle_input
    update_actor_command_input_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Update Battle Help Input
  #--------------------------------------------------------------------------
  def update_autobattle_input
    if Input.trigger?(BATTLECOMMANDS_CONFIG::AUTOBATTLE_INPUT)
      @autobattle = !@autobattle
      if @autobattle
        end_actor_command_selection()
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_selection
  #--------------------------------------------------------------------------
  alias update_actor_command_selection_ebjb update_actor_command_selection unless $@
  def update_actor_command_selection
    actor = $game_party.members[@actor_index]
    
    # Forces refresh to disable/enable particular commands (ex.: skill or partners)
    @actor_command_window.window_update(actor)
    
    update_actor_command_selection_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Execute battle commands
  #     actor : Actor object
  #--------------------------------------------------------------------------
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.is_a?(List_Command)
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_SKILL
        Sound.play_decision
        @skill_window.filter = command.filter
        start_skill_selection(actor)  
      when BATTLECOMMANDS_CONFIG::BC_ITEM
        Sound.play_decision
        @item_window.filter = command.filter
        start_item_selection
      end
    elsif command.is_a?(Skill_Command)
      if command.is_custom
        actor.action.forcing = true
      end
      if actor.skill_can_use?(command.skill) || command.is_custom
        Sound.play_decision
        @actor_command_window.active = false
        determine_skill(command.skill)
      else
        Sound.play_buzzer
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        Sound.play_decision
        @actor_command_window.active = false
        determine_item(command.item)
      else
        Sound.play_buzzer
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        Sound.play_decision
        actor.action.set_attack
        start_target_enemy_selection
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        Sound.play_decision
        actor.action.set_guard
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_multi execute_action unless $@
  def execute_action
    if @active_battler.multi_actions? 
      for action in @active_battler.multi_actions
        @active_battler.action = action
        execute_action_bc_multi
      end

      @active_battler.clear_multi_actions
      @active_battler.action.clear
    else
      execute_action_bc_multi
    end
  end
  
end
