extends SxOperator
class_name SxSkipWhileOperator


var _callable: Callable
var _is_skipping := true


func _init(callable: Callable):
	_callable = callable
	
	
func clone() -> SxOperator:
	return SxSkipWhileOperator.new(_callable)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	if _is_skipping and not _callable.callv(args):
		_is_skipping = false
	return SxOperatorResult.new(not _is_skipping, args)
