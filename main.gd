extends Node

@export var mob_scene0: PackedScene
@export var mob_scene1: PackedScene
@export var hud_s: PackedScene

var roads_change=true
var torch_null_chack=true
var L_V_top=40
var twice_top=25
var twice_areo=35
var over_times=50
var create_mob_time_base=0.8
#var create_mob_time_pices=0.08
var speed_base=200
var speed_pices=20
var mob_create_pass_over=6
var mob_create_well_over=10
var mob_create_point_loop_size=50

var L_V=1;
var mob_passed=4

var roads=2
var game_playing=false
var start_time=0
var get_times=0
var lost_times=0
var fast_times=0
var slow_times=0
var speed=400
var mob_less_set_times=0
var fast_time=[0]
var slow_time=[0]
var get_area_unpressed=true
var touch_null=0
var mob_create_point=2
var mob_pass_times=0
var mob_unpass_times=0

func _ready():
	$mob0.queue_free()
	$mob1.queue_free()
	get_y_size()
	return 0


func _process(_delta) -> void:
	pass


func get_y_size():
	var xy_size=0
	xy_size=get_window().size
	set_layout(xy_size)
	return 0

func set_layout(xy_size):
	var x_point=0.1
	var y_get=0
	#if xy_size.x>=721:
	#	x_point=1.0
	#else :
	#	x_point=720.0/xy_size.x
	x_point=720.0/xy_size.x
	y_get=xy_size.y*0.70
	y_get=y_get*x_point
	y_get=y_get as int
	#DMLabel.text="Size:"+str(xy_size)+":"+str(y_get)
	$get.position.y=y_get
	y_get -=13
	$Line_s.position.y=y_get
	y_get +=175
	$Line_e.position.y=y_get
	return 0

func new_game():
	L_V=1
	start_time=0
	if roads_change:
		roads=1
	game_playing=true
	get_times=0
	touch_null=0
	lost_times=0
	fast_times=0
	slow_times=0
	mob_less_set_times=10
	fast_time=[0]
	slow_time=[0]
	get_area_unpressed=true
	touch_null=0
	mob_create_point=2
	mob_pass_times=mob_create_pass_over
	mob_unpass_times=0
	speed_up()
	get_tree().call_group("mob0","queue_free")
	get_tree().call_group("mob1","queue_free")
	get_y_size()
	$HUD/LVLabel.text=str(L_V)
	$MobTimer.wait_time=create_mob_time_base
	$StartTimer.start()
	$ScoreTimer.start()
	new_mob()
	
	
func chack_game_over():
	var chack_v=lost_times
	if torch_null_chack:
		chack_v=chack_v+touch_null
	if(chack_v>=over_times):
		if(game_playing):
			game_playing=false
			game_over()
	return 0
	
func game_over():
	$StartTimer.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$LVTimer.stop()
	$HUD/Message.text="结算中"
	$HUD/Message.show()
	await  get_tree().create_timer(0.5).timeout
	$HUD/Message.hide()
	var fast_time_point=0
	for i in fast_time.size():
		fast_time_point += fast_time[i]
	fast_time_point=fast_time_point / fast_time.size()
	var slow_time_point=0
	for i in slow_time.size():
		slow_time_point += slow_time[i]
	slow_time_point=slow_time_point / slow_time.size()
	$HUD.game_over_show(start_time,L_V,get_times,touch_null,lost_times,fast_times,fast_time_point,slow_times,slow_time_point)
	return 0


func _on_start_timer_timeout():
	$MobTimer.start()
	$LVTimer.start()
	return 0
	
func _on_mob_timer_timeout():
	#speed LV up new is null
	#speed LV up old start
	#if L_V<=6:
	#	if mob_passed==0:
	#		if mob_less_set_times==0:
	#			mob_less_set_times=1
	#			return 0
	#	else :
	#		mob_less_set_times=0
	new_mob()
	return 1

func new_mob():
	#var C_Chouse=randi_range(0,10)
	var C_Chouse=mob_create_point_get(mob_unpass_times,mob_pass_times)
	if C_Chouse:
		mob_pass_times=0
		mob_unpass_times+=1
	else :
		mob_pass_times+=1
		mob_unpass_times=0
		return 0
		
	var type_chouse=randi_range(0,10)
	if type_chouse<=7:
		type_chouse=0
	else:
		type_chouse=1
		
	var where_chouse=new_mob_get_road()
	
	new_mob_creat_mob(type_chouse,where_chouse)
	
	var C_twice=randi_range(0,twice_areo)
	var V_twice=0
	if L_V>=twice_top:
		V_twice=twice_top
	else :
		V_twice=L_V
	if C_twice>=V_twice:
		C_twice=1
	else:
		C_twice=0
	
	if C_twice==0:
		return 1
		
	C_Chouse=mob_create_point_get(mob_unpass_times,mob_pass_times)
	if C_Chouse:
		mob_pass_times=0
		mob_unpass_times+=1
	else :
		mob_pass_times+=1
		mob_unpass_times=0
		return 0
		
	type_chouse=randi_range(0,10)
	if type_chouse<=7:
		type_chouse=0
	else:
		type_chouse=1
		
	var where_chouse_twice=new_mob_get_road(where_chouse)
	if where_chouse_twice==-1:
		return 1
	new_mob_creat_mob(type_chouse,where_chouse_twice)
	return 1
	
	
