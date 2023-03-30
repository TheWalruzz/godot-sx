extends SxOperator
class_name SxFirstOperator


func clone() -> SxOperator:
	return SxFirstOperator.new()


func evaluate(args: Array[Variant]) -> SxOperatorResult:
	var result := SxOperatorResult.new(true, args)
	done_callback.call()
	return result
