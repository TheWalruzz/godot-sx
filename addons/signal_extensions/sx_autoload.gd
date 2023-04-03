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


## Starts a periodic timer that emits a signal every [b]interval[/b].
## For more information about [b]process_callback[/b], see [class Timer].
func interval_timer(
	interval: float,
	process_mode: Node.ProcessMode = Node.PROCESS_MODE_INHERIT,
	process_callback: Timer.TimerProcessCallback = Timer.TIMER_PROCESS_IDLE
) -> SxSignal:
	var timer_node := Timer.new()
	timer_node.autostart = true
	timer_node.wait_time = interval
	timer_node.process_mode = process_mode
	timer_node.process_callback = process_callback
	add_child(timer_node)
	return SxTimerSignal.new(timer_node)
