import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import 'type.dart';

/// A group of breakpoints built according to the material
/// specifications for screen width size.
///
/// Value variations:
/// - exclusive By platform:
///   * Watch
///   * Mobile
///   * MobileLandscape
///   * Tablet
///   * TabletLandscape
///   * Laptop
///   * Desktop
///   * TV
///
/// - exclusive By bound:
///   * Bounded (plain)
///   * Lower Bounded (AndUp)
///   * Upper Bounded (AndDown)
///
/// - exclusive By size:
///   * xxs
///   * xs
///   * small
///   * medium
///   * large
///   * xl
///   * xxl
///
/// The enum is __NOT__ a product of these three value variations, but it should
/// cover most use cases. If you need more you can easily create a custom enum
/// that implements [Breakpoint] or [AbstractBreakpoint] and support more.
enum PredefinedBreakpoint implements Breakpoint {
  /// This is a standard breakpoint that can be used as a fallthrough in the
  /// case that no other breakpoint is active.
  ///
  /// It is active from negative infinity to infinity.
  standard(),

  /// begin: 0, end: 0, type: BreakpointType.none
  none(BreakpointGenerator.generate(begin: 0, end: 0, type: DeviceType.none)),

  // Simple bounded breakpoints irregardless of platform.
  /// Device Pixels inclusive 0 - exclusive 320
  xxs(BreakpointGenerator.generate(begin: 0, end: 320)),

  /// Device Pixels inclusive 320 - exclusive 480
  xs(BreakpointGenerator.generate(begin: 320, end: 480)),

  /// Device Pixels inclusive 480 - exclusive 600
  small(BreakpointGenerator.generate(begin: 480, end: 600)),

  /// Device Pixels inclusive 600 - exclusive 1080
  medium(BreakpointGenerator.generate(begin: 600, end: 1080)),

  /// Device Pixels inclusive 1080 - exclusive 1440
  large(BreakpointGenerator.generate(begin: 1080, end: 1440)),

  /// Device Pixels inclusive 1440 - exclusive 1920
  xl(BreakpointGenerator.generate(begin: 1440, end: 1920)),

  /// Device Pixels inclusive 1920 - exclusive [double.infinity].
  xxl(BreakpointGenerator.generate(begin: 1920)),

  // Simple upper unbounded breakpoints irregardless of platform.
  /// Device Pixels inclusive 0 - exclusive [double.infinity].
  xxsAndUp(BreakpointGenerator.generate(begin: 0)),

  /// Device Pixels inclusive 320 - exclusive [double.infinity].
  xsAndUp(BreakpointGenerator.generate(begin: 320)),

  /// Device Pixels inclusive 480 - exclusive [double.infinity].
  smallAndUp(BreakpointGenerator.generate(begin: 480)),

  /// Device Pixels inclusive 600 - exclusive [double.infinity].
  mediumAndUp(BreakpointGenerator.generate(begin: 600)),

  /// Device Pixels inclusive 1080 - exclusive [double.infinity].
  largeAndUp(BreakpointGenerator.generate(begin: 1080)),

  /// Device Pixels inclusive 1440 - exclusive [double.infinity].
  xlAndUp(BreakpointGenerator.generate(begin: 1440)),

  // Simple lower 0 bounded breakpoints irregardless of platform.
  /// Device Pixels inclusive 0 - exclusive 480.
  xsAndDown(BreakpointGenerator.generate(begin: 0, end: 480)),

  /// Device Pixels inclusive 0 - exclusive 600.
  smallAndDown(BreakpointGenerator.generate(begin: 0, end: 600)),

  /// Device Pixels inclusive 0 - exclusive 1080.
  mediumAndDown(BreakpointGenerator.generate(begin: 0, end: 1080)),

  /// Device Pixels inclusive 0 - exclusive 1440.
  largeAndDown(BreakpointGenerator.generate(begin: 0, end: 1440)),

  /// Device Pixels inclusive 0 - exclusive 1920.
  xlAndDown(BreakpointGenerator.generate(begin: 0, end: 1920)),

