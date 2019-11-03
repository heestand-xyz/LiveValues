# LiveValues

[![License](https://img.shields.io/cocoapods/l/LiveValues.svg)](https://github.com/hexagons/LiveValues/blob/master/LICENSE)
[![Cocoapods](https://img.shields.io/cocoapods/v/LiveValues.svg)](http://cocoapods.org/pods/LiveValues)
[![Platform](https://img.shields.io/cocoapods/p/LiveValues.svg)](http://cocoapods.org/pods/LiveValues)
<img src="https://img.shields.io/badge/in-swift5.0-orange.svg">

## Values

Live values are automatically updated when they have changin values.
Live values are ease to animate with the `.live` or `.seconds` static properites.


## Install

Install with [CocoaPods](https://cocoapods.org).

```ruby
pod 'LiveValues'
```

```swift
import LiveValues
```

### Types:
- `CGFloat` --> `LiveFloat`
- `Int` --> `LiveInt`
- `Bool` --> `LiveBool`
- `CGPoint` --> `LivePoint`
- `CGSize` --> `LiveSize`
- `CGRect` --> `LiveRect`
- `UIColor` --> `LiveColor`

### Static properites:
- `LiveFloat.live`
- `LiveFloat.seconds`
- `LiveFloat.secondsSince1970`
- `LiveFloat.gyroX`
- `LiveFloat.gyroY`
- `LiveFloat.gyroZ`
- `LiveFloat.accelerationX/Y/Z`
- `LiveFloat.magneticFieldX/Y/Z`
- `LiveFloat.deviceAttitudeX/Y/Z`
- `LiveFloat.deviceGravityX/Y/Z`
- `LiveFloat.deviceHeading`

### Functions:
- `liveFloat.delay(seconds: 1.0)`
- `liveFloat.filter(seconds: 1.0)`
- `liveFloat.filter(frames: 60)`

### Static functions:
- `LiveFloat.noise(range: -1.0...1.0, for: 1.0)`
- `LiveFloat.wave(range: -1.0...1.0, for: 1.0)`


## MIDI

Here's an example of live midi values in range 0.0 to 1.0.

```
let midiAny = LiveFloat.midiAny
let midiValue = .midi("<address>")
```

You can find the addresses by enabeling logging like this:

`MIDI.main.log = true`
