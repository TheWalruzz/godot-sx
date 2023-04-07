extends RefCounted


var dispose_callback: Callable


func clone() -> Sx.Operator:
	return null


func evaluate(_args: Array[Variant]) -> Sx.OperatorResult:
	push_error("Not implemented")
	return null
