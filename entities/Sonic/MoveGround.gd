extends BasicState


const GROUND_DRAG_MODIFIER = 15.0

func ApplyDrag(velocity: Vector3, delta: float) -> Vector3:
	velocity = velocity.move_toward(Vector3.ZERO, GROUND_DRAG_MODIFIER * delta)
	
	return velocity



func IsInputSkidding() -> bool:
	if owner.Controller.InputVelocity.length() > owner.PARAMETERS.SKID_INPUT_MIN:
		var InputDir = owner.velocity.normalized().dot(owner.Controller.InputVelocity.normalized())
		if InputDir < owner.PARAMETERS.SKID_ANGLE_MIN:
			print("Move: Skid ratio: %s" % InputDir)
			return true
		
	return false


func basis_aligned_x(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.x = vector_to_align_with
	basis_to_align.y = basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align


func basis_aligned_y(basis_to_align: Basis, vector_to_align_with: Vector3) -> Basis:
	basis_to_align.y = vector_to_align_with
	basis_to_align.x = -basis_to_align.z.cross(basis_to_align.y)
	basis_to_align = basis_to_align.orthonormalized()
	return basis_to_align
