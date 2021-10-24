#==============================================================================
# ** Window_Battle_Commands
#------------------------------------------------------------------------------
#  This window displays a list of available battle commands
#==============================================================================

class Window_Battle_Commands < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of CLabel for every battle commands of an actor
  attr_reader :cBattleCommandsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current battle command
  #--------------------------------------------------------------------------
  # GET
  def selected_battle_command
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @column_max = 1
    @cBattleCommandsList = []
    window_update(actor)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    @data = []
    if actor != nil
      @actor = actor
      for battle_command in actor.battle_commands
        if battle_command != nil
          @data.push(battle_command)
        end
      end
      @item_max = @data.size
      create_contents()
      @cBattleCommandsList.clear()
      for i in 0..@item_max-1
        @cBattleCommandsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cBattleCommandsList.each() { |cBattleCommand| cBattleCommand.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(skill == nil ? "" : skill.description)
#~     else
      if selected_battle_command != nil
        @help_window.window_update(selected_battle_command.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_battle_command != nil
      @detail_window.window_update(selected_battle_command)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     battle_command : battle command
  #--------------------------------------------------------------------------
  def enable?(battle_command)
    return !@actor.is_command_equipped?(battle_command)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for BattleCommandsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    battle_command = @data[index]
    rect = item_rect(index, true)
    
    cBattleCommand = UCBattleCommand.new(self, battle_command, rect)
    cBattleCommand.active = enable?(battle_command)
  
    return cBattleCommand
  end
  private :create_item
  
end
