# Code Review — Follow-up Work

Full codebase review performed 2026-08-14. Top-priority bugs were fixed in that
session (see below); everything else is logged here for later work. Line
numbers reference the current state of the repo.

## Already fixed

1. **Respec left skill values stale** — `SkillModifier` caches were never
   invalidated after `respec()`. Fixed via new `SkillsManager.refresh_all()`
   (`skills_manager.gd:28-30`), called from `GameManager.respec()`
   (`game_manager.gd:109`).
2. **Health off-by-one** — game ended at hull -1 (4 hits) instead of 0 (3 hits).
   Fixed in `arcade_game.gd` (`<= 0`) and the firing gate in `player.gd`
   (`> 0`).
3. **Wave logic on freed nodes** — `EnemiesContainer._on_node_removed` could
   run `start_new_enemy_wave()` against a freed container during game-over
   teardown. Now guarded with `is_inside_tree()` before/after the
   `await physics_frame` (`enemies_container.gd:61-66`).

## Real bugs (next priority)

### 1. Skill purchase path skips all validation
`game_manager.gd:58-64` (`process_node_purchase`), `skill_tree_node_base.gd:91-106`, `skill_node_info_container.gd:19`

Purchase checks neither affordability nor that the parent node is purchased —
the only gate is the Buy button being disabled when the info panel loads, a
snapshot that goes stale. Consequences:
- Open a node's info, buy another node, then click Buy again on the still-open
  panel → **negative bucks**.
- UNREVEALED nodes are invisible (modulate alpha 0) but their `Area2D` still
  receives input → can click through and **skip the prerequisite chain**.

Suggested fix: enforce both checks inside `process_node_purchase` (return early
if `not is_affordable_bucks(node.skill_cost)` or the parent isn't purchased),
and refresh the Buy button's disabled state when `update_ui()` runs.

### 2. Story nodes leak into stat computation (fragile by accident)
`game_manager.gd:74-76`, `skill_node_data.gd:28-31`

`get_purchased_nodes()` has a dead `pass` where the intent was clearly
`continue` (skip story nodes). They get appended anyway, and `SkillNodeData`
leaves story-node `affected_stat`/`modifier_type`/`modifier_value` uninitialized
(0 = `CANNON_COOLDOWN`, ADD, 0.0). Harmless today only because "ADD 0.0" is a
no-op — silently breaks if the enum is reordered or modifier defaults change.

Suggested fix: skip story nodes in `get_purchased_nodes()`, or have
`SkillModifier._refresh_cache` ignore nodes with no affected stat.

### 3. `get_purchased_nodes` asserts on save data
`game_manager.gd:76`

`assert(_skill_nodes_by_name.has(purchased))` hard-crashes debug builds when a
save references a node name that no longer exists in the tree (renamed/pruned
node, old schema). This is why "delete old saves" is more than a convenience.

Suggested fix: degrade gracefully (skip unknown names, or at least `push_error`
once) instead of asserting.

### 4. Cannon cooldown reaching 0 crashes
`cannon.gd:77-80`, `radial_cooldown.gd:25`

`_set_fire_cooldown()` feeds the CANNON_COOLDOWN skill value straight into
`start_cooldown()`, which asserts `cooldown_duration > 0`. If skill nodes ever
push the stat to 0, this aborts. The QTC already models the right pattern:
`quantum_tesla_cannon.gd:32` special-cases `cooldown == 0.0` → `disable()`.

Suggested fix: clamp the cooldown to a floor (e.g. `max(0.1, value)`), or
disable the cannon at 0 like the QTC does.

### 5. `Enemy.take_damage()` is async fire-and-forget
`enemy.gd:27-33`

`take_damage()` awaits the hit flash, then emits `enemy_hit` and frees. Two
projectiles landing within the ~0.15s flash window trigger it twice → double
`enemy_hit` → double points and double poof labels.

Suggested fix: short-circuit if already dying (e.g. a `_is_dying` flag set
before the await), or guard in `_on_area_entered`.

## Nits / cleanup

- **`cannon.gd:40`** — `_position_radial_cooldown` flips the cooldown ring for
  rotations 90°/180° but not 270° (left cannon). Verify the left cannon's ring
  position in the scene.
- **`arcade_ui.gd:39`** — `remap(cur_max, 10.0, 100.0, 10.0, 100.0)` is an
  identity no-op; the width math below it works regardless. Remove or fix.
- **`smart_bomb_screen_effect.gd:39`** — `for i in range(0,1)` is a dead
  single-iteration loop.
- **`cannons.gd:7,47`** — `%Cannons` onready is a self-reference (just use
  `self`); leftover `print("no cannons found to repair")` plus
  `#play fail to repair sound?` TODOs.
- **`enemy_spawner.gd:50`** — always instantiates enemy1 (documented TODO; fine
  to leave until enemy variety is added).
- **`enemy.gd:84`** — fire chance scales as `50 * level^1.25` and exceeds 100 by
  level ~2 → guaranteed shots. Probably intended, but the ramp saturates fast.
- **`end_game_interstitial.gd:21-31,52-75`** — clicking during typing calls
  `_count_up_bucks()` without awaiting; spam-clicking runs two overlapping
  tweens on the same label, and `stop_typing()` (unlike `finish_typing()`) never
  emits `typing_complete`, so the abandoned `await ...start_typing()` coroutines
  in `run_interstitial()` never resume (benign, but dead code paths).
- **`volume_control.gd:16,25,41,47`** — indexes `bus_volumes`/`bus_enableds`
  directly; an old save missing the keys yields null errors. Use
  `dict.get(key, default)`.
- **`lightning_fx.gd:10`** — spawns into `tree.current_scene`; crashes if a
  lightning ever fires mid scene-swap. Guard for `current_scene == null`.
- **`typing_label.gd:21`** — `text[visible_characters - 1]` indexes an empty
  string to `text[-1]`; guard for empty text.
- **`skills_manager.gd:36`** — `_add_basic_modifiers` uses `return` where it
  means `continue`; harmless today (only called once on an empty dict) but would
  leave other stats uninitialized if ever called twice.

## Notes

- No test/lint tooling; validate GDScript changes in the Godot editor
  (`D:/Godot_v4.7-stable_win64.exe`).
- Old saves at `user://game_data.tres` may need a manual delete while iterating
  on save-schema changes.
