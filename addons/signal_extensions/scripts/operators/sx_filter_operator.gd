extends SxOperator
class_name SxFilterOperator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable


func evaluate(args: Array[Variant]) -> SxOperatorResult:
	return SxOperatorResult.new(_callable.callv(args), args)
