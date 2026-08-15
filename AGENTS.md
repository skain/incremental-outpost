# AGENTS.md

Godot 4.7 2D game (GDScript). Two-phase loop: arcade combat (`scenes/arcade/`) → CRT meta layer with a node-based skill tree (`scenes/crt/`). Main scene is `scenes/main/main.tscn`; `Main` (`main.gd`) swaps between an `ArcadeGame` and a `CRTPanel` view.

## Tooling / verification

- No test/lint tooling. Godot is the only tool; the editor binary is a Windows exe (`D:/Godot_v4.7-stable_win64.exe`), and no `godot` binary is on PATH in the Linux/WSL shell, so headless script checks usually aren't available here. Validate GDScript in the Godot editor.
- Web export lands in `web/` (gitignored); `run-web.bat` serves it via `npx http-server ./web -p 8060` (Windows).
- `git_to_markdown.py` regenerates `git_log.md` — devlog helper, not game code. `devlog/` is YouTube-devlog planning material, not game logic.

## Architecture

- Autoloads (registered in `project.godot` as `*uid://...`): `GameManager` (persistence, points/bucks, skill-node registry), `SfxManager`, `SignalBus` (all cross-scene signals), `SkillsManager` (computed stat values).
- Skill system: every stat lives in `Enums.SkillTypes` (`scripts/enums.gd`). `SkillTreeNode`s apply `SkillModifier` ADD/MULTIPLY/ENABLE changes; `SkillModifier` caches the aggregate value and recomputes via `request_refresh()`. Nodes self-register through `GameManager.register_skill_node(node)`.
- Persistence: `GameManager` saves a `GameData` `Resource` to `user://game_data.tres`. `respec()` refunds non-story nodes (`purchased_node_names` starting with `StorySkillTreeNode` are exempt).
- Runtime wiring uses `%UniqueName` node references (e.g. `%Player`) and `@export`ed PackedScene preloads rather than hardcoded paths.

## Gotchas

- Godot 4.4+ uid references are used throughout (`run/main_scene="uid://..."`, autoloads, font, bus layout) and `.gd.uid`/`.tscn` uid files are committed. Don't hand-edit uids or create `.uid` files — let the editor regenerate them.
- `project.godot` sets `gdscript/warnings/untyped_declaration=2`, so untyped declarations are compile **errors**. Every variable and function signature must be explicitly typed.
- All GDScript uses `class_name`, tabs for indentation (`.editorconfig`), LF line endings (`.gitattributes`).
- Physics layers are named in `project.godot` (Environment, Player, Enemies, PlayerProjectiles, EnemyProjectiles); enemies/projectiles are also found via `get_tree().get_nodes_in_group()` on groups `Enemy`, `Player`, `EnemyProjectile`, `PlayerProjectile`.
- Pixel-art look: 640x640 viewport with `viewport` stretch mode, `gl_compatibility` renderer, pixel-snapped transforms.
- Root-level `temp.gd`/`temp.tscn` are scratch files. `wip/` holds draft/abandoned art; real art lives in `assets/`, editable sources in `pixelorama/` (`.pxo`).

## Workflow

- Add a new stat: extend `Enums.SkillTypes`, add a base value in `SkillsManager.base_values`, create `SkillTreeNode`s, then expose it via `SkillsManager.get_as_*()` where consumed.
- Adding a new cross-cutting signal: put it in `SignalBus`.
- Save-data schema changes: edit `GameData` (`scripts/resources/game_data_resource.gd`). Old saves at `user://game_data.tres` may need a manual delete while iterating.
