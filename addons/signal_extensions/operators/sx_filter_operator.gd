extends Sx.Operator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	return Sx.OperatorResult.new(_callable.callv(args), args)
