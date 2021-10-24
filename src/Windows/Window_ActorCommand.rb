#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is used to select actor commands, such as "Attack" or "Skill".
#==============================================================================

class Window_ActorCommand < Window_Command
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of CLabel, UCItem or UCSkill for every battle command of a character
  attr_reader :ucCommandsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current command
  #--------------------------------------------------------------------------
  # GET
  def selected_command
    return (self.index < 0 ? nil : @commands[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @ucCommandsList = []
    super(128, [], 1, BATTLECOMMANDS_CONFIG::MAX_BATTLE_COMMANDS)
    self.active = false
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Setup
  #     actor : actor
  #--------------------------------------------------------------------------
  def setup(actor)
#~     s1 = Vocab::attack
#~     s2 = Vocab::skill
#~     s3 = Vocab::guard
#~     s4 = Vocab::item
#~     if actor.class.skill_name_valid     # Skill command name is valid?
#~       s2 = actor.class.skill_name       # Replace command name
#~     end
#~     @commands = actor.active_battle_commands
#~     @item_max = @commands.size
    window_update(actor)
    self.index = 0
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    @commands = []    
    if actor != nil
      @actor = actor
      for battle_command in actor.active_battle_commands
        if battle_command != nil
          @commands.push(battle_command)
        end
      end

      if !$game_temp.in_battle
        for i in @commands.size .. BATTLECOMMANDS_CONFIG::MAX_BATTLE_COMMANDS-1
          @commands.push(nil)
        end
      end

      @item_max = @commands.size
      create_contents()
      @ucCommandsList.clear()
      for i in 0..@item_max-1
        @ucCommandsList.push(create_item(i))
      end
    end

    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCommandsList.each() { |ucCommand| ucCommand.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(@commands[self.index] == nil ? "" : @commands[self.index].description)
    else
      if selected_command != nil
        @help_window.window_update(selected_command.description)
      else
        @help_window.window_update("")
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_command != nil
      if selected_command.is_a?(Item_Command)
        @detail_window.window_update(selected_command.item)
      elsif selected_command.is_a?(Skill_Command)
        @detail_window.window_update(selected_command.skill)
      else
        @detail_window.window_update(nil)
      end
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_command != nil && 
           ((selected_command.is_a?(Item_Command) && detail_window.is_a?(Window_ItemDetails)) ||
           (selected_command.is_a?(Skill_Command) && detail_window.is_a?(Window_SkillDetails)))
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for CommandsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    command = @commands[index]
    rect = item_rect(index, true)

    if command.is_a?(Item_Command)
      control = UCItem.new(self, command.item, rect)
      control.active = $game_party.item_can_use?(command.item)
    elsif command.is_a?(Skill_Command) && !command.is_custom
      control = UCSkill.new(self, command.skill, rect, @actor.calc_mp_cost(command.skill))
      control.active = @actor.skill_can_use?(command.skill)
    else
      control = CLabel.new(self, rect, command == nil ? "" : command.name)
      control.cut_overflow = true
    end

    return control
  end
  private :create_item
  
#~   #--------------------------------------------------------------------------
#~   # * Draw Item
#~   #     index   : item number
#~   #     enabled : enabled flag. When false, draw semi-transparently.
#~   #--------------------------------------------------------------------------
#~   def draw_item(index, enabled = true)
#~     rect = item_rect(index)
#~     rect.x += 4
#~     rect.width -= 8
#~     self.contents.clear_rect(rect)
#~     self.contents.font.color = normal_color
#~     self.contents.font.color.alpha = enabled ? 255 : 128
#~     self.contents.draw_text(rect, @commands[index] == nil ? "" : @commands[index].name)
#~   end
  
end
