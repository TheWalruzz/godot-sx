extends Node


## Creates [class SxSignal] from [class Signal].
func from(input_signal: Signal) -> SxSignal:
	return SxBasicSignal.new(input_signal)


## Merges emissions of multiple [class SxSignal] signals.
func merge(signals: Array[SxSignal]) -> SxSignal:
	return SxMergedSignal.new(signals)
	

## Merges emissions of multiple [class Signal] signals.
func merge_from(signals: Array[Signal]) -> SxSignal:
	var converted_signals: Array[SxSignal] = []
	converted_signals.assign(signals.map(func(input: Signal) -> SxSignal: 
		return SxBasicSignal.new(input)
	))
	return merge(converted_signals)
