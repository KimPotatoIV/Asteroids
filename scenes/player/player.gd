extends CharacterBody2D

##################################################
const MOVING_SPEED: float = 300.0
# 이동 속도
const MOVING_ACC: float = 600.0
const MOVING_DEC: float = 300.0
# 이동 가속도 및 감속도
const ROTATION_SPEED: float = 3.0
# 회전 속도
const ROTATION_ACC: float = 6.0
const ROTATION_DEC: float = 3.0
# 회전 가속도 및 감속도

var current_m_speed: float = 0.0
# 현재 이동 속도
var current_r_speed: float = 0.0
# 현재 회전 속도
var direction: Vector2 = Vector2.UP
# 현재 플레이어 방향
var is_left: bool = true
# 어느 쪽으로 회전 하는지 확인

var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")
# 총알 씬 미리 로드

##################################################
func _ready() -> void:
	add_to_group("Player")
	# Player 그룹에 추가
	SignalBus.connect("player_damaged", Callable(self, "_on_player_damaged"))
	# SignalBus의 player_damaged 발산 신호와 _on_player_damaged 함수 연결

##################################################
func _physics_process(delta: float) -> void:
	direction = Vector2.UP.rotated(rotation)
	# 현재 회전 각도에 따라 방향 설정
	
	if not GameManager.get_game_over():
		player_movement(delta)
		player_rotation(delta)
		fire_bullet()
	# 게임 오버가 아닐 때 플레이어 움직임, 회전, 총알 발사 처리
	else:
		init_game(delta)
	# 게임 오버일 때 게임 초기화 처리
	
	velocity = direction * current_m_speed
	move_and_slide()
	# 플레이어 이동 처리
	
	wrap_around_screen()
	# 화면 밖으로 나가면 반대편에서 나타나도록 하는 함수

##################################################
func player_movement(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		current_m_speed = min(current_m_speed + MOVING_ACC * delta, MOVING_SPEED)
		$AnimatedSprite2D.play("booster")
	# 위 방향키를 누르면 이동 가속 및 booster 애니메이션 재생
	else:
		current_m_speed = max(current_m_speed - MOVING_DEC * delta, 0)
		$AnimatedSprite2D.play("idle")
	# 위 방향키를 놓으면 이동 감속 및 idle 애니메이션 재생

##################################################
func player_rotation(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_player(delta, true)
	# 좌 방향키를 누르면 좌로 회전
	elif Input.is_action_pressed("ui_right"):
		rotate_player(delta, false)
	# 우 방향키를 누르면 우로 회전
	else:
		current_r_speed = max(current_r_speed - ROTATION_DEC * delta, 0)
		if is_left:
			rotation -= current_r_speed * delta
		else:
			rotation += current_r_speed * delta
		# 좌 및 우 방향키를 놓으면 회전하던 방향에 따라 감속 회전

##################################################
func init_game(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
	# 스페이스를 누르면 게임 초기화
		GameManager.set_game_over(false)
		GameManager.set_score(0)
		global_position = Vector2(960, 640)
		current_m_speed = 0.0
		current_r_speed = 0.0
		$CollisionPolygon2D.disabled = false
		rotation = 0.0
		# 게임 오버 여부, 점수, 위치, 이동 및 회전 가속도, 방향, 플레이어 충돌 활성화
		for asteroid in get_tree().get_nodes_in_group("Asteroid"):
			asteroid.queue_free()
		# Asteroid 그룹에 속한 노드를 찾아서 모두 제거
	else:
		$CollisionPolygon2D.disabled = true
	# 게임 오버 동안 플레이어 충돌 비활성화

##################################################
func rotate_player(delta: float, left: bool) -> void:
	current_r_speed = min(current_r_speed + ROTATION_ACC * delta, ROTATION_SPEED)
	# 회전 가속
	if left:
		rotation -= current_r_speed * delta
		is_left = true
	else:
		rotation += current_r_speed * delta
		is_left = false
	# 좌 우로 각각 회전

##################################################
func fire_bullet() -> void:
	if Input.is_action_just_pressed("ui_accept"):
	# 스페이스를 누르면 총알 발사
		var bullet_instance: Node2D = bullet_scene.instantiate()
		# 총알 인스턴스 생성
		bullet_instance.position = global_position
		bullet_instance.rotation = rotation
		# 총알 위치 및 방향 설정
		get_parent().add_child(bullet_instance)
		# 총알을 부모 노드에 추가
		$FireAudioPlayer.play()
		# 총알 발사 소리 재생

##################################################
func wrap_around_screen() -> void:
	var screen_size: Vector2 = Vector2(1920, 1080)
	# 화면 크기 벡터 설정
	position.x = fmod(position.x + screen_size.x, screen_size.x)
	# X축 경계 처리
	position.y = fmod(position.y + screen_size.y, screen_size.y)
	# Y축 경계 처리

##################################################
func _on_player_damaged() -> void:
# 플레이어가 소행성과 충돌하면
	GameManager.set_game_over(true)
	# 게임 오버 설정	
	$AnimatedSprite2D.play("damaged")
	# damaged 애니메이션 재생
	if not $DamagedAudioPlayer.playing:
		$DamagedAudioPlayer.play()
	# DamagedAudioPlayer가 재생 중이 아니면 충돌 소리 재생
