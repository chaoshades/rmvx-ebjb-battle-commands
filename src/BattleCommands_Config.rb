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
