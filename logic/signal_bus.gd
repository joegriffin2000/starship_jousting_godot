extends Node

#Player signals
#connected from ship's action timer to HUD
signal dash
#connected from damage rock to ship
signal damage_taken


#UI signals
#connected from ship to game over screen
signal player_died(score)
#connected from quest menu to HUD label
signal quest_received(content)
