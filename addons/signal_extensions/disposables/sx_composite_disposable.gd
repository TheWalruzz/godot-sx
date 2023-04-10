extends SxDisposable
class_name SxCompositeDisposable


var _disposables: Array[SxDisposable] = []


## Adds disposable to the list.
func append(disposable: SxDisposable) -> void:
	_disposables.append(disposable)
	

## Returns the number of undisposed signals contained in the composite disposable.
func size() -> int:
	return _disposables \
		.filter(func(disposable: SxDisposable): return not disposable.is_disposed) \
		.size()


func dispose() -> void:
	if not is_disposed:
		for disposable in _disposables:
			disposable.dispose()
		is_disposed = true
