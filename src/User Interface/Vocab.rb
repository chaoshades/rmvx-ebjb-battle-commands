#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Label
  #--------------------------------------------------------------------------
  def self.hp_label
    return self.hp
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Label
  #--------------------------------------------------------------------------
  def self.mp_label
    return self.mp
  end
  
  #--------------------------------------------------------------------------
  # * Get EXP Label
  #--------------------------------------------------------------------------
  def self.exp_label
    return "EXP"
  end
  
  #--------------------------------------------------------------------------
  # * Get Level Label
  #--------------------------------------------------------------------------
  def self.lvl_label
    return self.level
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Elements list
  #--------------------------------------------------------------------------
  def self.elements_label
    return "ELEMENTS"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the States list
  #--------------------------------------------------------------------------
  def self.states_label
    return "STATES"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Recovery effect
  #--------------------------------------------------------------------------
  def self.recovery_label
    return "RECOVERY"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Damage effect
  #--------------------------------------------------------------------------
  def self.damage_label
    return "DAMAGE"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Scope list
  #--------------------------------------------------------------------------
  def self.scopes_label
    return "DAMAGE"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Window Char Info related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show Total Exp.
  #--------------------------------------------------------------------------
  def self.char_info_total_exp_label
    return "TOTAL"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Battle Commands related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every battle command (name + description)
  #--------------------------------------------------------------------------
  def self.battle_commands_strings
    return {
     BATTLECOMMANDS_CONFIG::BC_ATTACK => [self.attack, "Attacks the target(s)"],
     BATTLECOMMANDS_CONFIG::BC_SKILL => [self.skill, "Uses a skill"],
     BATTLECOMMANDS_CONFIG::BC_GUARD => [self.guard, "Guards yourself from damage"],
     BATTLECOMMANDS_CONFIG::BC_ITEM => [self.item, "Uses an item"]
    }
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show Auto-Battle Command
  #--------------------------------------------------------------------------
  def self.autobattle_title_label
    return "Auto-Battle Command"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Menu related
  #//////////////////////////////////////////////////////////////////////////
    
  #--------------------------------------------------------------------------
  # * Get Title to show in the menu for the Battle Commands Change Scene
  #--------------------------------------------------------------------------
  def self.battle_commands_menu_title
    return "Battle Commands"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Battle Commands related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Change command
  #--------------------------------------------------------------------------
  def self.battle_commands_change_command
    return "Change"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Revert command
  #--------------------------------------------------------------------------
  def self.battle_commands_revert_command
    return "Revert"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Default command
  #--------------------------------------------------------------------------
  def self.battle_commands_default_command
    return "Default"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Change Auto-Battle command
  #--------------------------------------------------------------------------
  def self.battle_commands_change_autobattle_command
    return "Ch. Auto"
  end
  
end
