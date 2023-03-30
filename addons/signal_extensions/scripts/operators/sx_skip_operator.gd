extends SxOperator
class_name SxSkipOperator


var _skip_items: int
var _count := 0


func _init(skip_items: int):
	_skip_items = skip_items
	
	
func clone() -> SxOperator:
	return SxSkipOperator.new(_skip_items)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	_count += 1
	return SxOperatorResult.new(_count > _skip_items, args)
