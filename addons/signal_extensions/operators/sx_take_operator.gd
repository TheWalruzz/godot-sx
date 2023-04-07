extends Sx.Operator


var _target_item_count: int
var _count := 0


func _init(target_item_count: int):
	_target_item_count = target_item_count
	
	
func clone() -> Sx.Operator:
	return Sx.TakeOperator.new(_target_item_count)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	_count += 1
	if _count >= _target_item_count:
		dispose_callback.call()
		if _target_item_count == 0:
			return Sx.OperatorResult.new(false, args)
	return Sx.OperatorResult.new(true, args)
