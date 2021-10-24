#==============================================================================
# ** UCBattleCommand
#------------------------------------------------------------------------------
#  Represents a battle command on a window
#==============================================================================

class UCBattleCommand < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the item name
  attr_reader :cCommandName
  # Label for an arrow-like for List_Command
  attr_reader :cArrow
  # Battle_Command object
  attr_reader :battle_command
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cCommandName.visible = visible
    @cArrow.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cCommandName.active = active
    @cArrow.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     battle_command : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, battle_command, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @battle_command = battle_command
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @cCommandName = CLabel.new(window, rects[0], battle_command.name)
    @cCommandName.active = active
    @cCommandName.visible = visible
    @cCommandName.cut_overflow = true
    
    @cArrow = CLabel.new(window, rects[1], BATTLECOMMANDS_CONFIG::LIST_COMMAND_ARROW, 
                         2, Font.list_command_arrow)
    @cArrow.active = active
    @cArrow.visible = battle_command.is_a?(List_Command)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @cCommandName.draw()
    @cArrow.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,24,rect.height)
    
    # Rects Adjustments
    
    # cCommandName
    # Nothing to do
    
    # cArrow
    rects[1].x += rect.width - rects[1].width
    
    return rects
  end
  private :determine_rects
  
end
