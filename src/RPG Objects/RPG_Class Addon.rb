#===============================================================================
# ** RPG::Class Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Class
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get battle commands learnings of the class
  #--------------------------------------------------------------------------
  # GET
  def battle_commands_learnings
    return BATTLECOMMANDS_CONFIG::CLASS_BATTLE_COMMANDS_LEARNINGS[self.id]
  end
  
end
