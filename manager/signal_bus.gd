extends Node

##################################################
signal player_damaged
# 플레이어 파괴 신호
signal asteroid_damaged
# 소행성 파괴 신호

##################################################
func emit_player_damaged() -> void:
	emit_signal("player_damaged")
# 플레이어 파괴 신호 발산

##################################################
func emit_asteroid_damaged() -> void:
	emit_signal("asteroid_damaged")
# 소행성 파괴 신호 발산
