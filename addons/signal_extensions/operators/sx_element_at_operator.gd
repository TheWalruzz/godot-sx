extends Sx.Operator


var _element_index: int
var _current_index := 0


func _init(element_index: int):
	_element_index = element_index
	
	
func clone() -> Sx.Operator:
	return Sx.ElementAtOperator.new(_element_index)


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	var result := Sx.OperatorResult.new(_current_index == _element_index, args)
	if _current_index == _element_index:
		dispose_callback.call()
	_current_index += 1
	return result
