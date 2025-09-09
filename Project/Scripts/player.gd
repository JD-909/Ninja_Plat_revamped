extends CharacterBody2D
class_name PlayerCharacter

var SPEED : float = 300
var JUMP_FORCE : float = -400
var MAX_LIVES : int = 4
var gravity : float = 980
var extra_jumps : int
var direction: int

var main_sm : LimboHSM

@export var platform_drop_distance : float = 1
@export var element_name : String
@export var max_extra_jumps : int = 1
@export var checkpoint_position = Vector2(0,0)

#La funcion _ready se corre cuando se carga la escena.
func _ready() -> void:
	checkpoint_position = position
	initiate_state_machine()

#La funcion _physics_process se corre todos los frames. De hecho, delta es el tiempo transcurrido entre frames.
func _physics_process(delta: float) -> void:
	
	#Gravedad, aceleracion hacia abajo
	velocity.y += gravity*delta
	

	#Para el salto
	if Input.is_action_pressed("Down_key") and Input.is_action_just_pressed("Jump_key"):				#esta linea de aca nos permite bajar de las plataformas finitas.
		position.y += platform_drop_distance
	elif Input.is_action_just_pressed("Jump_key") and extra_jumps > 0:
		main_sm.dispatch(&"to_jump")
	#Tip: pueden crear sus propios inputs en Proyecto/Project settings/Mapa de entrada/Agregar accion nueva
	
	#Para resetear los saltos multiples
	if is_on_floor():
		extra_jumps = max_extra_jumps
	
	#Para el movimiento del jugador
	direction = Input.get_axis("Left_key", "Right_key")
	velocity.x = direction * SPEED
	#Tip: si su juego no tiene gravedad, pueden usar "Inpt.get_vector", que es un Vector2 y darle las 4 direcciones (LEFT,RiGHT,UP,DOWN)
	
	#para que el spirte se gire con el jugador
	flip_sprite(direction)
	
	#No se olviden del move_and_slide()
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack_key"):
		main_sm.dispatch(&"to_attack")

func initiate_state_machine():
	main_sm = LimboHSM.new()
	add_child(main_sm)
	
	#var _state = LimboState.new().named("").call_on_enter(_start).call_on_update(_update)
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var jump_state = LimboState.new().named("jump").call_on_enter(jump_start).call_on_update(jump_update)
	var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
	
	main_sm.add_child(idle_state)
	main_sm.add_child(walk_state)
	main_sm.add_child(jump_state)
	main_sm.add_child(attack_state)
	
	main_sm.initial_state = idle_state
	
	main_sm.add_transition(idle_state, walk_state, &"to_walk")
	main_sm.add_transition(main_sm.ANYSTATE, idle_state, &"state_ended")
	main_sm.add_transition(main_sm.ANYSTATE, jump_state, &"to_jump")
	main_sm.add_transition(jump_state, jump_state, &"to_jump")
	main_sm.add_transition(main_sm.ANYSTATE, attack_state, &"to_attack")
	
	main_sm.initialize(self)
	main_sm.set_active(true)

func idle_start():
	$Sprite2D.play("idle")
func idle_update(delta: float):
	if velocity.x != 0:
		main_sm.dispatch(&"to_walk")

func walk_start():
	$Sprite2D.play("walk")
func walk_update(delta: float):
	if velocity.x == 0:
		main_sm.dispatch(&"state_ended")

func jump_start():
	$Sprite2D.play("jump")
	extra_jumps -= 1
	velocity.y = JUMP_FORCE
func jump_update(delta: float):
	if is_on_floor():
		main_sm.dispatch(&"state_ended")

func attack_start():
	$Sprite2D.play("attack")
func attack_update(delta: float):
	pass

func flip_sprite(dir : int):
	if dir == -1:
		$Sprite2D.flip_h = true
		$Sprite2D.position.x = 4
	elif dir == 1:
		$Sprite2D.flip_h = false
		$Sprite2D.position.x = -4

#Esta funcion no la llama nunca el jugador, son los enemigos los que le dicen al jugador que se haga daño. 
func die() -> void:
	global_position = checkpoint_position
	velocity = Vector2(0,0)


func _on_sprite_2d_animation_finished() -> void:
	if $Sprite2D.animation == "attack":
		main_sm.dispatch(&"state_ended")
