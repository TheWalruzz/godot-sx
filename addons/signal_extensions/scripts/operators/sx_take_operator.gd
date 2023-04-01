extends SxOperator
class_name SxTakeOperator


var _target_item_count: int
var _count := 0


func _init(target_item_count: int):
	_target_item_count = target_item_count
	
	
func clone() -> SxOperator:
	return SxTakeOperator.new(_target_item_count)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	_count += 1
	if _count >= _target_item_count:
		dispose_callback.call()
		if _target_item_count == 0:
			return SxOperatorResult.new(false, args)
	return SxOperatorResult.new(true, args)
