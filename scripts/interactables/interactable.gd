extends Node
class_name Interactable

@export var interact_text = ""

# Must be used on a StaticBody3D
# CollisionShape3D must use collision layers 2

func interact(player): pass
func get_interact_text() -> String: return interact_text
