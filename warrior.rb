
class Player
  attr_accessor :health, :warrior
  @health = 0

  def play_turn(warrior)
    @warrior = warrior
    # cool code goes here
    unless keep_healthy
      advance
    end
    
    @health = warrior.health
    
  end
  
#advance
  def anything_in_front?
    return !warrior.feel.empty?
  end
  
  def anything_behind?
    return !warrior.feel(:backward).empty?
  end

  def move direction
    warrior.walk!(direction)
  end
  
  def charge direction
    warrior.attack!(direction)
  end
  
  def help direction
    warrior.rescue!(direction)
  end
  
  def advance
    _direction = nil
    if anything_behind?
      _direction = :backward
    elsif anything_in_front?
      _direction = :forward
    elsif warrior.look(:backward)
      _is_enemy = false
      warrior.look(:backward).each do |space|
        if space.enemy?
          _is_enemy = true
          break
        end
      end
      if _is_enemy
        warrior.shoot!(:backward)
        return false
      else
        _is_enemy = false
        warrior.look.each do |space|
          if space.enemy?
            _is_enemy = true
            break
          end
        end
          if _is_enemy
            warrior.shoot!
            return false
          else
            move :forward
            return false
        end
      end
    end
    
    if warrior.feel(_direction).enemy?
      charge _direction
    elsif warrior.feel(_direction).captive?
      help _direction
    elsif warrior.feel.wall?
      warrior.pivot!
    else
      move :forward
    end
  end
#protect life
  def keep_healthy
    if (being_attacked? && is_health_critical? && !anything_around?)
      warrior.walk!(:backward)
      return true
    elsif (anything_around? && being_attacked? && is_health_critical?)
      warrior.walk!(:backward)
      return true
    elsif (!being_attacked? && is_low_health?)
      warrior.rest!
      return true
    else
      return false
    end 
  end
  
  def anything_around?
    return (anything_behind? || anything_in_front?)
  end
  
  def being_attacked?
    return warrior.health.to_i < @health.to_i
  end
  
  def is_low_health?
    return warrior.health < 20
  end
  
  def is_health_critical?
    return warrior.health < 6
  end
end
