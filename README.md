# Signal Extensions (Sx) for Godot 4

Have you ever wanted to do more things with Godot's signals? Maybe merge them or filter them Rx-style?
Then Signal Extensions (or Sx for short) are for you. This simple and lightweight library allows you to do basic operations on regular Signals
and treat them like reactive-ish streams. 

*DISCLAIMER: This addon is NOT an Rx implementation. Therefore, it does not, nor will it ever, implement all the functionality and operators of Rx.
If you need a proper Rx implementation for Godot 4, see this excellent project: [GodotRx](https://github.com/Neroware/GodotRx) that Sx is largely inspired by.*

## Motivation
The main goal of this library is to allow for more advanced signal handling in Godot.

Godot's built-in signal system is robust, but could really profit from reactive approach, which works pretty well with games. Especially when a lot of components interact with each other.

Those kind of manipulations could be done by an Rx framework (like GodotRx mentioned above), but this means including a package, that due to the sheer scale of mechanisms needed for pure Rx to work, is really big and bloated for use cases you might actually encounter in your code.

Instead of including a big and complex Rx solution, why not extend the existing mechanism?

Sx allows for signal manipulation that feels like Rx, without all the overhead.

## Installation
* Copy `addons/signal_extensions` directory to the `/addons/` directory in your project
* You're done! You now have access to static Sx class!


## Basic usage
In order to perform operations on signals, they have to be converted to SxSignal:
	
```gdscript
signal my_signal

var my_wrapped_signal := Sx.from(my_signal)
```

### Subscription
To subscribe to emissions, use `.subscribe(Callable)`:
	
```gdscript
signal my_signal

Sx.from(my_signal).subscribe(func(): print("Got it!"))
my_signal.emit()

# result:
# 	Got it!
```

### Filtering and mapping
You can filter and map emitted items much like in regular Rx implementations:

```gdscript
signal value_changed(int)

# multiply only positive numbers by 2
Sx.from(value_changed) \
	.filter(func(value: int): return value > 0) \
	.map(func(value: int): return value * 2) \
	.subscribe(func(value: int): print(value))

value_changed.emit(-2)
value_changed.emit(-1)
value_changed.emit(0)
value_changed.emit(1)
value_changed.emit(2)

# result:
# 	2
# 	4
```

Sx supports signals with up to 6 arguments and they can also be filtered and mapped:

```gdscript
signal multi_values(int, int2)

# when mapping multiple values, array must be returned from lambda
Sx.from(multi_values) \
	.filter(func(value1: int, value2: int): return value2 > value1) \
	.map(func(value1: int, value2: int): return [value2, value1]) \
	.subscribe(func(value1: int, value2: int): print(value1, value2))

multi_values.emit(2, 1)	
multi_values.emit(3, 10)

# result:
#	103
```

Number of arguments down the chain can be freely changed using map:

```gdscript
signal int_values(int)

Sx.from(int_values) \
	.map(func(value: int): return [value, value * 2])
	.subscribe(func(value1: int, value2: int): print(value1, value2))
	
int_values.emit(3)

# result:
#	36
```

### Merging signals
Multiple Godot signals can be merged into one using `Sx.merge_from()`:

```gdscript
signal signal1(int)
signal signal2(int)

Sx.merge_from([signal1, signal2]).subscribe(func(value: int): print(value))
signal1.emit(1)
signal2.emit(2)

# result:
#	1
#	2
```

Multiple SxSignals can also be merged easily using `Sx.merge()`:

```gdscript
signal signal1(int)
signal signal2(int)

Sx.merge([
	Sx.from(signal1).map(func(value: int): return value * 2),
	Sx.from(signal2).map(func(value: int): return value * 3)
]).subscribe(func(value: int): print(value))
signal1.emit(1)
signal2.emit(2)

# result:
#	2
#	6
```

### Subscription disposal
By default, subscriptions will be disposed when base signal becomes inactive (i.e. Node is exitting a scene tree), which is regular behavior for signals in Godot.
However, you might want to dispose them earlier or when the calling Node exits the tree.
`subscribe()` method returns a SxDisposable object which allows for:
* manual subscription disposal (and subsequent disconnection from signal) using `dispose()`
* automatic disposal when Node is exitting the scene tree using `dispose_with(Node)`
* adding disposable to SxCompositeDisposable using `dispose_with(SxCompositeDisposable)`

```gdscript
extends Node

func _ready() -> void:
	Sx.from(some_other_node.my_signal).subscribe(func(): pass).dispose_with(self)
```

Composite disposable:
	
```gdscript
signal test_signal

var composite_disposable := SxCompositeDisposable.new()
Sx.from(test_signal).subscribe(func(): print("First subscription")).dispose_with(composite_disposable)
Sx.from(test_signal).subscribe(func(): print("Second subscription")).dispose_with(composite_disposable)
composite_disposable.dispose()
```

### Signal-based properties
Sometimes, you need to store some values and react when they change. For this reason, Sx provides it's own implementation of Signal-based values, much like ReactiveProperties in GodotRx and UniRx.

```gdscript
var property := SxProperty.new(10)
property.as_signal().subscribe(func(value: int): print(value))
property.value = 15

# result:
#	10
#	15
```

You can also directly access the underlying signal:

```gdscript
property.value_changed.connect(func(value: int): print(value))
```

### On complete callback
When you're subscribing, you can set an optional callback that will be fired when the signal completes (either naturally, or when signal is disposed).

```gdscript
signal numbers(int)

Sx.from(numbers).first().subscribe(
	func(value: int): print(value),
	func(): print("Completed")
)
numbers.emit(5)

# result:
#	5
#	Completed
```

Or:
	
```gdscript
signal numbers(int)

var disposable := Sx.from(numbers).subscribe(
	func(value: int): print(value),
	func(): print("Completed")
)
numbers.emit(5)
disposable.dispose()

# result:
#	5
#	Completed
```

### All available operators
* delay
* element_at
* filter
* first
* map
* merge
* skip
* skip_while
* take
* take_while

Please note that full implementation of all Rx operators is NOT a goal of this library.
If you have a more complex problem that cannot be solved with Sx, then use GodotRx instead.

# License
Distributed under the [MIT License](https://github.com/TheWalruzz/godot-sx/blob/main/LICENSE).
