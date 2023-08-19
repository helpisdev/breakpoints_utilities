import 'package:flutter/material.dart';

import 'breakpoints.dart';
import 'type.dart';

/// An interface to define the conditions that distinguish between types of
/// screens.
///
/// Adaptive apps usually display differently depending on the screen type: a
/// compact layout for smaller screens, or a relaxed layout for larger screens.
/// Override this class by defining `isActive` to fetch the screen property
/// (usually `MediaQuery.of`) and return true if the condition is met.
///
/// Breakpoints do not need to be exclusive because they are tested in order
/// with the last Breakpoint active taking priority.
///
/// If the condition is only based on the screen width and/or the device type,
/// use a predefined [PredefinedBreakpoint] or create a custom one by with
/// [BreakpointGenerator.generate], or alternatively extend [Breakpoint] or
/// implement [AbstractBreakpoint] to create breakpoints with business logic
/// constraints.
@immutable
abstract class AbstractBreakpoint implements Comparable<AbstractBreakpoint> {
  /// A method that returns true based on conditions related to the context of
  /// the screen such as `MediaQuery.of(context).size.width`.
  bool isActive(final BuildContext context);

  @override
  int compareTo(final Object other);

  /// Less than operator
  bool operator <(final Object other);

  /// Greater than operator
  bool operator >(final Object other);

  /// Less than or equal operator
  bool operator <=(final Object other);

  /// Greater than or equal operator
  bool operator >=(final Object other);

  /// Custom equality check that can be overridden in an enum
  bool eq(final Object? other);
}

/// Enforces [Breakpoint] implementers to specify DP lower and upper bounds.
@immutable
mixin BreakpointBounds on AbstractBreakpoint {
  /// All [Breakpoint] implementers must provide at least a starting
  /// value that can be checked inclusivley to establish activation status.
  abstract final double begin;

  /// All [Breakpoint] implementers can optionally provide an ending boundary
  /// that is exclusive.
  abstract final double? end;
}

/// Enforces [Breakpoint] implementers to specify a [DeviceType].
@immutable
mixin BreakpointType on AbstractBreakpoint {
  /// All [Breakpoint] implementers can optionally provide a breakpoint type.
  abstract final DeviceType type;
}

/// Model that implements [Breakpoint].
@immutable
abstract class BreakpointImplementer implements AbstractBreakpoint {
  const BreakpointImplementer() : super();
}

/// Model that implements [Breakpoint] and provides boundaries and type
/// information.
@immutable
abstract class Breakpoint extends BreakpointImplementer
    with BreakpointBounds, BreakpointType {
  const Breakpoint() : super();

  /// Utility to check if a [Breakpoint] is currently active.
  static bool checkIfActive(
    final BuildContext context,
    final Breakpoint b,
  ) {
    final TargetPlatform host = Theme.of(context).platform;
    final bool isRightPlatform = b.type.platforms.targets.contains(host);

    final double width = MediaQuery.of(context).size.width;
    final double lowerBound = b.begin;
    final double upperBound = b.end ?? double.infinity;

    return width >= lowerBound && width < upperBound && isRightPlatform;
  }

  /// Compares two [Breakpoint]s that mix in a [Breakpoint].
  static int compare(final Breakpoint a, final Breakpoint b) {
    if (a.type != b.type) {
      final bool isSuperset = a.type.platforms.includes(
        b.type.platforms.targets,
      );
      final bool isSubset = b.type.platforms.includes(
        a.type.platforms.targets,
      );
      if (!isSuperset && !isSubset) {
        throw StateError(
          'Cannot compare Breakpoints of different types that are not a '
          'superset or subset of each other.',
        );
      }
    }
    if (a.begin != double.negativeInfinity &&
        b.begin != double.negativeInfinity) {
      return a.begin.compareTo(b.begin);
    }
    if (a.end != double.infinity &&
        b.end != double.infinity &&
        a.end != null &&
        b.end != null) {
      return a.end!.compareTo(b.end!);
    }
    throw StateError(
      'Cannot compare unbounded Breakpoints of opposite bounds.',
    );
  }
}

/// Represents the standard form of a [Breakpoint]
@immutable
class BreakpointGenerator extends Breakpoint {
  /// A standard [Breakpoint] should use a beginning, an ending, and a type.
  const BreakpointGenerator.generate({
    this.begin = double.negativeInfinity,
    final double? end,
    this.type = DeviceType.all,
  })  : end = end ?? double.infinity,
        super();

  @override
  final double begin;

  @override
  final double end;

  @override
  final DeviceType type;

  @override
  bool operator <(final Object other) => compareTo(other) < 0;

  @override
  bool operator >(final Object other) => compareTo(other) > 0;

  @override
  bool operator <=(final Object other) => compareTo(other) <= 0;

  @override
  bool operator >=(final Object other) => compareTo(other) >= 0;

  @override
  int compareTo(final Object other) {
    if (other is Breakpoint) {
      return Breakpoint.compare(this, other);
    }
    if (other is AbstractBreakpoint) {
      return other.compareTo(this) * -1;
    }
    throw UnsupportedError(
      'Generated breakpoints can only be compared '
      'with implementers of Breakpoint or of AbstractBreakpoint.',
    );
  }

  @override
  bool eq(final Object? other) => other != null && compareTo(other) == 0;

  @override
  bool isActive(final BuildContext context) => Breakpoint.checkIfActive(
        context,
        this,
      );
}
