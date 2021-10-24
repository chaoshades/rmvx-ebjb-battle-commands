#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def [](command_id)
    if @data[command_id] == nil and $data_battle_commands[command_id] != nil
      @data[command_id] = $data_battle_commands[command_id].clone
    end
    return @data[command_id]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     item : item object
  #--------------------------------------------------------------------------
  def add_item_command(item)
    id = Utilities.generate_battle_command_uid("BC_ITEM_"+item.id.to_s)
    if (!@data.include?(id))
      @data[id] = Item_Command.new(id, item.id)
    end
    return @data[id]
  end
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     skill : skill object
  #--------------------------------------------------------------------------
  def add_skill_command(skill)
    id = Utilities.generate_battle_command_uid("BC_SKILL_"+skill.id.to_s)
    if (!@data.include?(id))
      @data[id] = Skill_Command.new(id, skill.id)
    end
    return @data[id]
  end
  
  #--------------------------------------------------------------------------
  # * Remove the battle commands that are not used anymore (to save memory)
  #--------------------------------------------------------------------------
  def clean_commands
    for command in @data.values
      # Commands from data are always kept
      if !$data_battle_commands.include?(command.id)
        remove = true
        # Checks if the command is still in use
        for i in 1...$game_actors.size
          if $game_actors[i].is_command_equipped?(command)
            remove = false
          end
        end
        if remove 
          @data.delete(command.id)
        end
      end
    end
  end
  
end
