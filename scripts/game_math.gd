extends Node
class_name GameMath

## Calculates a scaled value based on level.
## base_value: The value at Level 1.
## level: The current player level.
## exponent: How "fast" it scales. 
##   - 1.0 = Linear (scales exactly with level)
##   - 1.5 = Moderate growth
##   - 2.0 = Quadratic (scales very fast)
static func get_scaled_value(base_value: float, level: int, exponent: float = 1.0) -> float:
	return base_value * pow(level, exponent)
	
## Returns true if a random roll (1-100) is less than or equal to the chance provided.
static func chance_check(percentage: float) -> bool:
	# randf_range generates a random float between 0.0 and 100.0
	var roll := randf_range(0.0, 100.0)
	return roll <= percentage
