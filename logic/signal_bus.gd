extends Node

# Player signals
# Connected from ship's action timer to HUD
signal dash
# Connected from damage rock to ship
signal damage_taken

# Quest signals
signal rock_mined

# UI signals
# Connected from ship to gameOverScreen
signal player_died(score)
# Connected from shop Quest menu to HUD Quest labels and ShipData
signal quest_received(content)
# Connected from Quest class to HUD Quest labels
signal quest_progressed
# Connected from Quest class to HUD Quest labels
signal quest_completed
# Connected from Carrier to HUD Credits label
signal credits_updated
