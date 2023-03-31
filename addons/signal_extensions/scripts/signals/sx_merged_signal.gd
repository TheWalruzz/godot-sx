extends SxSignal
class_name SxMergedSignal


var _signals: Array[SxSignal]
var _composite_disposable := SxCompositeDisposable.new()


func _init(signals: Array[SxSignal]):
	_signals = signals
	
	
func _clone() -> SxSignal:
	return SxMergedSignal.new(_signals)


func _subscribe(callback: Callable, variadic := true) -> SxDisposable:
	for input_signal in _signals:
		input_signal.subscribe(func(args: Array[Variant]): _handle_signal(callback, args, variadic), false) \
			.dispose_with(_composite_disposable)
	
	return SxSignalDisposable.new(_composite_disposable.dispose)
