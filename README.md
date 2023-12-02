# ✨ HyperLog ✨
*For Godot 4 - [Godot 3 version here](https://github.com/GuyUnger/HyperLog/tree/godot-3)*

**HyperLog** allows you to easily track node variables and information on screen.

It allows you to log and graph information while in the game, making debugging much easier.


[![Watch the video](https://img.youtube.com/vi/tZ3UGLp86l8/hqdefault.jpg)](https://youtu.be/tZ3UGLp86l8)


### How to use it in your Project 🤷‍♂️

First step is to download and install the addon either from here or from the Godot Asset library (we recommend using the version here).

After activating the addon in Godot, you will be able to use **HyperLog** via the `HyperLog` global.

### HyperLog for 3D / Spatial nodes

To use **HyperLog in 3D or on Spatial nodes** you need to set the `camera_3d` variable on `HyperLog`:

```swift
HyperLog.camera_3d = $Camera
```
If you don't do that, all logs will be displayed on the top-left corner.


# Example Scenes 

Inside the project, you will find example scenes how **HyperLog** is used in 2D and 3D. We highly recommend checking them out.

# Example

We have a Scene called `Player_Ship` with the following variables in its script:
```swift
extends KinematicBody2D

var position = Vector2(10.241, 282.2035)
var direction = Vector2(-1, 0)
var angle = 1.570796
var health_current = 8
var health_max = 12
var speed = 0.0

onready var ship = self

func _ready():
    ...
```

To use **HyperLog** to track any of these variables (or properties from the class), **add these snippets to your `_ready` function**.

You do not have to add it to `_process` or `_physics_process` or update it in any other way, the changes of the variables are tracked automatically by **HyperLog**.

# Functions available
## Log text
> Displays the **text**: `position:x 10` next to the `ship` node.
```swift
HyperLog.log(ship).text("position:x>round")
```

> Displays the **text**: `direction 3.141593`.
```swift
HyperLog.log(ship).text("direction>angle")
```

> Displays the **text**: `position (10.24, 282.20)` next to `self` (in our example, the ship).
```swift
HyperLog.log(self).text("position>%0.2f")
```

## Log color
> Logs the rotation of the ship's `gun` to the log-panel of the ship.
```swift
HyperLog.log(ship).color("modulate")
```

## Log line-chart / graph
> Draws a line chart **graph** out the x and y `position` of the ship.
```swift
HyperLog.log(ship).graph("position")
```

> Draws a line chart **graph** out of `speed`, rounds it to one decimal and updates it every second frame.
```swift
HyperLog.log(ship).graph("speed>%0.1f").set_steps(2)
```

> Draws a line chart **graph** out the `health`, using `health_max` as the maximum value of the line-chart.
```swift
HyperLog.log(ship).graph("health_current").set_range(0, health_max)
```

## Log angles
> Draws an **angle**-log, a visual angle indicator.
```swift
HyperLog.log(ship).angle(["direction", "angle"])
```

> Draws an **angle**-log of the `rotation` of the ship's `gun` to the log-panel of the `ship`.
```swift
HyperLog.log(ship).angle("rotation", ship.get_node("gun"))
```


## Change the Log Panel position

> Adds an **offset** of (200, -20) to the panel.
```swift
HyperLog.log(ship).offset(Vector2(200, -20))
```

> Will **align** the panel to the right horizontally and to the center vertically.
```swift
HyperLog.log(ship).align(HALIGN_RIGHT, VALIGN_CENTER)
```

> Will display a health line-chart **graph** above the ship.
```swift
HyperLog.log(ship).align(HALIGN_CENTER, VALIGN_BOTTOM).offset(Vector2(0, - 50)).graph("health_current").set_range(0, health_max)
```


# Logging to the top main panel

Alternatively you can log to the main panel by accessing the functions directly from **HyperLog**:

```swift
HyperLog.graph("position", ship)
```

# Drawing Tools / Sketch functions

There are some drawing tools that you can use for additional debugging.

You can call those from anywhere to draw visual debugging elements.

For example calling `HyperLog.sketch_arrow(position, direction, 1)` will draw an arrow on position, direction for one second.

**These draw tools behave differently from the normal HyperLog logging and will not automatically update!**

**You can use them in _process or on certain functions in your game (e.g. display the direction of your projectile when shooting via HyperLog.sketch_line.**

It's best to check out the provided example scenes or the code in the plugin to get a better understanding of those draw tools.

### Sketch Functions reference
> Draw a line from `from` to `to` for `duration` seconds.
```swift
HyperLog.sketch_line(from:Vector2, to:Vector2, duration:float = 0, color:Color = Color.tomato)
```
> Draw an arrow at `position`, pointing to `vector` for `duration` seconds.
```swift
HyperLog.sketch_arrow(position:Vector2, vector:Vector2, duration:float = 0, color:Color = Color.tomato)
```
> Draw a circle at `position` with the radius `radius` for `duration` seconds.
```swift
HyperLog.sketch_circle(position:Vector2, radius:float, duration:float = 0, color:Color = Color.tomato)
```
> Draw a box at `position` with the dimensions `size` for `duration` seconds.
```swift
HyperLog.sketch_box(position:Vector2, size:Vector2, duration:float = 0, color:Color = Color.tomato)
```
> Draw a Rect2 with the data from `rect` for `duration` seconds.
```swift
HyperLog.sketch_rect(rect:Rect2, duration:float = 0, color:Color = Color.tomato)
```
