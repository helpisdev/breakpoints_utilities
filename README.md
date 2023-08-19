# breakpoints_utilities

This package contains some utilities for working with breakpoints in Dart code. Highlights:

- `BreakpointGenerator`: Generates a `Breakpoint` with specified bounds and device type.
- `BreakpointPlatform`: Enumeration of various platforms that collectively form more platforms, e.g. `BreakpointPlatform.unix` which is comprised of `TargetPlatform.{android,iOS,linux,macOS}`. This enum provides a method to check if a `TargetPlatrform` is included in the enum value being examined. Available values currently include:
  - none
  - all
  - unix
  - linuxOS
  - linux
  - darwin
  - windows
  - iOS
  - android
  - fuschia
  - macOS
  - mobile
  - desktop
- `DeviceType`: Device types, comprised of `BreakpointPlatform`s and `Orientation`.
- `Breakpoint`: This is the base abstract class for breakpoints. It contains useful methods such as `isActive` and operator overloading to easily compare breakpoints.
- `PredefinedBreakpoint`: An enumaeration of common predefined breakpoints such as mobile, tablet, desktop etc., with common values for lower/upper bounds and device types.
