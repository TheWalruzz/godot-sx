extends Node


# Sx namespace
const Operator := preload("res://addons/signal_extensions/operators/base/sx_operator.gd")
const OperatorResult := preload("res://addons/signal_extensions/operators/base/sx_operator_result.gd")
const SignalDisposable := preload("res://addons/signal_extensions/disposables/sx_signal_disposable.gd")

const DelayOperator := preload("res://addons/signal_extensions/operators/sx_delay_operator.gd")
const ElementAtOperator := preload("res://addons/signal_extensions/operators/sx_element_at_operator.gd")
const FilterOperator := preload("res://addons/signal_extensions/operators/sx_filter_operator.gd")
const FirstOperator := preload("res://addons/signal_extensions/operators/sx_first_operator.gd")
const MapOperator := preload("res://addons/signal_extensions/operators/sx_map_operator.gd")
const SkipOperator := preload("res://addons/signal_extensions/operators/sx_skip_operator.gd")
const SkipWhileOperator := preload("res://addons/signal_extensions/operators/sx_skip_while_operator.gd")
const TakeOperator := preload("res://addons/signal_extensions/operators/sx_take_operator.gd")
const TakeWhileOperator := preload("res://addons/signal_extensions/operators/sx_take_while_operator.gd")
const DebounceOperator := preload("res://addons/signal_extensions/operators/sx_debounce_operator.gd")
const ThrottleOperator := preload("res://addons/signal_extensions/operators/sx_throttle_operator.gd")

const BasicSignal := preload("res://addons/signal_extensions/signals/sx_basic_signal.gd")
const MergedSignal := preload("res://addons/signal_extensions/signals/sx_merged_signal.gd")
const TimerSignal := preload("res://addons/signal_extensions/signals/sx_timer_signal.gd")


## Creates [SxSignal] from [Signal].
func from(input_signal: Signal) -> SxSignal:
	return Sx.BasicSignal.new(input_signal)


## Merges emissions of multiple [SxSignal] signals.
func merge(signals: Array[SxSignal]) -> SxSignal:
	return Sx.MergedSignal.new(signals)
	

## Merges emissions of multiple [Signal] signals.
func merge_from(signals: Array[Signal]) -> SxSignal:
	var converted_signals: Array[SxSignal] = []
	converted_signals.assign(signals.map(func(input: Signal) -> SxSignal: 
		return Sx.BasicSignal.new(input)
	))
	return merge(converted_signals)


## Starts a periodic timer that emits a signal every [b]interval[/b].
## For more information about [b]process_callback[/b], see [Timer].
func interval_timer(
	interval: float,
	mode: Node.ProcessMode = Node.PROCESS_MODE_INHERIT,
	process_callback: Timer.TimerProcessCallback = Timer.TIMER_PROCESS_IDLE
) -> SxSignal:
	var timer_node := Timer.new()
	timer_node.autostart = true
	timer_node.wait_time = interval
	timer_node.process_mode = mode
	timer_node.process_callback = process_callback
	add_child(timer_node)
	return Sx.TimerSignal.new(timer_node)
