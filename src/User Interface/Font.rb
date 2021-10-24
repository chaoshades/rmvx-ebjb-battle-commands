#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  Contains the different fonts
#==============================================================================

class Font
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Item Details Stats Font
  #--------------------------------------------------------------------------
  def self.item_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Plus States Font
  #--------------------------------------------------------------------------
  def self.item_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Minus States Font
  #--------------------------------------------------------------------------
  def self.item_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details HP/MP Font
  #--------------------------------------------------------------------------
  def self.skill_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Plus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Minus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get AutoBattle Header Font
  #--------------------------------------------------------------------------
  def self.autobattle_header_font
    f = Font.new()
    f.color = Color.system_color
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get List Command Arrow Font
  #--------------------------------------------------------------------------
  def self.list_command_arrow
    f = Font.new()
    f.size = 16
    return f
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Get Chain Percentage Font
#~   #--------------------------------------------------------------------------
#~   def self.chain_percentage_font
#~     f = Font.new()
#~     f.bold = true
#~     f.italic = true
#~     return f
#~   end
  
end
