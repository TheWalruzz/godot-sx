extends SxDisposable
class_name SxCompositeDisposable


var _disposables: Array[SxDisposable] = []


func append(disposable: SxDisposable) -> void:
	_disposables.append(disposable)


func dispose() -> void:
	if not is_disposed:
		for disposable in _disposables:
			disposable.dispose()
		is_disposed = true
