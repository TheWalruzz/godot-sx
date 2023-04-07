extends Sx.Operator


var _callable: Callable
var _is_skipping := true


func _init(callable: Callable):
	_callable = callable
	
	
func clone() -> Sx.Operator:
	return Sx.SkipWhileOperator.new(_callable)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	if _is_skipping and not _callable.callv(args):
		_is_skipping = false
	return Sx.OperatorResult.new(not _is_skipping, args)
