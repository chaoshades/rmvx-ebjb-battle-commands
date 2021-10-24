#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #     menu_index : menu index
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0, menu_index = nil)
    @actor_index = actor_index
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background()
    if BATTLECOMMANDS_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(BATTLECOMMANDS_CONFIG::IMAGE_BG)
      @bg.opacity = BATTLECOMMANDS_CONFIG::IMAGE_BG_OPACITY
    end
    
    @actor = $game_party.members[@actor_index]
    
    @actor_battle_commands_backup = @actor.active_battle_commands.clone
    @actor_autobattle_command_backup = @actor.autobattle_command
    
    @char_image_window = Window_Char_Image.new(-16, 56+16, 640, 424, @actor)
    @char_image_window.opacity = 0
    @char_info_window = Window_Char_Info.new(0, 0, 200, 128, @actor)
    @char_info_window.ucExp.visible = false
    @char_info_window.ucExpGauge.visible = false
    @char_info_window.ucTotalExp.visible = false
    @char_info_window.refresh()

    @actor_commands_window = Window_ActorCommand.new()
    @actor_commands_window.x = 200
    @actor_commands_window.y = 40
    @actor_commands_window.width = 200
    @actor_commands_window.setup(@actor)
    @actor_commands_window.index = -1
    @actor_commands_window.active = false
    
    @autobattle_window = Window_AutoBattle_Command.new(420, 40-16, 220, 96, @actor)
    @autobattle_window.active = false
    @autobattle_window.opacity = 0
    
    @battle_commands_window = Window_Battle_Commands.new(200, 208, 200, 176, @actor)
    @battle_commands_window.active = false
    @battle_commands_window.index = -1
    
    @item_command_window = Window_Item_Command.new(640, 208, 440, 176)
    @item_command_window.active = false
    @item_command_window.visible = false
    @item_command_window.index = -1

    @skill_command_window = Window_Skill_Command.new(640, 208, 440, 176)
    @skill_command_window.active = false
    @skill_command_window.visible = false
    @skill_command_window.index = -1
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    @actor_commands_window.help_window = @help_window
    @battle_commands_window.help_window = @help_window
    @skill_command_window.help_window = @help_window
    @item_command_window.help_window = @help_window
    
    @item_details_window = Window_ItemDetails.new(0,384,640,96,nil)
    @item_details_window.visible = false
    @item_command_window.detail_window = @item_details_window
    
    @skill_details_window = Window_SkillDetails.new(0,384,640,96,nil)
    @skill_details_window.visible = false
    @skill_command_window.detail_window = @skill_details_window
    
    @command_window = Window_Command.new(200, 
                                         [Vocab::battle_commands_change_command, 
                                          Vocab::battle_commands_revert_command,
                                          Vocab::battle_commands_default_command,
                                          Vocab::battle_commands_change_autobattle_command], 2)
    @command_window.opacity = 0
    @command_window.x = 0
    @command_window.y = 48
    @command_window.active = true
    
    [@actor_commands_window, @char_info_window, @item_command_window,
     @skill_command_window, @battle_commands_window].each{
      |w| w.opacity = BATTLESYSTEM_CONFIG::WINDOW_OPACITY;
          w.back_opacity = BATTLESYSTEM_CONFIG::WINDOW_BACK_OPACITY
    }
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @char_image_window.dispose if @char_image_window != nil
    @char_info_window.dispose if @char_info_window != nil
    @actor_commands_window.dispose if @actor_commands_window != nil
    @battle_commands_window.dispose if @battle_commands_window != nil
    @autobattle_window.dispose if @autobattle_window != nil
    @item_command_window.dispose if @item_command_window != nil
    @skill_command_window.dispose if @skill_command_window != nil
    @item_details_window.dispose if @item_details_window != nil
    @skill_details_window.dispose if @skill_details_window != nil
    @help_window.dispose if @help_window != nil
    @command_window.dispose if @command_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    update_window_movement
    @char_image_window.update
    @char_info_window.update
    @help_window.update
    @command_window.update
    @actor_commands_window.update
    @battle_commands_window.update
    @autobattle_window.update
    @item_command_window.update
    @skill_command_window.update
    @item_details_window.update
    @skill_details_window.update
    if @command_window.active
      update_command_selection
    elsif @actor_commands_window.active
      update_actor_command_selection
    elsif @battle_commands_window.active
      update_battle_command_selection
    elsif @item_command_window.active
      update_item_command_selection
    elsif @skill_command_window.active
      update_skill_command_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update window movement
  #--------------------------------------------------------------------------
  def update_window_movement()
    # Battle command window position
    if @battle_commands_window.active
      if @battle_commands_window.x < 200
        @battle_commands_window.x += 20
      end
    elsif @skill_command_window.active || @item_command_window.active
      if @battle_commands_window.x > 0
        @battle_commands_window.x -= 20
      end
    end
    
    # Skill window position
    if @skill_command_window.active
      @skill_command_window.visible = true
      if @skill_command_window.x > 200
        @skill_command_window.x -= 40
      end
    else
      if @skill_command_window.x < 640
        @skill_command_window.x += 40
      else
        @skill_command_window.visible = false
      end
    end
      
    # Item window position
    if @item_command_window.active
      @item_command_window.visible = true
      if @item_command_window.x > 200
        @item_command_window.x -= 40
      end
    else
      if @item_command_window.x < 640
        @item_command_window.x += 40
      else
        @item_command_window.visible = false
      end
    end
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Detail window depending of the type of the drop item
  #     command : command object
  #-------------------------------------------------------------------------- 
  def update_detail_window(command)    
    if command.is_a?(Item_Command)
      @actor_commands_window.detail_window = @item_details_window
    else
      @actor_commands_window.detail_window = @skill_details_window
    end
  end
  private :update_detail_window
  
  #--------------------------------------------------------------------------
  # * Return scene
  #--------------------------------------------------------------------------
  def return_scene   
    if @menu_index != nil
      $scene = Scene_Menu.new(@menu_index)
    else
      $scene = Scene_Map.new
    end
  end
  private :return_scene
  
  #--------------------------------------------------------------------------
  # * Switch to Next Actor Screen
  #--------------------------------------------------------------------------
  def next_actor
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_BattleCommands.new(@actor_index, @menu_index)
  end
  private :next_actor
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor Screen
  #--------------------------------------------------------------------------
  def prev_actor
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_BattleCommands.new(@actor_index, @menu_index)
  end
  private :prev_actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      quit_command()
     
    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 0  # Change
        Sound.play_decision
        change_command()
      when 1  # Revert
        Sound.play_decision
        revert_command()
      when 2  # Default
        Sound.play_decision
        default_command()
      when 3  # Change Auto-Battle
        Sound.play_decision
        change_autobattle_command()
      end
    
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Actor Command Selection
  #--------------------------------------------------------------------------
  def update_actor_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
     
    elsif Input.trigger?(Input::C)
      Sound.play_decision
      do_battle_command()
      
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP)
      update_detail_window(@actor_commands_window.selected_command)
    end
  end
  private :update_actor_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Battle Command Selection
  #--------------------------------------------------------------------------
  def update_battle_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      if @autobattle_window.active
        cancel_autobattle_command()
      else
        cancel_battle_command()
      end
     
    elsif Input.trigger?(Input::C)
      if @battle_commands_window.selected_battle_command == nil ||
         (!@autobattle_window.active && !@battle_commands_window.enable?(@battle_commands_window.selected_battle_command)) ||
         (@autobattle_window.active && !@battle_commands_window.selected_battle_command.autobattle)
        Sound.play_buzzer
      else
        Sound.play_decision
        change_battle_command(@battle_commands_window.selected_battle_command)
      end
    
    elsif Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_SKILL
          skill_command()
        elsif @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_ITEM
          item_command()
        end
      end
    end
    
  end
  private :update_battle_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Item Command Selection
  #--------------------------------------------------------------------------
  def update_item_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_item_command()
      
    elsif Input.trigger?(Input::C)
      if @item_command_window.selected_item == nil ||
         (!@autobattle_window.active && !@item_command_window.enable?(@item_command_window.selected_item))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = $game_battle_commands.add_item_command(@item_command_window.selected_item)
        change_battle_command(command)
      end
    end
  end
  private :update_item_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Skill Command Selection
  #--------------------------------------------------------------------------
  def update_skill_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_skill_command()
      
    elsif Input.trigger?(Input::C)
      if @skill_command_window.selected_skill == nil ||
         (!@autobattle_window.active && !@skill_command_window.enable?(@skill_command_window.selected_skill))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = $game_battle_commands.add_skill_command(@skill_command_window.selected_skill)
        change_battle_command(command)
      end
    end
  end
  private :update_skill_command_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @actor_commands_window.active = false
    @actor_commands_window.index = -1
    #@autobattle_window.active = false
    #@item_details_window.window_update(nil)
    #@item_details_window.visible = false
    #@skill_details_window.window_update(nil)
    #@skill_details_window.visible = false
    @help_window.window_update("")
    #@help_window.visible = true
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    $game_battle_commands.clean_commands()
    return_scene
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Change command
  #--------------------------------------------------------------------------
  def change_command()
    @command_window.active = false
    @actor_commands_window.active = true
    @actor_commands_window.index = 0
  end
  private :change_command
  
  #--------------------------------------------------------------------------
  # * Revert command
  #--------------------------------------------------------------------------
  def revert_command()
    # Revert changes
    for i in 0 .. BATTLECOMMANDS_CONFIG::MAX_BATTLE_COMMANDS-1
      @actor.equip_battle_command(@actor_battle_commands_backup[i].id, i)
    end

    @actor.equip_autobattle_command(@actor_autobattle_command_backup.id)
    
    @actor_commands_window.window_update(@actor)
    @battle_commands_window.window_update(@actor)
    @autobattle_window.window_update(@actor)
  end
  private :revert_command
  
  #--------------------------------------------------------------------------
  # * Default command
  #--------------------------------------------------------------------------
  def default_command()
    # Revert changes
    for i in 0 .. BATTLECOMMANDS_CONFIG::MAX_BATTLE_COMMANDS-1
      @actor.equip_battle_command(BATTLECOMMANDS_CONFIG::DEFAULT_BATTLE_COMMANDS[i], i)
    end

    @actor.equip_autobattle_command(BATTLECOMMANDS_CONFIG::DEFAULT_AUTOBATTLE_COMMAND)
    
    @actor_commands_window.window_update(@actor)
    @battle_commands_window.window_update(@actor)
    @autobattle_window.window_update(@actor)
  end
  private :default_command
  
  #--------------------------------------------------------------------------
  # * Cancel Battle command
  #--------------------------------------------------------------------------
  def cancel_battle_command()
    @actor_commands_window.active = true
    @battle_commands_window.active = false
    @battle_commands_window.index = -1
    @actor_commands_window.call_update_help()
    update_detail_window(@actor_commands_window.selected_command)
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Cancel Auto-Battle command
  #--------------------------------------------------------------------------
  def cancel_autobattle_command()
    @command_window.active = true
    @help_window.window_update("")    
    @autobattle_window.active = false
    @battle_commands_window.active = false
    @battle_commands_window.index = -1
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Do battle command
  #--------------------------------------------------------------------------
  def do_battle_command()
    @actor_commands_window.active = false
    @battle_commands_window.active = true
    @battle_commands_window.index = 0
  end
  private :do_battle_command
  
  #--------------------------------------------------------------------------
  # * Change battle command
  #     command : New battle command
  #--------------------------------------------------------------------------
  def change_battle_command(command)
    index = @actor_commands_window.index

    if @autobattle_window.active
      @actor.equip_autobattle_command(command.id)
      @autobattle_window.window_update(@actor)
    else
      @actor.equip_battle_command(command.id, index)
      @actor_commands_window.window_update(@actor)
    end
    
    #cancel_battle_command()
    if @skill_command_window.active
      @skill_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    elsif @item_command_window.active
      @item_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    end
    
    @battle_commands_window.window_update(@actor)
    
  end
  private :change_battle_command
  
  #--------------------------------------------------------------------------
  # * Change Auto-Battle command
  #--------------------------------------------------------------------------
  def change_autobattle_command()
    @command_window.active = false
    @autobattle_window.active = true
    @battle_commands_window.active = true
    @battle_commands_window.index = 0
  end
  private :change_autobattle_command
  
  #--------------------------------------------------------------------------
  # * Skill command
  #--------------------------------------------------------------------------
  def skill_command()
    @battle_commands_window.active = false
    @skill_command_window.window_update(@actor, @battle_commands_window.selected_battle_command.filter)
    @skill_command_window.active = true
    @skill_command_window.index = 0
  end
  private :skill_command
  
  #--------------------------------------------------------------------------
  # * Cancel Skill command
  #--------------------------------------------------------------------------
  def cancel_skill_command()
    @battle_commands_window.active = true
    @skill_command_window.active = false
    @skill_command_window.index = -1
    @battle_commands_window.call_update_help()
    @skill_details_window.window_update(nil)
    @skill_details_window.visible = false
  end
  private :cancel_skill_command
  
  #--------------------------------------------------------------------------
  # * Item command
  #--------------------------------------------------------------------------
  def item_command()
    @battle_commands_window.active = false
    @item_command_window.window_update(@actor, $game_party.items, @battle_commands_window.selected_battle_command.filter)
    @item_command_window.active = true
    @item_command_window.index = 0
  end
  private :item_command
  
  #--------------------------------------------------------------------------
  # * Cancel Item command
  #--------------------------------------------------------------------------
  def cancel_item_command()
    @battle_commands_window.active = true
    @item_command_window.active = false
    @item_command_window.index = -1
    @battle_commands_window.call_update_help()
    @item_details_window.window_update(nil)
    @item_details_window.visible = false
  end
  private :cancel_item_command
  
end
