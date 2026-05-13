extends Node
class_name GameMath

## Calculates a scaled value based on level.
## base_value: The value at Level 1.
## level: The current player level.
## exponent: How "fast" it scales. 
##   - 1.0 = Linear (scales exactly with level)
##   - 1.5 = Moderate growth
##   - 2.0 = Quadratic (scales very fast)
static func get_scaled_value(base_value: float, level: int, exponent: float) -> float:
	return base_value * pow(level, exponent)


# Example: 10% faster each level
# base_value = 1.0 (Initial cooldown)
# level = enemy_level
# multiplier = 0.9 (The "Decay Rate")
static func get_exponential_decay(base_value: float, level: int, multiplier: float) -> float:
	return base_value * pow(multiplier, level)


## Returns true if a random roll (1-100) is less than or equal to the chance provided.
static func chance_check(percentage: float) -> bool:
	# randf_range generates a random float between 0.0 and 100.0
	var roll := randf_range(0.0, 100.0)
	return roll <= percentage

static func convert_points_to_bucks(points: int, conversion_rate: float) -> int:
	return floor(points * conversion_rate)
