extends RigidBody2D

##################################################
const BULLET_SPEED: float = 700.0
# 총알 이동 속도
var velocity: Vector2 = Vector2.ZERO
# 총알 속도 & 방향 벡터 초기화

##################################################
func _ready() -> void:
	add_to_group("Bullet")
	# Bullet 그룹에 추가
	velocity = Vector2.UP.rotated(rotation) * BULLET_SPEED
	# 총알의 방향과 속도 설정

##################################################
func _physics_process(delta: float) -> void:
	linear_velocity = velocity
	# 물리 엔진에 velocity를 적용
	
	if is_out_of_screen():
		queue_free()
	# 화면을 벗어나면 제거

##################################################
func is_out_of_screen() -> bool:
	var screen_size: Vector2 = Vector2(1920.0, 1080.0)
	# 화면 크기 설정
	return position.x < 0 or position.x > screen_size.x or \
		position.y < 0 or position.y > screen_size.y
	# 총알이 화면을 벗어났는지 여부 반환
