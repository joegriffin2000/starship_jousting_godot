extends Node

# Player signals
# Connected from ship's action timer to HUD
signal dash
# Connected from damage rock to ship
signal damage_taken

# Quest signals
# Connected from damage rock to ship
signal rock_mined
# Connected from enemy to ship
signal enemy_killed

# Other object signals

# UI signals
# Connected from ship to gameOverScreen
signal player_died(score)
# Connected from shop Quest menu to HUD Quest labels and ShipData
signal quest_received(content)
# Connected from Quest class to HUD Quest labels
signal quest_progressed
# Connected from Quest class to HUD Quest labels
signal quest_completed
# Connected from Carrier to HUD Quest labels
signal quest_removed
# Connected from Carrier to HUD Credits label
signal credits_updated
