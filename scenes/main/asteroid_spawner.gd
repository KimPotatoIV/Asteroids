extends Node2D

##################################################
const BIG_ASTEROID_SCENE: PackedScene = \
	preload("res://scenes/asteroid_big/asteroid_big.tscn")
# 큰 크기 소행성 씬 미리 로드
const MIDDLE_ASTEROID_SCENE: PackedScene = \
	preload("res://scenes/asteroid_middle/asteroid_middle.tscn")
# 중간 크기 소행성 씬 미리 로드
const SMALL_ASTEROID_SCENE: PackedScene = \
	preload("res://scenes/asteroid_small/asteroid_small.tscn")
# 작은 크기 소행성 씬 미리 로드
const SPAWN_INTERVAL: float = 2.0
# 소행성 생성 간격

var spawn_timer: Timer
# 소행성 생성 간격을 위한 타이머

##################################################
func _ready() -> void:
	spawn_timer = Timer.new()
	# 새로운 타이머 인스턴스 생성
	spawn_timer.wait_time = SPAWN_INTERVAL
	# 타이머 대기 시간 SPAWN_INTERVAL로 설정
	spawn_timer.autostart = true
	# 타이머 자동 시작 설정
	spawn_timer.one_shot = false
	# 타이머 반복 실행 되도록 설정
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	# 타이머와 _on_spawn_timer_timeout 함수 연결
	add_child(spawn_timer)
	# 타이머를 노드에 추가

##################################################
func _on_spawn_timer_timeout() -> void:
	if GameManager.get_game_over():
		return
	# 게임 오버라면 함수 종료
	
	var new_asteroid: Node2D
	# 새로운 소행성 변수
	var asteroid_kind: int = randi_range(0, 2)
	# 소행성 종류를 정하기 위한 정수 변수
	
	match asteroid_kind:
		0:
			new_asteroid = BIG_ASTEROID_SCENE.instantiate()
		1:
			new_asteroid = MIDDLE_ASTEROID_SCENE.instantiate()
		2:
			new_asteroid = SMALL_ASTEROID_SCENE.instantiate()
	# asteroid_kind에 따라 큰 소행성부터 작은 소행성까지 임의로 인스턴스화 
	
	new_asteroid.position = Vector2(randf_range(-200, -100), randf_range(-200, -100))
	# 새로운 소행성 위치 설정
	get_parent().add_child(new_asteroid)
	# 새로운 소행성 부모 노드에 추가
