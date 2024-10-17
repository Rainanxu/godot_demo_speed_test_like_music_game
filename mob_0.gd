#extends RigidBody2D
extends Area2D

signal get_area
signal lost_area
signal faster_area
signal slower_area
signal get_signal

var where_p=0
var pon_times=0
var clicked=0
var speed=400
var time_gos=0
var time_get=0
var time_less=0
var time_start=false

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.set_block_signals(true)
	#self.is_blocking_signals()
	#self.block=true
	#get_A.emit()
	#lost_A.emit()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity=Vector2.ZERO
	velocity.y += 1
	velocity=velocity.normalized()*speed
	position += velocity * delta
	if time_start:
		time_gos += 17
	return 0

#signal  input_ed
#var test_v=0
#func _input(event):
	#if event is InputEventScreenTouch:
	#	test_v=1
	#	Viewport.set_input_as_handled()
	#return 0

#func _unhandled_input(InputEventScreenTouch) -> void:
#	_on_touch_screen_button_pressed()

#func _unhandled_input(event: InputEvent):
#	#tEvent.set_input_as_handled()
#	aero_pressed()
#	get_viewport().set_input_as_handled()
#	return 0

#func _input(event):
	#print(event.as_text())
#	if event == InputEventScreenTouch:
#		print(event.as_text())
#		aero_pressed()
#		get_viewport().set_input_as_handled()

func _on_visible_on_screen_notifier_2d_screen_exited():
	if clicked==0:
		lost_area.emit()
	await get_tree().create_timer(1.0).timeout
	queue_free()
	return 0
	

func set_type(where_in,speed_in):
	where_p=where_in
	speed=speed_in
	return 0

func set_speed(speed_in):
	speed=speed_in
	return 0

func play_M():
	var M_P=[$sound/m0,$sound/m1,$sound/m2,$sound/m3,$sound/m4]
	M_P[where_p].play()
	#$sound/m0.play()
	return 0
	

func chack_click():
	time_less=time_gos
	if pon_times<=1:
		await get_signal
		time_start=false
		time_less=time_get-time_less
		faster_area.emit(time_less)
	else :
		time_start=false
		time_less=time_less-time_get
		slower_area.emit(time_less)
	return 0

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	#get_viewport().set_input_as_handled()
	time_start=true
	pon_times+=1
	if pon_times==2:
		time_get=time_gos
		get_signal.emit()
		play_M()
	if pon_times==3:
		time_start=false
	return 0
	
	

func _on_touch_screen_button_pressed():
	if pon_times<=0:
		return -1
	if pon_times>=3:
		return -2
	if clicked==0:
		clicked=1
		get_area.emit()
		chack_click()
		$AnimatedSprite2D.play()
	return 0
	
	
#func aero_pressed():
#	if pon_times<=0:
#		return -1
#	if clicked==0:
#		clicked=1
#		get_area.emit()
#		chack_click()
#		$AnimatedSprite2D.play()
#	return 0
