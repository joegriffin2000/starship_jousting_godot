extends Node

# Player signals
# Connected from ship's action timer to HUD
signal dash

signal dash_regen
# Connected from damage rock to ship
signal damage_taken

# Quest signals
# Connected from damage rock to ship
signal rock_mined(attacker)
# Connected from enemy to ship
signal enemy_killed(object)

# Other object signals

# UI signals
# Connected from ship to gameOverScreen
signal player_died(score)
# Connected from shop Quest menu to HUD Quest labels and ShipData
signal quest_received(content)
# Connected from Quest class to HUD Quest labels and Ship
signal quest_progressed
# Connected from Quest class to HUD Quest labels
signal quest_completed
# Connected from Quest class to HUD Quest labels
signal quest_failed
# Connected from Carrier to HUD Quest labels
signal quest_removed
# Connected from Carrier to HUD Credits label and Ship
signal credits_updated
# Connected from Carrier to HUD leaderboard
signal score_updated

signal upgrade_special(id,val)
