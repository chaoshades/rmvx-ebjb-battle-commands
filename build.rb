module EBJB_BattleCommands
  # Build filename
  FINAL   = "build/EBJB_BattleCommands.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/BattleCommands_Config.rb",
    "src/RPG Objects/RPG_Class Addon.rb",
    "src/RPG Objects/RPG_Actor Addon.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_Battle_Commands.rb",
    "src/Game Objects/Game_Interpreter.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Menu.rb",
    "src/Scenes/Scene_BattleCommands.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/Scenes/Scene_Title.rb",
    "src/Scenes/Scene_File.rb",
    "src/User Interface/Font.rb",
    "src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
    "src/Windows/Window_ActorCommand.rb",
    "src/Windows/Window_Char_Image.rb",
    "src/Windows/Window_Char_Info.rb",
    "src/Windows/Window_AutoBattle_Command.rb",
    "src/Windows/Window_Battle_Commands.rb",
    "src/Windows/Window_Skill_Command.rb",
    "src/Windows/Window_Item_Command.rb",
	"src/Windows/Window_BattleSkill.rb",
	"src/Windows/Window_BattleItem.rb",
    "src/User Controls/UCItem.rb",
    "src/User Controls/UCSkill.rb",
	"src/User Controls/UCBattleCommand.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_BattleCommands::FINAL, "w+")
  EBJB_BattleCommands::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
