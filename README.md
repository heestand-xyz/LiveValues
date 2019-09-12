# Live

## Values

Live values are automatically updated when they have changin values.
Live values are ease to animate with the `.live` or `.seconds` static properites.

### Types:
- `CGFloat` --> `LiveFloat`
- `Int` --> `LiveInt`
- `Bool` --> `LiveBool`
- `CGPoint` --> `LivePoint`
- `CGSize` --> `LiveSize`
- `CGRect` --> `LiveRect`

### Static properites:
- `LiveFloat.live`
- `LiveFloat.seconds`
- `LiveFloat.secondsSince1970`
// - `LiveFloat.touch` / `LiveFloat.mouseLeft`
// - `LiveFloat.touchX` / `LiveFloat.mouseX`
// - `LiveFloat.touchY` / `LiveFloat.mouseY`
// - `LivePoint.touchXY` / `LiveFloat.mouseXY`
- `LiveFloat.gyroX`
- `LiveFloat.gyroY`
- `LiveFloat.gyroZ`
- `LiveFloat.accelerationX/Y/X`
- `LiveFloat.magneticFieldX/Y/X`
- `LiveFloat.deviceAttitudeX/Y/X`
- `LiveFloat.deviceGravityX/Y/X`
- `LiveFloat.deviceHeading`

### Functions:
- `liveFloat.delay(seconds: 1.0)`
- `liveFloat.filter(seconds: 1.0)`
- `liveFloat.filter(frames: 60)`

### Static functions:
- `LiveFloat.noise(range: -1.0...1.0, for: 1.0)`
- `LiveFloat.wave(range: -1.0...1.0, for: 1.0)`


## MIDI & OSC

Here's an example of live midi & osc values in range 0.0 to 1.0.

```
let midiAny = LiveFloat.midiAny
let midiValue = .midi("<address>")

let oscAny = LiveFloat.oscAny
let oscValue = .osc("<address>")
```

You can find the addresses by enabeling logging like this:

`MIDI.main.log = true` or `OSC.main.log = true`
