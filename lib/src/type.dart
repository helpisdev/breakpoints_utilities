import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'platform.dart';

/// [PredefinedBreakpoint] constraint based on platform and orientation.
enum DeviceType {
  /// This is a special type representing no type.
  none(BreakpointPlatform.none),

  /// This type is valid on any platform.
  all(BreakpointPlatform.all),

  /// Mobile platform on portrait orientation.
  mobile(BreakpointPlatform.mobile, Orientation.portrait),

  /// Mobile platform on portrait landscape.
  mobileLandscape(BreakpointPlatform.mobile, Orientation.landscape),

  /// Tablet platform on portrait orientation.
  tablet(BreakpointPlatform.mobile, Orientation.portrait),

  /// Tablet platform on portrait landscape.
  tabletLandscape(BreakpointPlatform.mobile, Orientation.landscape),

  /// Laptop.
  laptop(BreakpointPlatform.desktop),

  /// Desktop.
  desktop(BreakpointPlatform.desktop),

  /// Breakpoint for TVs.
  tv(BreakpointPlatform.android),

  /// Breakpoint for watches.
  watch(BreakpointPlatform.mobile);

  /// Constructs a breakpoint type based on specified platforms and an optional
  /// orientation constraint.
  const DeviceType(this.platforms, [this.orientation]);

  /// The set of platforms this [DeviceType] is valid on. A superset of the
  /// available platforms that match the arbitrary constraint is chosen. Whether
  /// or not a [BreakpointPlatform] is a superset of another can be checked
  /// with [BreakpointPlatform.includes].
  final BreakpointPlatform platforms;

  /// Optional orientation constraint. This is valid only for mobile/tablet.
  final Orientation? orientation;
}
