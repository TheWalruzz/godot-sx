extends RefCounted
class_name SxDisposable


var is_disposed := false

var _callable: Callable


func _init(callable: Callable):
	_callable = callable
	
	
func dispose() -> void:
	if not is_disposed:
		_callable.call()
		is_disposed = true
		
		
func dispose_with(node: Node) -> SxDisposable:
	if not is_disposed:
		node.tree_exiting.connect(dispose)
	return self
