extends Object
class_name Sx


## Creates [class SxSignal] from [class Signal].
static func from(input_signal: Signal) -> SxSignal:
	return SxBasicSignal.new(input_signal)


## Merges emissions of multiple [class SxSignal] signals.
static func merge(signals: Array[SxSignal]) -> SxSignal:
	return SxMergedSignal.new(signals)
	

## Merges emissions of multiple [class Signal] signals.
static func merge_from(signals: Array[Signal]) -> SxSignal:
	var converted_signals: Array[SxSignal] = []
	converted_signals.assign(signals.map(func(input: Signal) -> SxSignal: 
		return SxBasicSignal.new(input)
	))
	return merge(converted_signals)
