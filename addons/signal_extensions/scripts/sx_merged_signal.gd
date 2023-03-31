extends SxSignal
class_name SxMergedSignal


var _signals: Array[SxSignal]
var _disposables: Array[SxDisposable] = []


func _init(signals: Array[SxSignal]):
	_signals = signals
	
	
func _clone() -> SxSignal:
	return SxMergedSignal.new(_signals)


func _subscribe(callback: Callable, variadic := true) -> SxDisposable:
	for input_signal in _signals:
		var disposable = input_signal.subscribe(func(args: Array[Variant]): _handle_signal(callback, args, variadic), false)
		_disposables.append(disposable)
	
	return SxDisposable.new(_dispose)
	
	
func _dispose() -> void:
	for disposable in _disposables:
		disposable.dispose()
