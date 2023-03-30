extends SxOperator
class_name SxElementAtOperator


var _element_index: int
var _current_index := 0


func _init(element_index: int):
	_element_index = element_index
	
	
func clone() -> SxOperator:
	return SxElementAtOperator.new(_element_index)


func evaluate(args: Array[Variant]) -> SxOperatorResult:
	var result := SxOperatorResult.new(_current_index == _element_index, args)
	if _current_index == _element_index:
		done_callback.call()
	_current_index += 1
	return result
