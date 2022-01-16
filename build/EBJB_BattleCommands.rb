################################################################################
#             EBJB Custom Battle Commands - EBJB_BattleCommands       #   VX   #
#                          Last Update: 2012/05/22                    ##########
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Description of the script                                                   #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the BattleCommands_Config      #
#  class. For more info on what and how to adjust these settings, see the      #
#  documentation  in the class.                                                #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Works With: Script Names, ...                                               #
#  Alias: Class - method, ...                                                  #
#  Overwrites: Class - method, ...                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_BattleCommands"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module Utilities
    #------------------------------------------------------------------------
    # * 
    #------------------------------------------------------------------------
    def self.generate_battle_command_uid(var)
#~       if @unique_id_array == nil
#~         @unique_id_array = []
#~       end
#~       if @unique_id_array.include?(var)
#~         print sprintf("[Constant '%s' already exists]", var)
#~         uid = 1000 + @unique_id_array.index(var)+1
#~       else
#~         @unique_id_array.push(var)
#~         uid = 1000 + @unique_id_array.length
#~       end
      uid = 0
      var.each_byte do |c|
        uid += c
      end
      
      return uid
    end
  end
  
  #==============================================================================
  # ** LearningBattleCommand
  #------------------------------------------------------------------------------
  #  Data class for a [Class's Learned] battle commands.
  #==============================================================================

  class LearningBattleCommand
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
   
    # Level to reach to learn the battle command
    attr_reader :level
    # Battle command id
    attr_reader :command_id
    # Switch ID to activate to learn the battle command
    attr_reader :switch_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     command_id : 
    #     level :
    #     switch_id :
    #--------------------------------------------------------------------------
    def initialize(command_id, level=nil, switch_id=nil)
      @command_id = command_id
      @level = level
      @switch_id = switch_id
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Public Methods
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     level :
    #--------------------------------------------------------------------------
    def can_learn?(level)
      return (
          (@level == nil && @switch_id == nil) ||
          (@switch_id == nil && @level <= level) ||
          (@level == nil && $game_switches[@switch_id] == true) ||
          (@level <= level && $game_switches[@switch_id] == true)
      )
    end
    
  end
  
  #==============================================================================
  # ** Battle_Command
  #------------------------------------------------------------------------------
  #  Represents a battle command
  #==============================================================================

  class Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
   
    # Battle command id
    attr_reader :id
    # Type of the battle command
    attr_reader :type
#~     # Name of the mode
#~     attr_reader :name
#~     # Description of the mode
#~     attr_reader :description
    #
    attr_reader :autobattle
    #
    attr_reader :multiple

    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the name of the battle command
    #--------------------------------------------------------------------------
    def name()
      return Vocab::battle_commands_strings[@id][0]
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the battle command
    #--------------------------------------------------------------------------
    def description()
      return Vocab::battle_commands_strings[@id][1]
    end
    
    #--------------------------------------------------------------------------
    # * 
    #--------------------------------------------------------------------------
    def multiple?()
      return @multiple > 1
    end
    
#~     #--------------------------------------------------------------------------
#~     # * Get if the battle command is enabled
#~     #--------------------------------------------------------------------------
#~     def enabled?()
#~       # enabled by default
#~       enabled = true
#~       if @switch_id != nil
#~         enabled = $game_switches[@switch_id] == true
#~       end
#~       return enabled
#~     end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     type :
    #     switch_id : 
    #     multiple :
    #     autobattle :
    #--------------------------------------------------------------------------
    def initialize(id, type, switch_id=nil, autobattle=true, multiple=1)
      @id = id
      @type = type
      @switch_id = switch_id
      @autobattle = autobattle
      @multiple = multiple
#~       @name = name
#~       @description = description
    end
    
