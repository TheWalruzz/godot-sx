extends SxOperator
class_name SxMapOperator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	
	
func clone() -> SxOperator:
	return SxMapOperator.new(_callable)


func evaluate(args: Array[Variant]) -> SxOperatorResult:
	var result = _callable.callv(args)
	return SxOperatorResult.new(true, result if is_instance_of(result, TYPE_ARRAY) else [result])
