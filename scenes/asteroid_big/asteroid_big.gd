extends RigidBody2D

##################################################
const MOVING_SPEED: float = 100.0
# 소행성 이동 속도
const MIDDLE_ASTEROID: PackedScene = \
	preload("res://scenes/asteroid_middle/asteroid_middle.tscn")
# 중간 크기 소행성 씬 미리 로드
var velocity: Vector2 = Vector2.ZERO
# 소행성 속도 & 방향 벡터 초기화

##################################################
func _ready() -> void:
	add_to_group("Asteroid")
	# Asteroid 그룹에 추가
	# 게임 초기화 시 Asteroid 그룹 노드를 한 번에 제거하기 위함
	gravity_scale = 0.0
	# 중력 효과 무시
	velocity = \
		Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * MOVING_SPEED
	# 임의의 방향으로 이동하도록 설정
	connect("body_entered", Callable(self, "_on_body_entered"))
	# 다른 물체와 충돌 시 _on_body_entered 함수로 연결

##################################################
func _physics_process(delta: float) -> void:
	linear_velocity = velocity
	# 물리 엔진에 velocity를 적용
	wrap_around_screen()
	# 화면 밖으로 나가면 반대편에서 나타나도록 하는 함수

##################################################
func wrap_around_screen():
	var screen_size: Vector2 = Vector2(1920.0, 1080.0)
	# 화면 크기 벡터 설정
	position.x = fmod(global_position.x + screen_size.x, screen_size.x)
	# X축 경계 처리
	position.y = fmod(global_position.y + screen_size.y, screen_size.y)
	# Y축 경계 처리

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bullet"):
	# 충돌체가 Bullet 그룹에 속할 경우
		SignalBus.emit_asteroid_damaged()
		# SignalBus를 통해 asteroid_damaged 신호 방출
		GameManager.set_score(GameManager.get_score() + 10)
		# 점수 증가
		call_deferred("split_asteroid")
		# 소행성 분할 시 오류 방지를 위해 split_asteroid 함수 지연 호출
		body.queue_free()
		# 총알 제거
		queue_free()
		# 소행성 제거
	elif body.is_in_group("Player"):
	# 충돌체가 Player 그룹에 속할 경우
		SignalBus.emit_player_damaged()
		# SignalBus를 통해 player_damaged 신호 방출

##################################################
func split_asteroid() -> void:
	var asteroid_1: Node2D = MIDDLE_ASTEROID.instantiate()
	var asteroid_2: Node2D = MIDDLE_ASTEROID.instantiate()
	# 새로운 중간 크기 소행성 각각 인스턴스화
	asteroid_1.global_position = position
	asteroid_2.global_position = position
	# 새로운 소행성 각각 위치 설정
	get_parent().add_child(asteroid_1)
	get_parent().add_child(asteroid_2)
	# 새로운 소행성 각각 부모 노드에 추가
