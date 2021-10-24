#===============================================================================
# ** Window_AutoBattle_Command
#------------------------------------------------------------------------------
#  This window displays 
#===============================================================================

class Window_AutoBattle_Command < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # CLabel for the 
  attr_reader :cAutoBattleTitle
  # CLabel for the 
  attr_reader :cCommandControl
    
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)

    @cAutoBattleTitle = CLabel.new(self, Rect.new(0,0,width-32,WLH), 
                                   Vocab::autobattle_title_label, 0,
                                   Font.autobattle_header_font)
                        
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      command = actor.autobattle_command
      rect = Rect.new(0,WLH,width-32,WLH)
      
      @cCommandControl = create_item(command, actor, rect)
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cAutoBattleTitle.draw()
    @cCommandControl.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item
  #     command : 
  #     actor :
  #     rect :
  #--------------------------------------------------------------------------
  def create_item(command, actor, rect)
    if command.is_a?(Item_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_use?(command.item)
    elsif command.is_a?(Skill_Command) && !command.is_custom
      control = UCSkill.new(self, command.skill, rect, actor.calc_mp_cost(command.skill))
      control.active = actor.skill_can_use?(command.skill)
    else
      control = CLabel.new(self, rect, command == nil ? "" : command.name)
      control.cut_overflow = true
    end

    return control
  end
  private :create_item
  
end
