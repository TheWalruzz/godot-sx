extends SxOperator
class_name SxSkipOperator


var _target_item_count: int
var _count := 0


func _init(target_item_count: int):
	_target_item_count = target_item_count
	
	
func clone() -> SxOperator:
	return SxSkipOperator.new(_target_item_count)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	_count += 1
	return SxOperatorResult.new(_count > _target_item_count, args)
