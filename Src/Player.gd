extends actor

onready var parada = $Parada
onready var andando = $andando
onready var pulando = $pulando


func _physics_process(delta: float) -> void:
	var jump_cancel = true if Input.is_action_just_released("UP") and velocidade.y < 0.0 else false
	var direcao = get_input()
	velocidade = cal_velocidade(velocidade, direcao, speedy, jump_cancel)
	animacao(direcao, velocidade)
	velocidade = move_and_slide(velocidade, FLOOR)

func get_input() -> Vector2:
	return Vector2(Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"), 
	-1.0 if Input.get_action_strength("UP") else 1.0)

func cal_velocidade(velocidade, direcao, speed, jump_cancel) -> Vector2:
	var out = velocidade
	out.x = direcao.x * speed.x
	out.y += gravity * get_process_delta_time()
	if direcao.y == -1.0 and is_on_floor():
		out.y = direcao.y * speed.y
	if jump_cancel:
		out.y = 0.0
	return out
	
func animacao(direcao, velocidade):
	if direcao.x != 0:
		parada.scale.x = 1 if direcao.x > 0 else -1
		andando.scale.x = 1 if direcao.x > 0 else -1
		pulando.scale.x = 1 if direcao.x > 0 else -1
	if direcao.x == 0.0:
		parada.visible = true
		andando.visible = false
	else:
		parada.visible = false
		andando.visible = true
	if direcao.y < 0.0:
		parada.visible = false
		andando.visible = false
		pulando.visible = true
		pulando.frame = 0
	if velocidade.y > 0 and not is_on_floor():
		parada.visible = false
		andando.visible = false
		pulando.frame = 1
	if velocidade.y > 0 and is_on_floor():
		pulando.visible = false