func new_mob_get_road(used=-1):
	var temp0=0
	if roads == 0:
		if used==-1:
			temp0=0
		else:
			return -1
	if used==-1:
		temp0=randi_range(0,roads)
	else :
		if roads == 1:
			if used==0:
				return 1
			else :
				return 0
		else:
			temp0=randi_range(1,roads - 1)
			temp0=used + temp0
		if temp0 >= roads + 1:
			temp0 = temp0 - roads
	return temp0


func new_mob_creat_mob(type_of,where_at):
	var mob
	if type_of==0:
		mob=mob_scene0.instantiate()
	else:
		mob=mob_scene1.instantiate()
	mob.get_area.connect(get_add)
	mob.lost_area.connect(lost_add)
	mob.faster_area.connect(fast_add)
	mob.slower_area.connect(slow_add)
	var mob_spawn_location=$mobPath2D/mobPathFollow2D
	var velocity = L_V*20 + 200
	mob.set_type(where_at,velocity)
	var parts=roads + 2.0
	var part_v=1.0 / parts
	var where_p=where_at + 1
	var where_v=part_v * where_p
	mob_spawn_location.progress_ratio = where_v
	mob.position = mob_spawn_location.position
	add_child(mob)
	return 1

func mob_create_timeout_new(LV_N):
	var temp0=9 + LV_N
	temp0 = 10.0 / temp0
	temp0 = create_mob_time_base * temp0
	return temp0

func mob_create_roads_add(LV_N):
	var temp0=1
	if LV_N >=35:
		temp0 = 4
	elif LV_N >=25:
		temp0 = 3
	elif LV_N >= 15:
		temp0 = 2
	return temp0
	
func mob_create_point_loop(time_gote):
	var creat_p=6
	var p_area=time_gote % mob_create_point_loop_size
	p_area = p_area * 1.0
	p_area = p_area / mob_create_point_loop_size
	p_area=p_area * 10
	if p_area <= 2:
		creat_p = 2
	elif p_area <= 6:
		creat_p = 5
	elif p_area <= 7:
		creat_p = 8
	mob_create_point=creat_p
	#print("c_p:" + str(time_gote)+":"+str(mob_create_point))
	return 0
	
	
func mob_create_point_get(true_times,false_times):
	var creat_true=false
	if true_times >= mob_create_well_over:
		creat_true = false
		return creat_true
	elif false_times >=mob_create_pass_over:
		creat_true = true
	else :
		var temp0=randi_range(0,10)
		if temp0 <= mob_create_point:
			creat_true=true
	#print("c_p_g:" +str(creat_true)+" tt:"+str(true_times)+" ft"+str(false_times))
	return creat_true
	
func _on_lv_timer_timeout():
	if L_V<L_V_top:
		L_V +=1
		$MobTimer.wait_time=mob_create_timeout_new(L_V)
		if roads_change:
			if L_V%5==0:
				roads=mob_create_roads_add(L_V)
		speed_up()
		$HUD/LVLabel.text=str(L_V)
	return 0

func speed_up():
	speed = L_V * speed_pices + speed_base
	get_tree().call_group("mob0","set_speed",speed)
	get_tree().call_group("mob1","set_speed",speed)
	return 0

func _on_hud_start_game():
	new_game()
	return 0
	
func get_add():
	get_area_unpressed=false
	get_times+=1
	$get/AnimatedSprite2D.play()
	$HUD/getLabel.text="中: "+str(get_times)
	return 0
	
func lost_add():
	lost_times+=1
	$HUD/lostLabel.text=str(lost_times)+" :丢"
	chack_game_over()
	return 0
	
func fast_add(time_l=0):
	var temp_a=[time_l]
	fast_time=fast_time + temp_a
	fast_times+=1
	return 0
	
func slow_add(time_l=0):
	var temp_a=[time_l]
	slow_time=slow_time + temp_a
	slow_times+=1
	return 0
	


func _on_score_timer_timeout():
	start_time += 1
	mob_create_point_loop(start_time)
	return 0

func _on_touch_screen_button_pressed():
	if get_area_unpressed:
		touch_null += 1
	get_area_unpressed=true
	return 0