  // Watch breakpoints.
  /// Device Pixels inclusive 180 - exclusive 220
  watch(
    BreakpointGenerator.generate(
      begin: 180,
      end: 220,
      type: DeviceType.watch,
    ),
  ),

  /// Device Pixels inclusive 240 - exclusive 280
  largeWatch(
    BreakpointGenerator.generate(
      begin: 240,
      end: 280,
      type: DeviceType.watch,
    ),
  ),

  // Mobile breakpoints.
  /// Device Pixels inclusive 180 - exclusive 220
  xxsMobile(
    BreakpointGenerator.generate(
      begin: 180,
      end: 220,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 220 - exclusive 320
  xsMobile(
    BreakpointGenerator.generate(
      begin: 220,
      end: 320,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 320 - exclusive 480
  smallMobile(
    BreakpointGenerator.generate(
      begin: 320,
      end: 480,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 480 - exclusive 540
  mobile(
    BreakpointGenerator.generate(
      begin: 480,
      end: 540,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 540 - exclusive 600
  mediumMobile(
    BreakpointGenerator.generate(
      begin: 540,
      end: 600,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 600 - exclusive 720
  largeMobile(
    BreakpointGenerator.generate(
      begin: 600,
      end: 720,
      type: DeviceType.mobile,
    ),
  ),

  /// Device Pixels inclusive 480 - exclusive 720
  mobileLandscape(
    BreakpointGenerator.generate(
      begin: 480,
      end: 720,
      type: DeviceType.mobile,
    ),
  ),

  // Tablet breakpoints.
  /// Device Pixels inclusive 540 - exclusive 600
  smallTablet(
    BreakpointGenerator.generate(
      begin: 540,
      end: 600,
      type: DeviceType.tablet,
    ),
  ),

  /// Device Pixels inclusive 600 - exclusive 768
  tablet(
    BreakpointGenerator.generate(
      begin: 600,
      end: 768,
      type: DeviceType.tablet,
    ),
  ),

  /// Device Pixels inclusive 768 - exclusive 840
  mediumTablet(
    BreakpointGenerator.generate(
      begin: 768,
      end: 840,
      type: DeviceType.tablet,
    ),
  ),

  /// Device Pixels inclusive 840 - exclusive 1080
  largeTablet(
    BreakpointGenerator.generate(
      begin: 840,
      end: 1080,
      type: DeviceType.tablet,
    ),
  ),

  /// Device Pixels inclusive 720 - exclusive 1080
  tabletLandscape(
    BreakpointGenerator.generate(
      begin: 720,
      end: 1080,
      type: DeviceType.tablet,
    ),
  ),

  // Laptop breakpoints.
  /// Device Pixels inclusive 720 - exclusive 1080
  xsLaptop(
    BreakpointGenerator.generate(
      begin: 720,
      end: 1080,
      type: DeviceType.laptop,
    ),
  ),

  /// Device Pixels inclusive 1080 - exclusive 1440
  smallLaptop(
    BreakpointGenerator.generate(
      begin: 1080,
      end: 1440,
      type: DeviceType.laptop,
    ),
  ),

  /// Device Pixels inclusive 1440 - exclusive 1920
  laptop(
    BreakpointGenerator.generate(
      begin: 1440,
      end: 1920,
      type: DeviceType.laptop,
    ),
  ),

  // Desktop breakpoints.
  /// Device Pixels inclusive 1080 - exclusive 1920
  desktop(
    BreakpointGenerator.generate(
      begin: 1080,
      end: 1920,
      type: DeviceType.desktop,
    ),
  ),

  /// Device Pixels inclusive 1920 - exclusive 2880
  largeDesktop(
    BreakpointGenerator.generate(
      begin: 1920,
      end: 2880,
      type: DeviceType.desktop,
    ),
  ),

  /// Device Pixels inclusive 2880 - exclusive 3840
  xlDesktop(
    BreakpointGenerator.generate(
      begin: 2880,
      end: 3840,
      type: DeviceType.desktop,
    ),
  ),

  /// Device Pixels inclusive 3840 - exclusive 5760
  xxlDesktop(
    BreakpointGenerator.generate(
      begin: 3840,
      end: 5760,
      type: DeviceType.desktop,
    ),
  ),

  // TV breakpoints.
  /// Device Pixels inclusive 1080 - exclusive 1920
  tv(BreakpointGenerator.generate(begin: 1080, end: 1920, type: DeviceType.tv)),

  /// Device Pixels inclusive 1920 - exclusive 2880
  largeTV(
    BreakpointGenerator.generate(begin: 1920, end: 2880, type: DeviceType.tv),
  ),

  /// Device Pixels inclusive 2880 - exclusive 3840
  xlTV(
    BreakpointGenerator.generate(begin: 2880, end: 3840, type: DeviceType.tv),
  ),

  /// Device Pixels inclusive 3840 - exclusive 5760
  xxlTV(
    BreakpointGenerator.generate(begin: 3840, end: 5760, type: DeviceType.tv),
  );

  /// Breakpoints associated with width and platform constraints.
  const PredefinedBreakpoint([
    this.model = const BreakpointGenerator.generate(),
  ]);

  @override
  double get begin => model.begin;

  @override
  double? get end => model.end;

  @override
  DeviceType get type => model.type;

  /// The underlying [Breakpoint].
  final Breakpoint model;

  @override
  bool eq(final Object? other) {
    if (other == null) {
      return false;
    }
    try {
      final double? converted = double.tryParse(other.toString());
      if (converted != null) {
        return this == ofOrNull(converted);
      } else if (other is PredefinedBreakpoint) {
        return this == other;
      } else if (other is Breakpoint) {
        return other.compareTo(this) == 0;
      } else {
        return this == other;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  @override
  bool isActive(final BuildContext context) {
    if (this == standard) {
      return true;
    }
    if (this == none) {
      return false;
    }
    return Breakpoint.checkIfActive(context, model);
  }

  @override
  int compareTo(final Object other) {
    final double? converted = double.tryParse(other.toString());
    if (converted != null) {
      return model.begin.compareTo(converted);
    } else if (other is PredefinedBreakpoint) {
      return Breakpoint.compare(model, other.model);
    } else if (other is Breakpoint) {
      return other.compareTo(this);
    }
    throw UnsupportedError(
      'Cannot compare an Breakpoint to ${other.runtimeType}',
    );
  }

  /// Less than operator
  @override
  bool operator <(final Object other) => compareTo(other) < 0;

  /// Greater than operator
  @override
  bool operator >(final Object other) => compareTo(other) > 0;

  /// Less than or equal operator
  @override
  bool operator <=(final Object other) => compareTo(other) <= 0;

  /// Greater than or equal operator
  @override
  bool operator >=(final Object other) => compareTo(other) >= 0;

  /// Converts a dp to a [PredefinedBreakpoint] or null.
  static PredefinedBreakpoint? ofOrNull(final double dp) {
    for (final PredefinedBreakpoint point in PredefinedBreakpoint.values) {
      final double end = point.model.end ?? double.infinity;
      if (point.model.begin >= dp && dp < end) {
        return point;
      }
    }
    return null;
  }

  /// Converts a dp to a [PredefinedBreakpoint] if it is in the included range.
  static PredefinedBreakpoint of(
    final double dp, {
    final PredefinedBreakpoint Function()? orElse,
  }) {
    final PredefinedBreakpoint? p = ofOrNull(dp);

    if (p != null) {
      return p;
    }

    if (orElse != null) {
      return orElse();
    }

    throw StateError(
      "The provided value didn't match any breakpoint and an "
      'orElse function was not specified.',
    );
  }

  /// Converts a dp to a [PredefinedBreakpoint] or [PredefinedBreakpoint.none].
  static PredefinedBreakpoint ofOrNone(final double dp) =>
      ofOrNull(dp) ?? PredefinedBreakpoint.none;

  /// Converts a dp to a [PredefinedBreakpoint] or
  /// [PredefinedBreakpoint.standard].
  static PredefinedBreakpoint ofOrStandard(final double dp) =>
      ofOrNull(dp) ?? PredefinedBreakpoint.standard;

  Breakpoint withPlatform(final DeviceType type) =>
      BreakpointGenerator.generate(
        begin: model.begin,
        end: model.end,
        type: type,
      );
}
