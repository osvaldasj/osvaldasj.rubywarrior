
class Player
  attr_accessor :health_last_turn
  @health_last_turn = 0
  @touched_back_wall = false
  @touched_front_wall = false

  def play_turn(warrior)
    # cool code goes here
    if can_rest(warrior.health, @health_last_turn)
      warrior.rest!
    elsif !warrior.feel.empty?
      if warrior.feel.captive?
        warrior.rescue!
      elsif warrior.feel(:backward).captive?
        warrior.rescue!(:backward)
      else
        warrior.attack!
      end
    elsif (!warrior.feel(:backward).empty? && !@touched_back_wall)
      if warrior.feel(:backward).captive?
        warrior.rescue!(:backward)
      else
        warrior.attack!(:backward)
      end
    else
      if (@touched_back_wall == false)
        warrior.walk!(:backward)
      else
        if @touched_front_wall
          warrior.pivot!
        else
          warrior.walk!
        end
      end
    end
    
    @touched_back_wall||= warrior.feel(:backward).wall?
    @touched_front_wall||= warrior.feel.wall?
    @health_last_turn = warrior.health
  end
  

  def can_rest(current, last_turn)
    if current == 20
      return false
    else
      return (current.to_i >= last_turn.to_i)
    end
  end
  
end
  
