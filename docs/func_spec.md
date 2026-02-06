# Incremental Outpost: Functional Specification

## 1. Narrative Overview
The player assumes the role of a **Digitally Captured Consciousness (DCC)**—the uploaded mind of a human survivor in a dystopian future. In this world, aging automated defense outposts require human intuition for combat calculations that standard AI cannot resolve. The player is hosted on antiquated hardware, represented by an Amber CRT interface, and tasked with defending the station against endless threats.

## 2. Phase 1: Arcade Phase (Combat)
The arcade phase is the active defense simulation where the player protects the central outpost.

### 2.1 Outpost Systems
* **Central Station**: Located at the center of the viewport (640x640).
* **Cardinal Defense**: The station has a cannon and a shield at each cardinal direction (Up, Down, Left, Right).
* **Shield Mechanics**: 
    * Activated using **WASD** keys.
    * Intercepts and destroys incoming enemy projectiles.
    * Only one shield can be active at a time.
* **Cannon Mechanics**:
    * Fired using **Arrow Keys**.
    * **Absorption Logic**: An intact cannon automatically absorbs one incoming projectile from its direction, protecting the station hull.
    * **Damaged State**: Once hit, the cannon sprite changes (frame 1), it can no longer fire, and it no longer absorbs hits.
* **Station Health**: 
    * The player starts with **3 bars of health**.
    * If a projectile reaches the station on a side where the cannon is already damaged and no shield is active, one health bar is lost.
    * Game over occurs when health reaches zero.

### 2.2 Enemy Behavior
* **Spawning**: Enemies spawn at the cardinal edges of the screen.
* **Combat**: Enemies fire projectiles toward the center at randomized intervals.
* **Progression**: Each time an enemy is hit, its `enemy_level` increases, which dynamically scales its firing chance and reduces shot delays.

### 2.3 Projectile Interaction
* **Cancellation**: If a player projectile and an enemy projectile collide, they cancel each other out and both are destroyed.

## 3. Phase 2: The Consciousness Interface (Incremental)
Upon hull failure (Health 0), the DCC is extracted back to the Hangar terminal.

### 3.1 Visual Aesthetic
* **Amber CRT**: The interface is a monochromatic deep-orange simulation featuring scanlines, phosphor bloom, and subtle screen curvature.
* **Technical Log**: The transition from combat to menu is framed as a data upload/extraction sequence.

### 3.2 Skill Tree (Subroutine Optimization)
Progress is managed via a node-based skill tree where the DCC "optimizes" the station's subroutines.

* **Currency**: **Points** earned during combat are converted into **Optimization Data** (Neural Credits).
* **Node Dependency**: Further nodes are locked until connecting "closer" nodes are purchased.
* **Upgrade Categories**:
    * **Automated Diagnostics**: Unlocks the ability for cannons to repair themselves.
        * *Tier 1*: Active Repair (Manual trigger).
        * *Tier 2*: Passive Repair (Auto-repair after X seconds).
    * **Neural Link Stability**: Improves projectile velocity and decreases cannon fire rates.
    * **Structural Integrity**: Increases maximum health bars.
    * **Shield Efficiency**: Enhances shield duration or availability.

### 3.3 State Persistence
* All purchased upgrades are persistent across runs.
* Upgraded stats are injected into the station hardware (Arcade Phase) upon "Redeploy."

## 4. Controls Reference
| Action | Input |
| :--- | :--- |
| **Move Shield** | W, A, S, D |
| **Fire Cannons** | Arrow Keys |
| **Navigate CRT** | Mouse / Keyboard |
| **Redeploy** | Enter |