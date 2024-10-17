extends CanvasLayer
signal  start_game
signal  exit_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$getLabel.hide()
	$lostLabel.hide()
	$LVLabel.hide()
	$Message.hide()
	$BackHpmeB.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass


func start_games():
	$StartB.hide()
	$ExitB.hide()
	$getLabel.text="中: 0"
	$lostLabel.text="0 :丢"
	$LVLabel.text="1"
	$getLabel.show()
	$lostLabel.show()
	$LVLabel.show()
	start_game.emit()
	return 0
	
func exit_games():
	exit_game.emit()
	get_tree().quit()
	return 0


func _on_start_b_button_up():
	start_games()
	return 0


func _on_exit_b_button_up():
	exit_games()
	return 0



func game_over_show(time_v,LV_v,get_v,get_null_v,lost_v,fast_v,fast_p,slow_v,slow_p):
	$game_over.play()
	$getLabel.hide()
	$lostLabel.hide()
	$LVLabel.hide()
	$Message.text = "总用时： " + str(time_v) +" 秒
		达到难度等级： " + str(LV_v)+" 级
		成功点击： "+ str(get_v)+" 次
		点击失败： "+ str(get_null_v)+" 次
		丢失目标： "+ str(lost_v)+" 次
		提前点击： "+ str(fast_v)+" 次
		平均提前： "+ str(fast_p)+" ms
		滞后点击： "+ str(slow_v)+" 次
		平均滞后： "+ str(slow_p)+" ms"
	await get_tree().create_timer(0.3).timeout
	$Message.show()
	await get_tree().create_timer(0.6).timeout
	$BackHpmeB.show()
	return 0
	
func back_home():
	$Message.hide()
	$BackHpmeB.hide()
	$StartB.show()
	$ExitB.show()
	return 0


func _on_back_hpme_b_button_up():
	back_home()
	return 0
