extends SxSignal
class_name SxMergedSignal


var _signals: Array[SxSignal]


func _init(signals: Array[SxSignal]):
	_signals = signals
	
	
func _clone() -> SxSignal:
	return SxMergedSignal.new(_signals)


func _subscribe(callback: Callable, variadic := true) -> SxDisposable:
	var composite_disposable := SxCompositeDisposable.new()
	for input_signal in _signals:
		input_signal.subscribe(func(args: Array[Variant]): _handle_signal(callback, args, variadic), false) \
			.dispose_with(composite_disposable)
	
	return SxSignalDisposable.new(composite_disposable.dispose)
