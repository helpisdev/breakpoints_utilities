import 'package:flutter/material.dart';

/// Groups different platform together based on arbitrary characteristics to
/// provide platform constraints for any use case.
enum BreakpointPlatform {
  /// None platform matches this set.
  none(<TargetPlatform>{}),

  /// All platforms match this set.
  all(
    <TargetPlatform>{
      TargetPlatform.android,
      TargetPlatform.fuchsia,
      TargetPlatform.iOS,
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    },
  ),

  /// Unix-based platforms.
  unix(
    <TargetPlatform>{
      TargetPlatform.android,
      TargetPlatform.iOS,
      TargetPlatform.linux,
      TargetPlatform.macOS,
    },
  ),

  /// Linux based platform.
  linuxOS(
    <TargetPlatform>{
      TargetPlatform.android,
      TargetPlatform.linux,
    },
  ),

  /// Linux desktop platform.
  linux(
    <TargetPlatform>{
      TargetPlatform.linux,
    },
  ),

  /// Darwin-based platforms.
  darwin(
    <TargetPlatform>{
      TargetPlatform.iOS,
      TargetPlatform.macOS,
    },
  ),

  /// Windows platform.
  windows(
    <TargetPlatform>{
      TargetPlatform.windows,
    },
  ),

  /// iOS platform.
  iOS(
    <TargetPlatform>{
      TargetPlatform.iOS,
    },
  ),

  /// Android platform.
  android(
    <TargetPlatform>{
      TargetPlatform.android,
    },
  ),

  /// Fuschia platform.
  fuschia(
    <TargetPlatform>{
      TargetPlatform.fuchsia,
    },
  ),

  /// macOS platform.
  macOS(
    <TargetPlatform>{
      TargetPlatform.macOS,
    },
  ),

  /// Mobile platforms.
  mobile(
    <TargetPlatform>{
      TargetPlatform.android,
      TargetPlatform.fuchsia,
      TargetPlatform.iOS,
    },
  ),

  /// Desktop platforms.
  desktop(
    <TargetPlatform>{
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    },
  );

  /// Constructs a breakpoint platform constraint.
  const BreakpointPlatform(this.targets);

  /// Set of platforms this breakpoint is valid on.
  final Set<TargetPlatform> targets;

  /// Checks if a [BreakpointPlatform] is a superset of another
  /// [BreakpointPlatform] by checking their [targets].
  bool includes(final Set<TargetPlatform> targets) {
    if (targets.isEmpty) {
      return false;
    }
    return this.targets.containsAll(targets);
  }
}
