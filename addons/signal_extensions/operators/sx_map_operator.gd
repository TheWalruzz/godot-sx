extends Sx.Operator


var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	

func clone() -> Sx.Operator:
	return Sx.MapOperator.new(_callable)


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	var result = _callable.callv(args)
	return Sx.OperatorResult.new(true, result if is_instance_of(result, TYPE_ARRAY) else [result])
