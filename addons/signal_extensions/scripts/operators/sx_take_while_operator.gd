extends SxOperator
class_name SxTakeWhileOperator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	
	
func clone() -> SxOperator:
	return SxTakeWhileOperator.new(_callable)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	if not _callable.callv(args):
		dispose_callback.call()
		return SxOperatorResult.new(false, args)
	return SxOperatorResult.new(true, args)
