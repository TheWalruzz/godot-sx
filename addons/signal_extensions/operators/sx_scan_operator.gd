extends Sx.Operator


var _callable: Callable
var _state: Variant
var _initial_value: Variant


func _init(callable: Callable, initial_value: Variant):
	_callable = callable
	_initial_value = initial_value
	_state = initial_value
	

func clone() -> Sx.Operator:
	return Sx.ScanOperator.new(_callable, _initial_value)


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	_state = _callable.bindv(args).call(_state)
	return Sx.OperatorResult.new(true, [_state])
