extends Node

#Player signals
#connected from ship's action timer to HUD
signal dash
#connected from damage rock to ship
signal damage_taken

signal rock_mined

#UI signals
# Connected from ship to gameOverScreen
signal player_died(score)
# Connected from shop Quest menu to HUD Quest label and ShipData
signal quest_received(content)
