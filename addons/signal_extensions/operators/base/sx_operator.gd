extends RefCounted
class_name SxOperator


var dispose_callback: Callable


func clone() -> SxOperator:
	return null


func evaluate(_args: Array[Variant]) -> SxOperatorResult:
	push_error("Not implemented")
	return null
