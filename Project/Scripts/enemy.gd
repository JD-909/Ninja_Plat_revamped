extends CharacterBody2D

var SPEED : float = 100
var direction = 1
var rc_left_floor : RayCast2D			#detecta el piso a la izquierda.
var rc_right_floor : RayCast2D			#detecta el piso a la derecha.
var rc_left_player : RayCast2D
var rc_right_player : RayCast2D
var gravity : float = 980

#La funcion _ready se corre cuando se carga la escena.
func _ready() -> void:
	rc_left_floor = $LeftCast
	rc_right_floor = $RightCast
	rc_left_player = $LeftJumpCast
	rc_right_player = $RightJumpCast

#La funcion _physics_process se corre cada frame.
func _physics_process(delta: float) -> void:
	
	velocity.x = direction*SPEED
	velocity.y += gravity*delta
	
	if is_on_floor():
		if direction > 0 and (not rc_right_floor.is_colliding() or is_on_wall()):
			direction = -direction
			position.x -= 2
		elif direction < 0 and (not rc_left_floor.is_colliding() or is_on_wall()):
			direction = -direction
			position.x += 2
	
	if is_on_floor() and (rc_left_player.is_colliding() or rc_right_player.is_colliding()):
		velocity.y = -500
	
	move_and_slide()


func die() -> void:
	queue_free()

#Si entra el jugador a el area, le hace daño
func _on_hit_box_body_entered(body: Node2D) -> void:
	body.die()
