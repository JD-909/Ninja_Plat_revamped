extends CharacterBody2D
class_name PlayerCharacter

var SPEED : float = 300
var JUMP_FORCE : float = -400
var MAX_LIVES : int = 4
var gravity : float = 980
var extra_jumps : int
var direction: int

@export var platform_drop_distance : float = 1
@export var element_name : String
@export var max_extra_jumps : int = 1
@export var checkpoint_position = Vector2(0,0)

#La funcion _ready se corre cuando se carga la escena.
func _ready() -> void:
	checkpoint_position = position

#La funcion _physics_process se corre todos los frames. De hecho, delta es el tiempo transcurrido entre frames.
func _physics_process(delta: float) -> void:
	
	#Gravedad, aceleracion hacia abajo
	velocity.y += gravity*delta
	

	#Para el salto
	if Input.is_action_pressed("Down_key") and Input.is_action_just_pressed("Jump_key"):				#esta linea de aca nos permite bajar de las plataformas finitas.
		position.y += platform_drop_distance
	elif Input.is_action_just_pressed("Jump_key") and extra_jumps > 0:
		extra_jumps -= 1
		velocity.y = JUMP_FORCE
	#Tip: pueden crear sus propios inputs en Proyecto/Project settings/Mapa de entrada/Agregar accion nueva
	
	
	if is_on_floor():
		extra_jumps = max_extra_jumps
	
	#Para el movimiento del jugador
	if Input.is_action_pressed("Left_key"):
		direction = -1
		$Sprite2D.flip_h = true
		$Sprite2D.position.x = 4
		$Sprite2D.play("walk")
	elif Input.is_action_pressed("Right_key"):
		direction = 1
		$Sprite2D.flip_h = false
		$Sprite2D.position.x = -4
		$Sprite2D.play("walk")
	else: 
		direction = 0
		$Sprite2D.play("idle")
	velocity.x = direction * SPEED
	#Tip: si su juego no tiene gravedad, pueden usar "Inpt.get_vector", que es un Vector2 y darle las 4 direcciones (LEFT,RiGHT,UP,DOWN)
	
	#No se olviden del move_and_slide()
	move_and_slide()

#Esta funcion no la llaa nunca el jugador, son los enemigos los que le dicen al jugador que se haga daño. 
func die() -> void:
	global_position = checkpoint_position
	velocity = Vector2(0,0)
