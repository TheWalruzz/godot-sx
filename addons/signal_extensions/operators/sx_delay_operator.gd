extends Sx.Operator


var _delay: float
var _process_always: bool
var _process_in_physics: bool
var _ignore_timescale: bool


func _init(delay: float, process_always: bool, process_in_physics: bool, ignore_timescale: bool):
	_delay = delay
	_process_always = process_always
	_process_in_physics = process_in_physics
	_ignore_timescale = ignore_timescale
	
	
func clone() -> Sx.Operator:
	return Sx.DelayOperator.new(_delay, _process_always, _process_in_physics, _ignore_timescale)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	await Sx.get_tree().create_timer(_delay, _process_always, _process_in_physics, _ignore_timescale).timeout
	return Sx.OperatorResult.new(true, args)