#~     #//////////////////////////////////////////////////////////////////////////
#~     # * Public Methods
#~     #//////////////////////////////////////////////////////////////////////////
#~     
#~     #--------------------------------------------------------------------------
#~     # * Check if current object is the same as a specific battle command
#~     #     battle_command : battle command
#~     #--------------------------------------------------------------------------
#~     def is_same?(battle_command)
#~       return false unless @type == battle_command.type
#~       return true
#~     end

  end
  
  #==============================================================================
  # ** Skill_Command
  #------------------------------------------------------------------------------
  #  Represents a skill battle command
  #==============================================================================

  class Skill_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Skill ID
    attr_reader :skill_id
    # Allows the Skill Command to act as a custom skill command
    # (ex.: doesn't need to have the skill to use it, doesn't show MP or icon)
    attr_reader :is_custom
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the skill object of the skill battle command
    #--------------------------------------------------------------------------
    def skill()
      return $data_skills[@skill_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the skill battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_skills[@skill_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the skill battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_skills[@skill_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : command id
    #     skill_id : Skill ID to get name and description of the battle command
    #     is_custom :
    #--------------------------------------------------------------------------
    def initialize(id, skill_id, is_custom=false)
      super(id, BATTLECOMMANDS_CONFIG::BC_SKILL)
      @skill_id = skill_id
      @is_custom = is_custom
    end
    
#~     #//////////////////////////////////////////////////////////////////////////
#~     # * Public Methods
#~     #//////////////////////////////////////////////////////////////////////////
#~     
#~     #--------------------------------------------------------------------------
#~     # * Check if current object is the same as a specific battle command
#~     #     battle_command : battle command
#~     #--------------------------------------------------------------------------
#~     def is_same?(battle_command)
#~       return false unless battle_command.is_a?(Skill_Command)
#~       return false unless self.skill.id == battle_command.skill.id
#~       return super
#~     end
    
  end
  
  #==============================================================================
  # ** Item_Command
  #------------------------------------------------------------------------------
  #  Represents a item battle command
  #==============================================================================

  class Item_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Item ID
    attr_reader :item_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the item object of the item battle command
    #--------------------------------------------------------------------------
    def item()
      return $data_items[@item_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the item battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_items[@item_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the item battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_items[@item_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     item_id : Item ID to get name and description of the battle command
    #     type :
    #--------------------------------------------------------------------------
    def initialize(id, item_id)
      super(id, BATTLECOMMANDS_CONFIG::BC_ITEM)
      @item_id = item_id
    end
    
#~     #//////////////////////////////////////////////////////////////////////////
#~     # * Public Methods
#~     #//////////////////////////////////////////////////////////////////////////
#~     
#~     #--------------------------------------------------------------------------
#~     # * Check if current object is the same as a specific battle command
#~     #     battle_command : battle command
#~     #--------------------------------------------------------------------------
#~     def is_same?(battle_command)
#~       return false unless battle_command.is_a?(Item_Command)
#~       return false unless self.item.id == battle_command.item.id
#~       return super
#~     end
    
  end
  
  #==============================================================================
  # ** List_Command
  #------------------------------------------------------------------------------
  #  Represents a list battle command
  #==============================================================================

  class List_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Filter to use for the list battle command
    attr_reader :filter
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     type :
    #     filter :
    #--------------------------------------------------------------------------
    def initialize(id, type, filter=nil, multiple=1)
      super(id, type, nil, false, multiple)
      @filter = filter
    end
    
#~     #//////////////////////////////////////////////////////////////////////////
#~     # * Public Methods
#~     #//////////////////////////////////////////////////////////////////////////
#~     
#~     #--------------------------------------------------------------------------
#~     # * Check if current object is the same as a specific battle command
#~     #     battle_command : battle command
#~     #--------------------------------------------------------------------------
#~     def is_same?(battle_command)
#~       return false unless battle_command.is_a?(List_Command)
#~       return false unless @filter == battle_command.filter
#~       return super
#~     end
    
  end
  
  #==============================================================================
  # ** Actor_Body_Image
  #------------------------------------------------------------------------------
  #  Represents an actor's body image
  #==============================================================================

  class Actor_Body_Image
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Filename containing the actor's body image
    attr_reader :filename
    # Rectangle of the image to get in the file
    attr_reader :src_rect
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     filename : filename containing the actor's body image
    #     src_rect : rectangle of the image to get in the file
    #--------------------------------------------------------------------------
    def initialize(filename, src_rect)
      @filename = filename
      @src_rect = src_rect
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG
    
    # Background image filename, it must be in folder Pictures
    IMAGE_BG = ""
    # Opacity for background image
    IMAGE_BG_OPACITY = 255
    # All windows opacity
    WINDOW_OPACITY = 255
    WINDOW_BACK_OPACITY = 200
    
    # Icons used for the Elemental Resistance Graph and the Elements icons list
    #0 = None           5 = Bow   (no)    10 = Ice    (105) 15 = Holy     (110) 
    #1 = Melee    (no)  6 = Whip  (no)    11 = Thunder(106) 16 = Darkness (111)
    #2 = Percing  (no)  7 = Mind  (no)    12 = Water  (107)
    #3 = Slashing (no)  8 = Absorb (no)   13 = Earth  (108)  
    #4 = Blow  (no)     9 = Fire   (104)  14 = Wind   (109)   
    ELEMENT_ICONS = [0,0,0,0,0,0,0,0,0,104,105,106,107,108,109,110,111]
    
    # Icons used for the Scope stat in the Scope icons list
    #0 = None                  4 = One Random Enemy  (129)  8 = All Allies  (130)  
    #1 = One Enemy   (157)     5 = 2 Random Enemies  (129)  9 = One Dead Ally (112)
    #2 = All Enemies (135)     6 = 3 Random Enemies  (129)  10 = All Dead Allies (112)
    #3 = One Enemy Dual (157)  7 = One Ally          (130)   11 = The User (159)
    SCOPE_ICONS = [0,157,135,157,129,129,129,130,130,112,112,159]
    
    # Icons used for the Occassion stat in the Scope icons list
    #0 = Always (101)               2 = Only from the Menu (153) 
    #1 = Only in Battle (131)       3 = Never (145) 
    OCCASION_ICONS = [101,131,153,145]
    
    # Icons used for the Bonus stat in the Bonus icons list
    #0 = Two Handed (50)             2 = Prevent Critical (52) 
    #1 = Critical Bonus  (119)       3 = Half MP Cost (133) 
    BONUS_ICONS = [50,119,52,133]
    
    #------------------------------------------------------------------------
    # Generic patterns
    #------------------------------------------------------------------------
    
    # Gauge pattern
    GAUGE_PATTERN = "%d/%d"
    # Percentage pattern
    PERCENTAGE_PATTERN = "%d%" 
    # Precise Percentage pattern
    PRECISE_PERCENTAGE_PATTERN = "%#.05g%" 
    # Max EXP gauge value
    MAX_EXP_GAUGE_VALUE = "-------/-------"
    
    #------------------------------------------------------------------------
    # Item/Skill Details Window related
    #------------------------------------------------------------------------
    
    # Number of icons to show at the same time
    SW_LIST_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    SW_LIST_ICONS_TIMEOUT = 1

    # Pattern used to show the value of the Recovery effect
    REC_PATTERN = "%d%%+%d"
    # Sign for plus state set
    STATES_PLUS_SIGN = "+"
    # Sign for minus state set
    STATES_MINUS_SIGN = "-"
    
    #------------------------------------------------------------------------
    # Item Window related
    #------------------------------------------------------------------------
    
    # Pattern used to show the item quantity in the inventory
    ITEM_NUMBER_PATTERN = ":%2d"
    
    #------------------------------------------------------------------------
    # Skill Window related
    #------------------------------------------------------------------------
    
    # Pattern used to show the skill cost in the skill window
    SKILL_COST_PATTERN = "%4d"
    
    #------------------------------------------------------------------------
    # Scene Battle Commands related
    #------------------------------------------------------------------------
    
    # Icon for EXP
    ICON_EXP  = 102
    # Icon for Level
    ICON_LVL  = 132
    # Icon for TOTAL EXP
    ICON_TOTAL_EXP  = 62
    
    # Symbol to show that this is a list command
    LIST_COMMAND_ARROW = ">"
    
    # Input used to activate autobattle
    AUTOBATTLE_INPUT = Input::Y
    
    # BODY IMAGES by actor id
    # (Put your images inside the Graphics/Pictures folder.)
    BODY_IMAGES = []
    BODY_IMAGES[1] = Actor_Body_Image.new("face001.png", Rect.new(98,0,102,288))
    BODY_IMAGES[2] = Actor_Body_Image.new("face004.png", Rect.new(75,0,102,288))
    BODY_IMAGES[3] = Actor_Body_Image.new("face010.png", Rect.new(95,0,102,268))
    BODY_IMAGES[4] = Actor_Body_Image.new("face015.png", Rect.new(85,0,102,288))
    
    # Max number of battle commands
    MAX_BATTLE_COMMANDS = 5
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_ATTACK = Utilities.generate_battle_command_uid("BC_ATTACK")
    BC_SKILL = Utilities.generate_battle_command_uid("BC_SKILL")
    BC_GUARD = Utilities.generate_battle_command_uid("BC_GUARD")
    BC_ITEM = Utilities.generate_battle_command_uid("BC_ITEM")

    # Battle commands data
    DATA_BATTLE_COMMANDS = [
      Battle_Command.new(BC_ATTACK, BC_ATTACK),
      List_Command.new(BC_SKILL, BC_SKILL),
      Battle_Command.new(BC_GUARD, BC_GUARD),
      List_Command.new(BC_ITEM, BC_ITEM)
    ]
    
    # Default Battle Commands
    DEFAULT_BATTLE_COMMANDS = [BC_ATTACK, BC_SKILL, BC_GUARD, BC_ITEM]
    
    # Default Auto-Battle Command
    DEFAULT_AUTOBATTLE_COMMAND = DEFAULT_BATTLE_COMMANDS[0]
                               
    # Class Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS = {
      1 => [],
      2 => [],
      3 => [],
      4 => [LearningBattleCommand.new(BC_GUARD,10)]
    }
    CLASS_BATTLE_COMMANDS_LEARNINGS.default = []
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => ['type', ...]
    #   Where 'type' is one of the Battle commands above
    ACTOR_BATTLE_COMMANDS = {
      1 => DEFAULT_BATTLE_COMMANDS,
      2 => [BC_ATTACK, BC_GUARD, BC_SKILL, BC_ITEM],
      3 => [BC_SKILL, BC_GUARD, BC_ITEM, BC_ATTACK],
      4 => [BC_SKILL, BC_ITEM, BC_ATTACK],
    }
    ACTOR_BATTLE_COMMANDS.default = DEFAULT_BATTLE_COMMANDS
  
  end

end

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

#===============================================================================
# ** RPG::Actor Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Actor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get 
  #--------------------------------------------------------------------------
  # GET
  def battle_commands
    return BATTLECOMMANDS_CONFIG::ACTOR_BATTLE_COMMANDS[self.id]
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of battle commands that are active
  #attr_accessor :active_battle_commands
  # Array of available battle commands for the actor
  #attr_reader :battle_commands
  # Command used for autobattle
  #attr_accessor :autobattle_command
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Get Now Exp - The experience gained for the current level.
  #--------------------------------------------------------------------------
  # GET
  def now_exp
    return @exp - @exp_list[@level]
  end
  
  #--------------------------------------------------------------------------
  # Get Next Exp - The experience needed for the next level.
  #--------------------------------------------------------------------------
  # GET
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
  
  #--------------------------------------------------------------------------
  # * Get Battle Commands Object Array
  #--------------------------------------------------------------------------
  # GET
  def battle_commands
    result = []
    for i in @battle_commands
      result.push($game_battle_commands[i])
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Get Active Battle Commands Object Array
  #--------------------------------------------------------------------------
  # GET
  def active_battle_commands
    result = []
    for i in @active_battle_commands
      if i != nil
        result.push($game_battle_commands[i])
      end
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Get Autobattle Command Object
  #--------------------------------------------------------------------------
  # GET
  def autobattle_command
    return $game_battle_commands[@autobattle_command]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias setup_ebjb_2 setup unless $@
  def setup(actor_id)
    setup_ebjb_2(actor_id)
    actor = $data_actors[actor_id]
    @autobattle_command = BATTLECOMMANDS_CONFIG::DEFAULT_AUTOBATTLE_COMMAND
    @battle_commands = []
    @active_battle_commands = []
    for command_id in actor.battle_commands
      @active_battle_commands.push(command_id)
      learn_battle_command(command_id)
    end
    
    refresh_battle_commands_learnings()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Check if actor has a specific battle command
  #     obj : Item, Skill or Battle Command object
  #--------------------------------------------------------------------------
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Item))
      return active_battle_commands.any?{|c| c.is_a?(Item_Command) && c.item_id == obj.id} 
    elsif (obj.is_a?(RPG::Skill))
      return active_battle_commands.any?{|c| c.is_a?(Skill_Command) && c.skill_id == obj.id} 
    elsif (obj.is_a?(Battle_Command))
      return active_battle_commands.include?(obj)
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_autobattle_action
    @action.clear
    return unless movable?
    action = Game_BattleAction.new(self)
    
    command = self.autobattle_command
    if command.is_a?(Skill_Command)
      if command.is_custom
        action.forcing = true
      end
      if self.skill_can_use?(command.skill) || command.is_custom
        action.set_skill(command.skill.id)
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        action.set_item(command.item.id)
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        action.set_attack
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        action.set_guard
      end
    end
    
    action.evaluate
    
    #Keeps action if it has been evaluated, else don't do anything
    if action.value > 0
      @action = action
    end
  end
  
  #--------------------------------------------------------------------------
  # * Equip Auto Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def equip_autobattle_command(command_id)
    @autobattle_command = command_id
  end
  
  #--------------------------------------------------------------------------
  # * Equip Battle Command
  #     command_id : battle command ID
  #     index : index of the battle command position
  #--------------------------------------------------------------------------
  def equip_battle_command(command_id, index)
    @active_battle_commands[index] = command_id
  end
  
  #--------------------------------------------------------------------------
  # * Learn Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def learn_battle_command(command_id)
    unless battle_command_learn?($game_battle_commands[command_id])
      @battle_commands.push(command_id)
      #@battle_commands.sort!
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Battle Command
  #     command : Battle Command object
  #--------------------------------------------------------------------------
  def battle_command_learn?(command)
    return @battle_commands.include?(command.id)
  end
  
  #--------------------------------------------------------------------------
  # * Determine Usable Battle Commands
  #     command : Battle Command object
  #--------------------------------------------------------------------------
  def battle_command_can_use?(command)
    return false unless battle_command_learn?(command)
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Level Up
  #--------------------------------------------------------------------------
  alias level_up_ebjb level_up unless $@
  def level_up
    level_up_ebjb
    refresh_battle_commands_learnings()
  end
  
  #--------------------------------------------------------------------------
  # * Level Down
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
  
  #--------------------------------------------------------------------------
  # * Forget Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def forget_battle_command(command_id)
    @battle_commands.delete(command_id)
  end
  
  #--------------------------------------------------------------------------
  # * Refresh Battle Commands from learnings
  #--------------------------------------------------------------------------  
  def refresh_battle_commands_learnings
    for learning in self.class.battle_commands_learnings
      learn_battle_command(learning.command_id) if learning.can_learn?(@level)
    end
  end
  
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Action Value Evaluation (for automatic battle)
  #    @value and @target_index are automatically set.
  #--------------------------------------------------------------------------
  def evaluate
    if attack?
      evaluate_attack
    elsif skill?
      evaluate_skill
    elsif item?
      evaluate_item
    else
      @value = 0
    end
    if @value > 0
      @value + rand(nil)
    end
  end

  #--------------------------------------------------------------------------
  # * Item Evaluation
  #--------------------------------------------------------------------------
  def evaluate_item
    @value = 0
    unless $game_party.item_can_use?(item)
      return
    end
    if item.for_opponent?
      targets = opponents_unit.existing_members
    elsif item.for_user?
      targets = [battler]
    elsif item.for_dead_friend?
      targets = friends_unit.dead_members
    else
      targets = friends_unit.existing_members
    end
    for target in targets
      value = evaluate_item_with_target(target)
      if item.for_all?
        @value += value
      elsif value > @value
        @value = value
        @target_index = target.index
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Item Evaluation (target designation)
  #     target : Target battler
  #--------------------------------------------------------------------------
  def evaluate_item_with_target(target)
    target.clear_action_results
    target.make_obj_damage_value(battler, item)
    if item.for_opponent?
      return target.hp_damage.to_f / [target.hp, 1].max
    else
      recovery = [-target.hp_damage, target.maxhp - target.hp].min
      return recovery.to_f / target.maxhp
    end
  end
  
end

#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Battle Command
  #     command_id : battle command ID
  #--------------------------------------------------------------------------
  def [](command_id)
    if @data[command_id] == nil and $data_battle_commands[command_id] != nil
      @data[command_id] = $data_battle_commands[command_id].clone
    end
    return @data[command_id]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     item : item object
  #--------------------------------------------------------------------------
  def add_item_command(item)
    id = Utilities.generate_battle_command_uid("BC_ITEM_"+item.id.to_s)
    if (!@data.include?(id))
      @data[id] = Item_Command.new(id, item.id)
    end
    return @data[id]
  end
  
  #--------------------------------------------------------------------------
  # * Add new Item command
  #     skill : skill object
  #--------------------------------------------------------------------------
  def add_skill_command(skill)
    id = Utilities.generate_battle_command_uid("BC_SKILL_"+skill.id.to_s)
    if (!@data.include?(id))
      @data[id] = Skill_Command.new(id, skill.id)
    end
    return @data[id]
  end
  
  #--------------------------------------------------------------------------
  # * Remove the battle commands that are not used anymore (to save memory)
  #--------------------------------------------------------------------------
  def clean_commands
    for command in @data.values
      # Commands from data are always kept
      if !$data_battle_commands.include?(command.id)
        remove = true
        # Checks if the command is still in use
        for i in 1...$game_actors.size
          if $game_actors[i].is_command_equipped?(command)
            remove = false
          end
        end
        if remove 
          @data.delete(command.id)
        end
      end
    end
  end
  
end

#==============================================================================
# ** Game_Interpreter
#------------------------------------------------------------------------------
#  An interpreter for executing event commands. This class is used within the
# Game_Map, Game_Troop, and Game_Event classes.
#==============================================================================

class Game_Interpreter
  
  #--------------------------------------------------------------------------
  # * Alias command_121 - Control Switches
  #--------------------------------------------------------------------------
  alias command_121_ebjb command_121 unless $@
  def command_121
    result = command_121_ebjb
    
    # Refresh the battle commands list if the switch activates one
    for i in 1...$game_actors.size
      $game_actors[i].refresh_battle_commands_learnings
    end
    return result
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  #
  attr_reader :multi_actions
  #
  attr_reader :nbr_actions
  #
  attr_reader :multi_actions_kind
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def multi_actions?
    return !@multi_actions.nil?
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def multi_actions_completed?
    return @multi_actions.size == @nbr_actions
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructor
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_multi initialize unless $@
  def initialize
    @multi_actions = nil
    @nbr_actions = 0
    @multi_actions_kind = -1
    initialize_bc_multi
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////  
  
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def set_multi_actions(nbr)
    @multi_actions = []
    @nbr_actions = nbr
  end
  
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def add_multi_action(action)
    unless in_multi_actions?(action)
      @multi_actions.push(action)
    end
  end
  
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def remove_multi_action(action)
    if in_multi_actions?(action)
      @multi_actions.delete(action)
    end
  end
  
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def in_multi_actions?(action)
    return @multi_actions.include?(action)
  end
  
  #--------------------------------------------------------------------------
  # *
  #--------------------------------------------------------------------------
  def clear_multi_actions
    @multi_actions = nil
    @nbr_actions = 0
    @multi_actions_kind = -1
  end
  
end

#===============================================================================
# ** Scene Menu
#------------------------------------------------------------------------------
#  Add the Party & Formation item in the menu
#===============================================================================

class Scene_Menu < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_command_window
  #--------------------------------------------------------------------------
  alias create_command_window_ebjb create_command_window unless $@
  def create_command_window
    # Keeps the selected index and cancel the @menu_index
    # (because in the original create_command_window, 
    # this line is called after the creation of the window :
    #   @command_window.index = @menu_index
    # and with a command that doesn't exist, the index will be invalid)
    temp_index = @menu_index
    @menu_index = -1
    create_command_window_ebjb
    @command_battle_commands = @command_window.add_command(Vocab::battle_commands_menu_title)
    # Finally, apply the index when all the necessary commands are added
    @command_window.index = temp_index
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_command_selection
  #--------------------------------------------------------------------------
  alias update_command_selection_ebjb update_command_selection unless $@
  def update_command_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when @command_battle_commands
        start_actor_selection
      end
    end
    update_command_selection_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_selection
  #--------------------------------------------------------------------------
  alias update_actor_selection_ebjb update_actor_selection unless $@
  def update_actor_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when @command_battle_commands
        Sound.play_decision
        $scene = Scene_BattleCommands.new(@status_window.index, @command_window.index)
      end
    end
    update_actor_selection_ebjb
  end
  
end

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

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_ebjb start unless $@
  def start
    start_ebjb
    
    @actor_command_window.width = 200
    @actor_command_window.x = -200
    
    @autobattle = false
  end
  
  #--------------------------------------------------------------------------
  # * Update window movement
  #--------------------------------------------------------------------------
  def update_window_movement()
    # Actor command window position
    if @actor_command_window.active
      @actor_command_window.visible = true
      if @actor_command_window.x < 0
        @actor_command_window.x += 20
      end
    else
      if @actor_command_window.x > -200
        @actor_command_window.x -= 20
      else
        @actor_command_window.visible = false
      end
    end
    
    # Skill window position
    if @skill_window.active
      @skill_window.visible = true
      if @skill_window.y > 288+16
        @skill_window.y -= 16
      end
    else
      if @skill_window.y < 480
        @skill_window.y += 16
      else
        @skill_window.visible = false
      end
    end
      
    # Item window position
    if @item_window.active
      @item_window.visible = true
      if @item_window.y > 288+16
        @item_window.y -= 16
      end
    else
      if @item_window.y < 480
        @item_window.y += 16
      else
        @item_window.visible = false
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_auto_action
  #--------------------------------------------------------------------------
  alias make_auto_action_ebjb make_auto_action unless $@
  def make_auto_action(battler)
    action_made = make_auto_action_ebjb(battler)
    if !action_made && @autobattle
      battler.make_autobattle_action
      battler.battle_animation.do_ani_stand unless battler.battle_animation.is_running?
      return true
    end
    return action_made
  end
  
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_input
  #--------------------------------------------------------------------------
  alias update_actor_command_input_ebjb update_actor_command_input unless $@
  def update_actor_command_input
    update_autobattle_input
    update_actor_command_input_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Update Battle Help Input
  #--------------------------------------------------------------------------
  def update_autobattle_input
    if Input.trigger?(BATTLECOMMANDS_CONFIG::AUTOBATTLE_INPUT)
      @autobattle = !@autobattle
      if @autobattle
        end_actor_command_selection()
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_selection
  #--------------------------------------------------------------------------
  alias update_actor_command_selection_ebjb update_actor_command_selection unless $@
  def update_actor_command_selection
    actor = $game_party.members[@actor_index]
    
    # Forces refresh to disable/enable particular commands (ex.: skill or partners)
    @actor_command_window.window_update(actor)
    
    update_actor_command_selection_ebjb
  end
  
  #--------------------------------------------------------------------------
  # * Execute battle commands
  #     actor : Actor object
  #--------------------------------------------------------------------------
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.is_a?(List_Command)
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_SKILL
        Sound.play_decision
        @skill_window.filter = command.filter
        start_skill_selection(actor)  
      when BATTLECOMMANDS_CONFIG::BC_ITEM
        Sound.play_decision
        @item_window.filter = command.filter
        start_item_selection
      end
    elsif command.is_a?(Skill_Command)
      if command.is_custom
        actor.action.forcing = true
      end
      if actor.skill_can_use?(command.skill) || command.is_custom
        Sound.play_decision
        @actor_command_window.active = false
        determine_skill(command.skill)
      else
        Sound.play_buzzer
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        Sound.play_decision
        @actor_command_window.active = false
        determine_item(command.item)
      else
        Sound.play_buzzer
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        Sound.play_decision
        actor.action.set_attack
        start_target_enemy_selection
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        Sound.play_decision
        actor.action.set_guard
        add_to_battleline(actor)
        end_actor_command_selection()
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_multi execute_action unless $@
  def execute_action
    if @active_battler.multi_actions? 
      for action in @active_battler.multi_actions
        @active_battler.action = action
        execute_action_bc_multi
      end

      @active_battler.clear_multi_actions
      @active_battler.action.clear
    else
      execute_action_bc_multi
    end
  end
  
end

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

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 1
  #--------------------------------------------------------------------------
  def self.exp_gauge_color1
    return text_color(14)
  end
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 2
  #--------------------------------------------------------------------------
  def self.exp_gauge_color2
    return text_color(17)
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Get Chain Gauge Color 1
#~   #--------------------------------------------------------------------------
#~   def self.chain_gauge_color1
#~     return text_color(10)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Chain Gauge Color 2
#~   #--------------------------------------------------------------------------
#~   def self.chain_gauge_color2
#~     return text_color(18)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Time Gauge Color 1
#~   #--------------------------------------------------------------------------
#~   def self.time_gauge_color1
#~     return text_color(14)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Time Gauge Color 2
#~   #--------------------------------------------------------------------------
#~   def self.time_gauge_color2
#~     return text_color(17)
#~   end
  
#~   #--------------------------------------------------------------------------
#~   # * Get Positive Resist Gauge Color 1
#~   #--------------------------------------------------------------------------
#~   def self.pos_resist_gauge_color1
#~     return text_color(22)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Positive Resist Gauge Color 2
#~   #--------------------------------------------------------------------------
#~   def self.pos_resist_gauge_color2
#~     return text_color(23)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Negative Resist Gauge Color 1
#~   #--------------------------------------------------------------------------
#~   def self.neg_resist_gauge_color1
#~     return text_color(20)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Negative Resist Gauge Color 2
#~   #--------------------------------------------------------------------------
#~   def self.neg_resist_gauge_color2
#~     return text_color(21)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Resist Border Color 1
#~   #--------------------------------------------------------------------------
#~   def self.resist_border_color1
#~     return text_color(0)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Get Resist Border Color 2
#~   #--------------------------------------------------------------------------
#~   def self.resist_border_color2
#~     return text_color(7)
#~   end
  
end

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

#===============================================================================
# ** Window_Char_Image
#------------------------------------------------------------------------------
#  This window displays the actor background image
#===============================================================================

class Window_Char_Image < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # CResizableImage to show the character image
  attr_reader :cBackCharImage
  
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
    @cBackCharImage = CResizableImage.new(self, Rect.new(0, 0, self.contents.width, self.contents.height), 
                         nil, nil, 0, 255, 2, 3)
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
      bodyImg = BATTLECOMMANDS_CONFIG::BODY_IMAGES[actor.id]
      bitmap = Cache.picture(bodyImg.filename)
      @cBackCharImage.img_bitmap = bitmap
      @cBackCharImage.src_rect = Rect.new(bodyImg.src_rect.x, bodyImg.src_rect.y, 
                                          bitmap.width, bitmap.height)
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cBackCharImage.draw()
  end
  
end

#===============================================================================
# ** Window_Char_Info
#------------------------------------------------------------------------------
#  This window displays the actor name
#===============================================================================

class Window_Char_Info < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the character name
  attr_reader :cCharName
  # UCLabelIconValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's experience
  attr_reader :ucExp
  # UCBar for the EXP gauge of the character
  attr_reader :ucExpGauge
  # UCLabelIconValue for the character's total experience
  attr_reader :ucTotalExp
    
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

    @cCharName = CLabel.new(self, Rect.new(0,0,200,WLH), "")
    @cCharName.font = Font.bold_font
    
    @ucCharLvl = UCLabelIconValue.new(self, Rect.new(24,24,50,WLH), 
                                     Rect.new(0,24,24,24), 
                                     Rect.new(50,24,110, WLH), 
                                     Vocab::lvl_label, 
                                     BATTLECOMMANDS_CONFIG::ICON_LVL, "")
    @ucCharLvl.cValue.align = 2
    
    @ucExp = UCLabelIconValue.new(self, Rect.new(24,48,25,WLH), 
                                     Rect.new(0,48,24,24), 
                                     Rect.new(25,48,135, WLH),
                                     Vocab::exp_label, 
                                     BATTLECOMMANDS_CONFIG::ICON_EXP, "")
    @ucExp.cValue.align = 2
    @ucExpGauge = UCBar.new(self, Rect.new(0,48+16,162,WLH-16), 
                              Color.exp_gauge_color1, Color.exp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)                    
    
    @ucTotalExp = UCLabelIconValue.new(self, Rect.new(24,72,50,WLH), 
                                     Rect.new(0,72,24,24), 
                                     Rect.new(50,72,112,WLH), 
                                     Vocab::char_info_total_exp_label, 
                                     BATTLECOMMANDS_CONFIG::ICON_TOTAL_EXP, "")
    @ucTotalExp.cValue.align = 2
    
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      @cCharName.text = actor.name
      @ucCharLvl.cValue.text = actor.level
      
      if (actor.next_exp == 0)
        gauge_min = 1
        gauge_max = 1
        exp_value = BATTLECOMMANDS_CONFIG::MAX_EXP_GAUGE_VALUE
      else
        gauge_min = actor.now_exp
        gauge_max = actor.next_exp
        exp_value = sprintf(BATTLECOMMANDS_CONFIG::GAUGE_PATTERN, actor.now_exp, actor.next_exp)
      end
      
      @ucExp.cValue.text = exp_value
      @ucExpGauge.value = gauge_min
      @ucExpGauge.max_value = gauge_max
      
      @ucTotalExp.cValue.text = actor.exp
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cCharName.draw()
    @ucCharLvl.draw()
    @ucExpGauge.draw()
    @ucExp.draw()
    @ucTotalExp.draw()
  end
  
end

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

#==============================================================================
# ** Window_Skill_Command
#------------------------------------------------------------------------------
#  This window displays a list of usable skills on the skill screen, etc.
#==============================================================================

class Window_Skill_Command < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCSkill for every skill of a character
  attr_reader :ucSkillsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_skill
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
  #     filter : filter object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor=nil, filter=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucSkillsList = []
    window_update(actor, filter)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #     filter : filter object
  #--------------------------------------------------------------------------
  def window_update(actor, filter)
    @data = []
    if actor != nil
      @actor = actor

      if filter != nil
        temp_skills = actor.skills.find_all{|x| filter.apply(x)}
      else
        temp_skills = actor.skills
      end
      
      for skill in temp_skills
        if skill != nil && include?(skill)
          @data.push(skill)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucSkillsList.clear()
      for i in 0..@item_max-1
        @ucSkillsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucSkillsList.each() { |ucSkill| ucSkill.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(skill == nil ? "" : skill.description)
#~     else
      if selected_skill != nil
        @help_window.window_update(selected_skill.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_skill != nil
      @detail_window.window_update(selected_skill)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_skill != nil && selected_skill.is_a?(RPG::Skill)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     skill : skill object
  #--------------------------------------------------------------------------
  def enable?(skill)
    return !@actor.is_command_equipped?(skill)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in skill list
  #     skill : skill
  #--------------------------------------------------------------------------
  def include?(skill)
    return skill.is_a?(RPG::UsableItem) && [0,1].include?(skill.occasion)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    skill = @data[index]
    rect = item_rect(index, true)
    
    ucSkill = UCSkill.new(self, skill, rect, @actor.calc_mp_cost(skill))
    ucSkill.active = enable?(skill)
    
    return ucSkill
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Item_Command
#------------------------------------------------------------------------------
#  This window displays a list of inventory items for the item screen, etc.
#==============================================================================

class Window_Item_Command < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
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
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor=nil, items=nil, filter=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(actor, items, filter)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def window_update(actor, items, filter)
    @data = []
    if actor != nil && items != nil 
      @actor = actor

      if filter != nil
        temp_items = items.find_all{|x| filter.apply(x)}
      else
        temp_items = items
      end

      for item in temp_items
        if item != nil && (filter != nil || include?(item))
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(item == nil ? "" : item.description)
#~     else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && selected_item.is_a?(RPG::Item)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     item : item object
  #--------------------------------------------------------------------------
  def enable?(item)
    return !@actor.is_command_equipped?(item)
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Draw a specific item
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     rect = item_rect(index)
#~     self.contents.clear_rect(rect)
#~     item = create_item(index)
#~     item.draw()
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Return true if there are items in the list else false
#~   #--------------------------------------------------------------------------
#~   def hasItems
#~     return @ucItemsList.size > 0
#~   end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::UsableItem) && [0,1].include?(item.occasion)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
    
#~     if $game_party.newest_items.include?(item)
#~       ucItem.cItemName.font.color = Color.new_item_color
#~       ucItem.cItemNumber.font.color = Color.new_item_color
#~     end
                              
    return ucItem
  end
  private :create_item
  
end

#==============================================================================
# ** Window_BattleSkill
#------------------------------------------------------------------------------
#  This window displays a list of usable skills during battle.
#==============================================================================

class Window_BattleSkill < Window_Skill
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Filter
  #--------------------------------------------------------------------------
  def filter=(filter)
    @filter = filter
    refresh
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if @actor != nil
      if @filter != nil
        temp_skills = @actor.skills.find_all{|x| @filter.apply(x)}
      else
        temp_skills = @actor.skills
      end
      
      refresh_skills(temp_skills)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Refresh skills
  #--------------------------------------------------------------------------
  def refresh_skills(skills)
    @data = []
    for skill in skills
      @data.push(skill)
      if skill.id == @actor.last_skill_id
        self.index = @data.size - 1
      end
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  
end

#==============================================================================
# ** Window_BattleItem
#------------------------------------------------------------------------------
#  This window displays a list of inventory items during battle.
#==============================================================================

class Window_BattleItem < Window_Item
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Filter
  #--------------------------------------------------------------------------
  def filter=(filter)
    @filter = filter
    refresh
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    if @filter != nil
      temp_items = $game_party.items.find_all{|x| @filter.apply(x)}
    else
      temp_items = $game_party.items
    end
    refresh_items(temp_items)
  end
  
  #--------------------------------------------------------------------------
  # * Refresh items
  #--------------------------------------------------------------------------
  def refresh_items(items)
    @data = []
    for item in items
      next unless (@filter != nil || include?(item))
      @data.push(item)
      if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
        self.index = @data.size - 1
      end
    end
    @data.push(nil) if include?(nil)
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  
end

#==============================================================================
# ** UCItem
#------------------------------------------------------------------------------
#  Represents an item on a window
#==============================================================================

class UCItem < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the item icon
  attr_reader :ucIcon
  # Label for the item name
  attr_reader :cItemName
  # Label for the item quantity
  attr_reader :cItemNumber
  # Item object
  attr_reader :item
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cItemName.visible = visible
    @cItemNumber.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cItemName.active = active
    @cItemNumber.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     item : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, item, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @item = item
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], item.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cItemName = CLabel.new(window, rects[1], item.name)
    @cItemName.active = active
    @cItemName.visible = visible
    @cItemName.cut_overflow = true
    
    @cItemNumber = CLabel.new(window, rects[2], 
                              sprintf(BATTLECOMMANDS_CONFIG::ITEM_NUMBER_PATTERN, 
                                      $game_party.item_number(item)), 2)
    @cItemNumber.active = active
    @cItemNumber.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cItemName.draw()
    @cItemNumber.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,32,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cItemName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cItemNumber
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCSkill
#------------------------------------------------------------------------------
#  Represents a skill on a window
#==============================================================================

class UCSkill < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the skill icon
  attr_reader :ucIcon
  # Label for the skill name
  attr_reader :cSkillName
  # Label for the skill mp cost
  attr_reader :cSkillMpCost
  # Skill object
  attr_reader :skill
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cSkillName.visible = visible
    @cSkillMpCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cSkillName.active = active
    @cSkillMpCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     skill : skill object
  #     rect : rectangle to position the controls for the skill
  #     mpCost : skill mp cost
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, skill, rect, mpCost, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @skill = skill
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], skill.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cSkillName = CLabel.new(window, rects[1], skill.name)
    @cSkillName.active = active
    @cSkillName.visible = visible
    @cSkillName.cut_overflow = true
     
    @cSkillMpCost = CLabel.new(window, rects[2], 
                               sprintf(BATTLECOMMANDS_CONFIG::SKILL_COST_PATTERN, mpCost), 2)
    @cSkillMpCost.active = active
    @cSkillMpCost.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cSkillName.draw()
    @cSkillMpCost.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,32,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cSkillName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cSkillMpCost
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end

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

