#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================

class Scene_Title < Scene_Base
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Alias load_database
  #--------------------------------------------------------------------------
  alias load_database_ebjb_bc load_database unless $@
  def load_database
    load_database_ebjb_bc
    $data_battle_commands = {}
    for bc in BATTLECOMMANDS_CONFIG::DATA_BATTLE_COMMANDS
      $data_battle_commands[bc.id] = bc
    end
  end
  
  #--------------------------------------------------------------------------
  # * alias load_bt_database
  #--------------------------------------------------------------------------
  alias load_bt_database_ebjb_bc load_bt_database unless $@
  def load_bt_database
    load_bt_database_ebjb_bc
    $data_battle_commands = {}
    for bc in BATTLECOMMANDS_CONFIG::DATA_BATTLE_COMMANDS
      $data_battle_commands[bc.id] = bc
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias create_game_objects
  #--------------------------------------------------------------------------
  alias create_game_objects_ebjb create_game_objects unless $@
  def create_game_objects
    create_game_objects_ebjb
    $game_battle_commands        = Game_Battle_Commands.new
  end
  
end
