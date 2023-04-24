extends RefCounted
class_name SxDisposable


var is_disposed := false
	

func dispose() -> void:
	pass


## Automatically disposes [SxSignal] when either a [Node] is exitting or [SxCompositeDisposable] disposes.
func dispose_with(source: Variant) -> SxDisposable:
	if not is_disposed:
		if source is SxCompositeDisposable:
			source.append(self)
		elif source is Node:
			source.tree_exiting.connect(dispose, CONNECT_ONE_SHOT)
		else:
			push_error("Trying to call dispose_with() with something different than Node or SxCompositeDisposable.")
	return self
