extends Sx.Operator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	
	
func clone() -> Sx.Operator:
	return Sx.TakeWhileOperator.new(_callable)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	if not _callable.callv(args):
		dispose_callback.call()
		return Sx.OperatorResult.new(false, args)
	return Sx.OperatorResult.new(true, args)
