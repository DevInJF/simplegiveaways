module PublicUtils

  def to_bool(boolish)
    case boolish
    when "0"
      false
    when "1"
      true
    when 0
      false
    when 1
      true
    when (boolish.is_a?(FalseClass) || boolish.is_a?(TrueClass))
      boolish
    else
      false
    end
  end
end
