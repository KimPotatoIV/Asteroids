extends Node

##################################################
var score: int = 0
# 점수 변수 초기화
var game_over: bool = true
# 게임 오버 상태 초기화
var asteroid_damaged_sound_player: AudioStreamPlayer
# 소행성 파괴 시 재생할 사운드 플레이어

##################################################
func _ready() -> void:
	asteroid_damaged_sound_player = AudioStreamPlayer.new()
	# 새로운 오디오 스트림 플레이어 생성
	asteroid_damaged_sound_player.stream = \
		preload("res://sounds/maou_se_battle_explosion04.wav")
	# 소행성 파괴 사운드 파일 로드
	asteroid_damaged_sound_player.volume_db = -20.0
	# 볼륨 설정
	add_child(asteroid_damaged_sound_player)
	# 사운드 플레이어를 노드에 추가
	
	SignalBus.connect("asteroid_damaged", Callable(self, "_on_asteroid_damaged"))
	# SignalBus의 asteroid_damaged 발산 신호와 _on_asteroid_damaged 함수 연결

##################################################
func _on_asteroid_damaged() -> void:
	asteroid_damaged_sound_player.play()
# 소행성 파괴 사운드 재생

##################################################
func get_score() -> int:
	return score
# 점수 반환
	
##################################################
func set_score(value: int) -> void:
	score = value
# 점수 설정

##################################################
func get_game_over() -> int:
	return game_over
# 게임 오버 여부 반환

##################################################
func set_game_over(value: bool) -> void:
	game_over = value
# 게임 오버 여부 설정
