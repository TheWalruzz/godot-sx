extends RefCounted
class_name SxDictionaryProperty


enum Type {
	UPDATED_LIST,
	UPDATED,
	ERASED,
	CLEARED,
	COUNT_CHANGED,
}


signal value_changed(type, array, payload)


var _value: Dictionary = {}
var value: Dictionary:
	get: return _value
	
var _last_size := 0
	

func _init(initial_value: Dictionary = {}):
	_value = initial_value
	_last_size = _value.size()
	
	Sx.from(value_changed).filter(func(type: Type, dict: Dictionary, _z):
		return type != Type.COUNT_CHANGED and _last_size != dict.size()
	).subscribe(func(_x, dict: Dictionary, _z): 
		value_changed.emit(Type.COUNT_CHANGED, dict, dict.size())
		_last_size = dict.size()
	)
	
	
func clear() -> void:
	_value.clear()
	value_changed.emit(Type.CLEARED, _value, null)
	
	
func erase(item: Variant) -> void:
	_value.erase(item)
	value_changed.emit(Type.ERASED, _value, item)


func get_value(key: Variant, default: Variant = null) -> Variant:
	if not has(key):
		return default
	return _value[key]
	
	
func has(item: Variant) -> bool:
	return _value.has(item)
	
	
func merge(dictionary: Dictionary, overwrite: bool = false) -> void:
	_value.merge(dictionary, overwrite)
	value_changed.emit(Type.UPDATED_LIST, _value, dictionary)
	
	
	
func set_value(key: Variant, item: Variant) -> void:
	_value[key] = item
	value_changed.emit(Type.UPDATED, _value, key)
	
	
func size() -> int:
	return _value.size()
	

## Observes every type of event with [enum Type] in the [SxDictionaryProperty].
## [b]emit_initial_value[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](Type, dictionary, payload).
func as_signal(emit_initial_value := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with(func(): return [Type.UPDATED_LIST, _value, _value])
	return result
	

## Observes specific event with [enum Type]
## Returns [SxSignal](dictionary, payload).
func observe(event: Type) -> SxSignal:
	return as_signal().filter(func(type: Type, _y, _z): return type == event) \
		.map(func(_x, dict: Dictionary, payload: Variant): return [dict, payload])

