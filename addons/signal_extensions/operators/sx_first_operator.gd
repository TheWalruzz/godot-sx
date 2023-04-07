extends Sx.Operator


func clone() -> Sx.Operator:
	return Sx.FirstOperator.new()


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	var result := Sx.OperatorResult.new(true, args)
	dispose_callback.call()
	return result
