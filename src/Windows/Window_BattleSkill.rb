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
