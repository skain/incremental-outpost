extends Node

#region shield signals
signal shield_energy_updated(cur_shield_energy: float, cur_shield_energy_max: float)

signal shield_cooldown_updated(shield_cooldown_max: float, shield_cooldown_cur_value: float)
#endregion

#region smart_bomb signals
signal smart_bombs_updated(smart_bombs_max: int, smart_bombs_left: int)
#endregion

#region enemy signals
signal enemy_hit(enemy: Enemy)
#endregion
