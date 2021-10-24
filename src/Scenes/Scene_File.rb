#==============================================================================
# ** Scene_File
#------------------------------------------------------------------------------
#  This class performs the save and load screen processing.
#==============================================================================

class Scene_File < Scene_Base

  #--------------------------------------------------------------------------
  # * Write Save Data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  alias write_save_data_ebjb write_save_data unless $@
  def write_save_data(file)
    write_save_data_ebjb(file)
    Marshal.dump($game_battle_commands,         file)
  end
  
  #--------------------------------------------------------------------------
  # * Read Save Data
  #     file : file object for reading (opened)
  #--------------------------------------------------------------------------
  alias read_save_data_ebjb read_save_data unless $@
  def read_save_data(file)
    read_save_data_ebjb(file)
    $game_battle_commands         = Marshal.load(file)
  end
  
end
