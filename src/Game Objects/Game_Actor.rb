#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of battle commands that are active
  #attr_accessor :active_battle_commands
  # Array of available battle commands for the actor
  #attr_reader :battle_commands
  # Command used for autobattle
  #attr_accessor :autobattle_command
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Get Now Exp - The experience gained for the current level.
  #--------------------------------------------------------------------------
  # GET
  def now_exp
    return @exp - @exp_list[@level]
  end
  
  #--------------------------------------------------------------------------
  # Get Next Exp - The experience needed for the next level.
  #--------------------------------------------------------------------------
  # GET
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
  
  #--------------------------------------------------------------------------
  # * Get Battle Commands Object Array
  #--------------------------------------------------------------------------
  # GET
  def battle_commands
    result = []
    for i in @battle_commands
      result.push($game_battle_commands[i])
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Get Active Battle Commands Object Array
  #--------------------------------------------------------------------------
  # GET
  def active_battle_commands
    result = []
    for i in @active_battle_commands
      if i != nil
        result.push($game_battle_commands[i])
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Get Autobattle Command Object
  #--------------------------------------------------------------------------
  # GET
  def autobattle_command
    return $game_battle_commands[@autobattle_command]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias setup_ebjb_2 setup unless $@
  def setup(actor_id)
    setup_ebjb_2(actor_id)
    actor = $data_actors[actor_id]
    @autobattle_command = BATTLECOMMANDS_CONFIG::DEFAULT_AUTOBATTLE_COMMAND
    @battle_commands = []
    @active_battle_commands = []
    for command_id in actor.battle_commands
      @active_battle_commands.push(command_id)
      learn_battle_command(command_id)
    end
    
    refresh_battle_commands_learnings()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Check if actor has a specific battle command
  #     obj : Item, Skill or Battle Command object
  #--------------------------------------------------------------------------
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Item))
      return active_battle_commands.any?{|c| c.is_a?(Item_Command) && c.item_id == obj.id} 
    elsif (obj.is_a?(RPG::Skill))
      return active_battle_commands.any?{|c| c.is_a?(Skill_Command) && c.skill_id == obj.id} 
    elsif (obj.is_a?(Battle_Command))
      return active_battle_commands.include?(obj)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_autobattle_action
    @action.clear
    return unless movable?
    action = Game_BattleAction.new(self)
    
    command = self.autobattle_command
    if command.is_a?(Skill_Command)
      if command.is_custom
        action.forcing = true
      end
      if self.skill_can_use?(command.skill) || command.is_custom
        action.set_skill(command.skill.id)
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        action.set_item(command.item.id)
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        action.set_attack
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        action.set_guard
      end
    end
    
    action.evaluate
    
    #Keeps action if it has been evaluated, else don't do anything
    if action.value > 0
      @action = action
    end
  end
  
  #--------------------------------------------------------------------------
  # * Equip Auto Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def equip_autobattle_command(command_id)
    @autobattle_command = command_id
  end
  
  #--------------------------------------------------------------------------
  # * Equip Battle Command
  #     command_id : battle command ID
  #     index : index of the battle command position
  #--------------------------------------------------------------------------
  def equip_battle_command(command_id, index)
    @active_battle_commands[index] = command_id
  end
  
  #--------------------------------------------------------------------------
  # * Learn Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def learn_battle_command(command_id)
    unless battle_command_learn?($game_battle_commands[command_id])
      @battle_commands.push(command_id)
      #@battle_commands.sort!
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Battle Command
  #     command : Battle Command object
  #--------------------------------------------------------------------------
  def battle_command_learn?(command)
    return @battle_commands.include?(command.id)
  end
  
  #--------------------------------------------------------------------------
  # * Determine Usable Battle Commands
  #     command : Battle Command object
  #--------------------------------------------------------------------------
  def battle_command_can_use?(command)
    return false unless battle_command_learn?(command)
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias level_up_ebjb level_up unless $@
  def level_up
    level_up_ebjb
    refresh_battle_commands_learnings()
  end
  
  #--------------------------------------------------------------------------
  # * Level Down
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
  
  #--------------------------------------------------------------------------
  # * Forget Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def forget_battle_command(command_id)
    @battle_commands.delete(command_id)
  end
  
  #--------------------------------------------------------------------------
  # * Refresh Battle Commands from learnings
  #--------------------------------------------------------------------------  
  def refresh_battle_commands_learnings
    for learning in self.class.battle_commands_learnings
      learn_battle_command(learning.command_id) if learning.can_learn?(@level)
    end
  end
  
end
