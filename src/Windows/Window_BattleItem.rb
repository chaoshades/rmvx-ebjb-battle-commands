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
