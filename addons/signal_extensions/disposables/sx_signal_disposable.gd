extends SxDisposable


var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	
	
func dispose() -> void:
	if not is_disposed:
		_callable.call()
		is_disposed = true
