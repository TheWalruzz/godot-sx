# Signal Extensions (Sx) for Godot 4

Have you ever wanted to do more things with Godot's signals? Maybe merge them or filter them Rx-style?
Then Signal Extensions (or Sx for short) are for you. This simple and lightweight library allows you to do basic operations on regular Signals
and treat them like reactive-ish streams. 

*DISCLAIMER: This addon is NOT an Rx implementation. Therefore, it does not, nor will it ever, implement all the functionality and operators of Rx.
If you need a proper Rx implementation for Godot 4, see this excellent project: [GodotRx](https://github.com/Neroware/GodotRx) that Sx is largely inspired by.*

## Motivation
The main goal of this library is to allow for more advanced signal handling in Godot.
This is usually done by an Rx framework (like GodotRx mentioned above or UniRx in Unity), but both those solutions are pretty big due to the sheer scale of mechanisms needed for pure Rx to work.
Godot's built-in signal system is robust, but could really profit from reactive approach, which works pretty well with games, where a lot of components interact with each other.
Instead of including a big and complex Rx solution, why not extend the existing mechanism?
Sx allows for signal manipulation that feels like Rx, without all the overhead.

## Installation
* Copy `addons/signal_extensions` directory to the `/addons/` directory in your project
* In your Project Settings, go to Plugins tab and enable `SignalExtensions` plugin.
* You're done! You can now access `Sx` singleton in your code!


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
By default, subscriptions will be disposed of when base signal becomes inactive (i.e. Node is exitting a scene tree), which is regular behavior for signals in Godot.
However, you might want to dispose of them earlier or when the calling Node exits the tree.
`subscribe()` method returns a SxDisposable object which allows for:
* manual subscription disposal (and subsequent disconnection from signal) using `dispose()`
* automatic disposal when Node is exitting the scene tree using `dispose_with(Node)`

```gdscript
extends Node

func _ready() -> void:
	Sx.from(some_other_node.my_signal).subscribe(func(): pass).dispose_with(self)
```

### All available operators
* delay
* element_at
* filter
* first
* map
* skip
* skip_while
* take_while

Please note that full implementation of all Rx operators is NOT a goal of this library.
If you have a more complex problem that cannot be solved with Sx, then use GodotRx instead.

# License
Distributed under the [MIT License](https://github.com/TheWalruzz/godot-sx/blob/main/LICENSE).
