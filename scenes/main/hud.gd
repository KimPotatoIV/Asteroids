extends CanvasLayer

##################################################
var hud_score: int = 0
# 잦은 HUD 업데이트를 막기 위한 지역 변수 점수 초기화

##################################################
func _process(delta: float) -> void:
	var current_score = GameManager.get_score()
	# 현재 게임 점수 변수 초기화
	if hud_score != current_score:
	# 현재 게임 점수와 지역 변수 점수가 다르면
		hud_score = current_score
		# 지역 변수 점수 업데이트
		$Score.text = str(hud_score).pad_zeros(5)
		# 5자리 숫자로 패딩하여 Score 라벨에 표시

	$Start.visible = GameManager.get_game_over()
	# 게임 오버 상태에 따라 Start 라벨 가시성 설정
