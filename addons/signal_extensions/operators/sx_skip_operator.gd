extends Sx.Operator


var _target_item_count: int
var _count := 0


func _init(target_item_count: int):
	_target_item_count = target_item_count
	
	
func clone() -> Sx.Operator:
	return Sx.SkipOperator.new(_target_item_count)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	_count += 1
	return Sx.OperatorResult.new(_count > _target_item_count, args)
