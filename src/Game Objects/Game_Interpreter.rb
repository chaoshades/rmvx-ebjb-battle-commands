#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # * Alias command_121 - Control Switches
  #--------------------------------------------------------------------------
  alias command_121_ebjb command_121 unless $@
  def command_121
    result = command_121_ebjb
    
    # Refresh the battle commands list if the switch activates one
    for i in 1...$game_actors.size
      $game_actors[i].refresh_battle_commands_learnings
    end
    return result
  end
  
end
