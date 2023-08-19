# Styleguide

## Table of Contents

--------------------

- [Introduction](#introduction)
- [Table of Contents](table-of-contents)
- [Overview](#overview)
- [Principles](#principles)
- [Documentation](#documentation)
- [Coding Patterns](#coding-patterns)
- [Naming](#naming)
- [Comments](#comments)
- [Formatting](#formatting)

## Introduction

--------------------

This document contains some high-level philosophy and policy decisions for the my_awesome_project project, and a description of specific style issues for some parts of the codebase. This styleguide is _DART-specific_ and should not apply to other languages being used in the project. For language-agnostic guideline, see [STYLEGUIDE.md](STYLEGUIDE.md). Heavily inspired by the [Flutter project styleguide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo).

## Overview

--------------------

This document describes our approach to designing and programming my_awesome_project, from high-level architectural principles all the way to documentation rules. These are our norms, written down so that we can easily convey our shared understanding with new team members.

The primary goal of these style guidelines is to improve code readability so that everyone, whether reading the code for the first time or maintaining it for years, can quickly determine what the code does. Secondary goals are to design systems that are simple, to increase the likelihood of catching bugs quickly, and avoiding arguments when there are disagreements over subjective matters.

## Principles

--------------------

### Avoid duplicating state

There should be no objects that represent live state that reflect some state from another source, since they are expensive to maintain. (The Web's `HTMLCollection` object is an example of such an object.) In other words, __keep only one source of truth, and don't replicate live state__.

### Getters feel faster than methods

Property getters should be efficient (e.g. just returning a cached value, or an O(1) table lookup). If an operation is inefficient, it should be a method instead. (Looking at the Web again: we would have `document.getForms()`, not `document.forms`, since it walks the entire tree).

Similarly, a getter that returns a `Future` should not kick-off the work represented by the future, since getters appear idempotent and side-effect free. Instead, the work should be started from a method or constructor, and the getter should just return the preexisting Future.

### No synchronous slow work

There should be no APIs that require synchronously completing an expensive operation (e.g. computing a full app layout outside of the layout phase). Expensive work should be asynchronous.

### Avoid secret (or global) state

A function should operate only on its arguments and, if it is an instance method, data stored on its object. This makes the code significantly easier to understand.

For example, when reading this code:

```dart
// ... imports something that defines foo and bar ...

void main() {
  foo(1);
  bar(2);
}
```

...the reader should be confident that nothing in the call to `foo` could affect anything in the call to `bar`.

This usually means structuring APIs so that they either take all relevant inputs as arguments, or so that they are based on objects that are created with the relevant input, and can then be called to operate on those inputs.

This significantly aids in making code testable and in making code understandable and debuggable. When code operates on secret global state, it's much harder to reason about.

### Avoid APIs that encourage bad practices

For example, don't provide APIs that walk entire trees, or that encourage `O(N^2)` algorithms, or that encourage sequential long-lived operations where the operations could be run concurrently.

In particular:

- String manipulation to generate data or code that will subsequently be interpreted or parsed is a bad practice as it leads to code injection vulnerabilities.
- If an operation is expensive, that expense should be represented in the API (e.g. by returning a `Future` or a `Stream`). Avoid providing APIs that hide the expense of tasks.

## Documentation

--------------------

In general, follow the [Dart documentation guide](https://www.dartlang.org/effective-dart/documentation/#doc-comments) except where that would contradict this page.

### Leave breadcrumbs in the comments

This is especially important for documentation at the level of classes.

If a class is constructed using a builder of some sort, or can be obtained via some mechanism other than merely calling the constructor, then include this information in the documentation for the class.

If a class is typically used by passing it to a particular API, then include that information in the class documentation also.

If a method is the main mechanism used to obtain a particular object, or is the main way to consume a particular object, then mention that in the method's description.

Typedefs should mention at least one place where the signature is used.

These rules result in a chain of breadcrumbs that a reader can follow to get from any class or method that they might think is relevant to their task all the way up to the class or method they actually need.

Example:

```dart
// GOOD:

/// An object representing a sequence of recorded graphical operations.
///
/// To create a [Picture], use a [PictureRecorder].
///
/// A [Picture] can be placed in a [Scene] using a [SceneBuilder], via
/// the [SceneBuilder.addPicture] method. A [Picture] can also be
/// drawn into a [Canvas], using the [Canvas.drawPicture] method.
abstract class Picture ...
```

You can also use "See also" links, is in:

```dart
/// See also:
///
/// * [FooBar], which is another way to peel oranges.
/// * [Baz], which quuxes the wibble.
```

Each line should end with a period. Prefer "which..." rather than parentheticals on such lines. There should be a blank line between "See also:" and the first item in the bulleted list.

### Use `///` for public-quality private documentation

In general, private code can and should also be documented. If that documentation is of good enough quality that we could include it verbatim when making the class public (i.e. it satisfies all the style guidelines above), then you can use `///` for those docs, even though they're private.

Documentation of private APIs that is not of sufficient quality should only use `//`. That way, if we ever make the corresponding class public, those documentation comments will be flagged as missing, and we will know to examine them more carefully.

Feel free to be conservative in what you consider "sufficient quality". It's ok to use `//` even if you have multiple paragraphs of documentation; that's a sign that we should carefully rereview the documentation when making the code public.

### Dartdoc templates and macros

Dartdoc supports creating templates that can be reused in other parts of the code. They are defined like so:

```dart
/// {@template <id>}
/// ...
/// {@endtemplate}
```

and used via:

```dart
/// {@macro <id>}
```

The `<id>` should be a unique identifier that is of the form `flutter.library.Class.member[.optionalDescription]`.
For example:

```dart
// GOOD:
/// {@template flutter.rendering.Layer.findAnnotations.aboutAnnotations}
/// Annotations are great!
/// {@endtemplate

// BAD:
/// {@template the_stuff!}
/// This is some great stuff!
/// {@endtemplate}
```

The `optionalDescription` component of the identifier is only necessary if there is more than one template defined in one Dartdoc block. If a symbol is not part of a library, or not part of a class, then just omit those parts from the ID.

### Dartdoc-specific requirements

The first paragraph of any dartdoc section must be a short self-contained sentence that explains the purpose and meaning of the item being documented. Subsequent paragraphs then must elaborate. Avoid having the first paragraph have multiple sentences. (This is because the first paragraph gets extracted and used in tables of contents, etc, and so has to be able to stand alone and not take up a lot of room.)

Avoid using terms like "above" or "below" to reference one dartdoc section from another. Dartdoc sections are often shown alone on a Web page, the full context of the class is not present.

## Coding Patterns

--------------------

### Don't use `new` or use `const` redundantly

Dart 2 makes the `new` optional for constructors, with an aim at removing them in time. The `const` keyword is also optional where it can be inferred by the compiler.

`const` can be inferred in:

- A `const` collection literal.
- A `const` constructor call.
- A metadata annotation.
- The initializer for a `const` variable declaration.
- A `switch` case expression - the part right after case before the :, not the body of the case.

This guidance will eventually be part of Effective Dart due to the changes for Dart 2.
_Good:_

```dart
final foo = Foo();
const foo = Foo();
const foo = const <Widget>[A(), B()];
const Foo(): bar = Bar();
```

_Bad:_

```dart
final foo = new Foo();
const foo = const Foo();
foo = const [const A(), const B()];
const Foo(): bar = const Bar();
```

### Don't do useful work in assert statements

Code inside `assert` statements are not executed in production code. Asserts should only check conditions and be side-effect free.

### Prefer to use `const` over `final` over `var`

This minimizes the mutability for each member or local variable.

### Prefer minimizing the number of public members exposed in a package

This can be done by only making things public when needed, and keeping all implementation detail libraries in the `/src` directory. Assume anything public in the `lib` directory will be re-used.

### Consider exporting publicly visible classes in a single `.dart` file

For multiple classes that are used together but are in different files, it's more convenient for users of your library to import a single file rather many at once. If the user wants narrower imports they can always restrict visibility using the `show` keyword.

This also helps minimize the publicly visible surface.

Example:

```dart
/// In src/apple.dart
class Apple {}

/// In src/orange.dart
class Orange {}

/// In src/veggies.dart
class Potato {}
class Tomato {}

/// In botanical_fruits.dart
export 'src/apple.dart';
export 'src/orange.dart';
// Can also be: export 'src/veggies.dart' hide Potato;
export 'src/veggies.dart' show Tomato;

/// In squeezer.dart
import 'package:plants/botanical_fruits.dart' show Orange;
```

### Do use namespacing when there is ambiguity, e.g. in class names

There are often functions or classes that can collide, e.g. `File` or `Image`. If you don't namespace, there will be a compile error.
_Good:_

```dart
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
...

ui.Image(...) ...
```

_Bad:_

```dart
import 'dart:ui';

import 'package:flutter/material.dart';
...

Image(...) ... // Which Image is this?
```

### Prefer to use `show` if you only have a few imports from that package. Otherwise, use `as`

Using `show` can avoid collisions without requiring you to prepend namespaces to types, leading to cleaner code.
_Good:_

```dart
import 'package:fancy_style_guide/style.dart' as style;
import 'package:flutter/material.dart';
import 'package:math/simple_functions.dart' show Addition, Subtraction;
```

_Bad:_

```dart
import 'package:flutter/material.dart show Container, Row, Column, Padding,
  Expanded, ...;
```

### Avoid mixing named and positional parameters

Instead, `@required` should be used in place of `required` positional parameters.

### Do use trailing commas on all tree structures longer than one line

Without trailing commas, code that builds widget trees or similar types of code tends to be hard to read. Adding the trailing commas allows `dart format` to do its job correctly.
_Without trailing commas:_

```dart
children.add(Expanded(
  child: Center(
      child: Container(
          width: 64.0, height: 64.0, child: FuchsiaSpinner())),
));
```

_With trailing commas:_

```dart
children.add(Expanded(
  child: Center(
      child: Container(
        width: 64.0,
        height: 64.0,
        child: FuchsiaSpinner(),
      ),
   ),
));
```

### Prefer named parameters

In most situations, named parameters are less error prone and easier to read than positional parameters, optional or not. They give users to pass in the parameters in whatever order they please, and make Flutter trees especially clearer.

In the Fuchsia repository, positional parameters should be reserved for simple operational functions with only a few parameters.
_Good:_

```dart
int add(int a, int b);
int addNumbers(int a, [int b, int c, int d]);
Foo fromJson(String json);
void load(String file);

Widget buildButton({
  @required Widget child,
  VoidCallback onTap,
  double width,
  bool isDisabled = false,
});
```

_Bad:_

```dart
int add({int a, int b});
Foo fromJson({@required String json});

Widget buildButton(
  Widget child,
  VoidCallback onTap, [
  double width,
  bool isDisabled = false,
]);
```

### Prefer return `Widget` instead of a specific type of Flutter widget

As your project evolves, you may change the widget type that is returned in your function. For example, you might wrap your widget with a `Center`. Returning `Widget` simplifies the refactoring, as the method signature wouldn't have to change.

_Good:_

```dart
Widget returnContainerWidget() {
  return Container();
}
```

_Bad:_

```dart
Container returnContainerWidget() {
  return Container();
}
```

### Use asserts liberally to detect contract violations and verify invariants

`assert()` allows us to be diligent about correctness without paying a performance penalty in release mode, because Dart only evaluates asserts in debug mode.

It should be used to verify contracts and invariants are being met as we expect. Asserts do not enforce contracts, since they do not run at all in release builds. They should be used in cases where it should be impossible for the condition to be false without there being a bug somewhere in the code.

The following example is from `box.dart`:

```dart
abstract class RenderBox extends RenderObject {
  // ...

  double getDistanceToBaseline(TextBaseline baseline, {bool onlyReal: false}) {
    // simple asserts:
    assert(!needsLayout);
    assert(!_debugDoingBaseline);
    // more complicated asserts:
    assert(() {
      final RenderObject parent = this.parent;
      if (owner.debugDoingLayout)
        return (RenderObject.debugActiveLayout == parent) &&
            parent.debugDoingThisLayout;
      if (owner.debugDoingPaint)
        return ((RenderObject.debugActivePaint == parent) &&
                parent.debugDoingThisPaint) ||
            ((RenderObject.debugActivePaint == this) && debugDoingThisPaint);
      assert(parent == this.parent);
      return false;
    });
    // ...
    return 0.0;
  }

  // ...
}
```

### Prefer specialized functions, methods and constructors

Use the most relevant constructor or method, when there are multiple options.

Example:

```dart
// BAD:
const EdgeInsets.TRBL(0.0, 8.0, 0.0, 8.0);

// GOOD:
const EdgeInsets.symmetric(horizontal: 8.0);
```

### Minimize the visibility scope of constants

Prefer using a local const or a static const in a relevant class than using a global constant.

As a general rule, when you have a lot of constants, wrap them in a class.

### Avoid using `if` chains or `?:` or `==` with enum values

Use `switch` with no `default` case if you are examining an `enum`, since the analyzer will warn you if you missed any of the values when you use `switch`. The `default` case should be avoided so that the analyzer will complain if a value is missing. Unused values can be grouped together with a single `break` or `return` as appropriate.

Avoid using `if` chains, `? ... : ...`, or, in general, any expressions involving enums.

### Avoid using `var` and `dynamic`

All variables and arguments are typed; avoid `dynamic` or `Object` in any case where you could figure out the actual type. Always specialize generic types where possible. Explicitly type all list and map literals. Give types to all parameters, even in closures and even if you don't use the parameter.

This achieves two purposes: it verifies that the type that the compiler would infer matches the type you expect, and it makes the code self-documenting in the case where the type is not obvious (e.g. when calling anything other than a constructor).

Always avoid `var` and `dynamic`. If the type is unknown, prefer using `Object` (or `Object?`) and casting, as using `dynamic` disables all static checking.

### Avoid using `extension`

Extension methods are confusing to document and discover. To an end developer, they appear no different than the built in API of the class, and discovering the documentation and implementation of an extension is more challenging than for class members.

Prefer instead adding methods directly to relevant classes. If that is not possible, create a method that clearly identifies what object(s) it works with and is part of.

### Avoid using `FutureOr<T>`

The `FutureOr` type is a Dart-internal type used to explain certain aspects of the `Future` API. In public APIs, avoid the temptation to create APIs that are both synchronous and asynchronous by returning this type, as it usually only results in the API being more confusing and less type safe.

In certain extreme cases where the API absolutely needs to be asynchronous but a synchronous "escape hatch" is needed for performance, consider using `SynchronousFuture` (but be aware that this still suffers from many of the same risks of making the API only subtle and complicated).

You may use `FutureOr` to accept a callback that may or may not return a `Future`.

### Avoid using `Expando`

Generally speaking, `Expando` objects are a sign of an architectural problem. Carefully consider whether your usage is actually necessary. When your classes have clear documented ownership rules, there is usually a better solution.

`Expando` objects tend to invite code that is hard to understand because one cannot simply follow references to find all the dependencies.

### Perform dirty checks in setters

Dirty checks are processes to determine whether a changed values have been synchronized with the rest of the app.

When defining mutable properties that mark a class dirty when set, use the following pattern:

```dart
/// Documentation here (don't wait for a later commit).
TheType get theProperty => _theProperty;
TheType _theProperty;
void set theProperty(TheType value) {
  assert(value != null);
  if (_theProperty == value)
    return;
  _theProperty = value;
  markNeedsWhatever(); // the method to mark the object dirty
}
```

The argument is called 'value' for ease of copy-and-paste reuse of this pattern. If for some reason you don't want to use 'value', use 'newProperty' (where 'Property' is the property name).

Start the method with any asserts you need to validate the value.

Don't do anything _else_ in setters, other than marking the object as dirty and updating internal state. Getters and setters should not have significant side-effects. For example, setting a property whose value is a callback should not result in that callback being invoked. Setting a property whose value is an object of some sort should not result in any of that object's methods being called.

### Override `toString`

Use [`Diagnosticable`](https://api.flutter.dev/flutter/foundation/Diagnosticable-mixin.html) (rather than directly overriding `toString`) on all but the most trivial classes. That allows us to inspect the object from [devtools](https://pub.dartlang.org/packages/devtools) and IDEs.

For trivial classes, override `toString` as follows, to aid in debugging:

```dart
@override
String toString() => '${objectRuntimeType(this, 'NameOfObject')}($bar, $baz, $quux)';
```

...but even then, consider using `Diagnosticable` instead. Avoid using `$runtimeType`, since it adds a non-trivial cost even in release and profile mode. The `objectRuntimeType` method handles this for you, falling back to a supplied constant string when asserts are disabled.

### Be explicit about `dispose()` and the object lifecycle

Even though Dart is garbage collected, having a defined object lifecycle and explicit ownership model (describing in the API documentation who is allowed to mutate the object, for instance) is important to avoid subtle bugs and confusing designs.

If your class has a clear "end of life", for example, provide a `dispose()` method to clean up references such as listeners that would otherwise prevent some objects from getting garbage collected. For example, consider a widget that has a subscription on a global broadcast stream (that might have other listeners). That subscription will keep the widget from getting garbage collected until the stream itself goes away (which, for a global stream, might never happen).

In general, pretending that Dart does not have garbage collection is likely to lead to less confusing and buggy code, because it forces you to think about the implications of object ownership and lifecycles.

### Immutable classes should not have hidden state

Immutable classes (those with const constructors) should not have hidden state. For example, they should not use private statics or Expandos. If they are stateful, `then` they should not be `const`.

### Avoid `sync*`/`async*`

Using generator functions (`sync*`/`async*`) can be a powerful improvement when callers will actually lazily evaluate the iterable and each iteration is expensive or there are a very large number of iterations.

It should not be used in place of building and returning a `List`, particularly for trivial methods that only yield a small number of members or when callers will evaluate the whole collection anyway. It should also be avoided in very large functions.

It incurs runtime overhead in maintaining and using an iterator, and space overhead for the compiler to actually desugar the generator into something that uses an iterator class.

## Naming

--------------------

### Begin global constant names with prefix "k"

Examples:

```dart
const double kParagraphSpacing = 1.5;
const String kSaveButtonTitle = 'Save';
const Color _kBarrierColor = Colors.black54;
```

However, where possible avoid global constants. Rather than `kDefaultButtonColor`, consider `Button.defaultColor`. If necessary, consider creating a class with a private constructor to hold relevant constants. It's not necessary to add the `k` prefix to non-global constants.

### Avoid anonymous parameter names

Provide full type information and names even for parameters that are otherwise unused. This makes it easier for people reading the code to tell what is actually going on (e.g. what is being ignored). For example:

```dart
onTapDown: (TapDownDetails details) { print('hello!'); }, // GOOD
onTapUp: (_) { print('good bye'); }, // BAD
```

### Capitalize identifiers consistent with their spelling

In general, we use [Dart's recommendations](https://dart.dev/guides/language/effective-dart/style#identifiers)'s for naming identifiers. Please consider the following additional guidelines:

If a word is correctly spelled (according to our sources of truth as described in the previous section) as a single word, then it should not have any inner capitalization or spaces.

For examples, prefer `toolbar`, `scrollbar`, but `appBar` ('app bar' in documentation), `tabBar` ('tab bar' in documentation).

Similarly, prefer `offstage` rather than `offStage`.

Avoid using class names with `iOS` when possible. The capitalization of `iOS` is supposed to be exactly that, but that doesn't work well with camelCase and even less with UpperCamelCase; use alternatives like "Cupertino" or "UIKit" instead when possible. If you really really must use "iOS" in an identifier, capitalize it to `IOS`. Whether or not the [two-letter exception](https://dart.dev/guides/language/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words) applies to "iOS" is debatable, but IOS is consistent with Dart APIs, and the alternatives (`IOs`, `Ios`) are even more jarring. (Previous versions of this guide incorrectly indicated that `Ios` was the correct capitalization when necessary; this form should not be used in new code.)

### Prefer naming the argument to a setter `value`

Unless this would cause other problems, use `value` for the name of a setter's argument. This makes it easier to copy/paste the setter later.

## Comments

--------------------

### Comment all `// ignores`

Sometimes, it is necessary to write code that the analyzer is unhappy with.

If you find yourself in this situation, consider how you got there. Is the analyzer actually correct but you don't want to admit it? Think about how you could refactor your code so that the analyzer is happy. If such a refactor would make the code better, do it.

If you are really really sure that you have no choice but to silence the analyzer, use `// ignore:`. The ignore directive should be on the same line as the analyzer warning.

If the ignore is temporary (e.g. a workaround for a bug in the compiler or analyzer, or a workaround for some known problem in Flutter that you cannot fix), then add a link to the relevant bug, as follows:

```dart
foo(); // ignore: lint_code, https://link.to.bug/goes/here
```

If the ignore directive is permanent, e.g. because one of our lints has some unavoidable false positives and in this case violating the lint is definitely better than all other options, then add a comment explaining why:

```dart
foo(); // ignore: lint_code, sadly there is no choice but to do
// this because we need to twiddle the quux and the bar is zorgle.
```

## Formatting

--------------------

These guidelines have no technical effect, but they are still important purely for consistency and readability reasons.

### Constructors come first in a class

The default (unnamed) constructor should come first, then the named constructors. They should come before anything else (including, e.g., constants or static methods).

This helps readers determine whether the class has a default implied constructor or not at a glance. If it was possible for a constructor to be anywhere in the class, then the reader would have to examine every line of the class to determine whether or not there was an implicit constructor or not.

### Order other class members in a way that makes sense

The methods, properties, and other members of a class should be in an order that will help readers understand how the class works.

If there's a clear lifecycle, then the order in which methods get invoked would be useful, for example an `initState` method coming before `dispose`. This helps readers because the code is in chronological order, so they can see variables get initialized before they are used, for instance. Fields should come before the methods that manipulate them, if they are specific to a particular group of methods.

> For example, `RenderObject` groups all the layout fields and layout methods together, then all the paint fields and paint methods, because layout happens before paint.

If no particular order is obvious, then the following order is suggested, with blank lines between each one:

1. Constructors, with the default constructor first.
2. Constants of the same type as the class.
3. Static methods that return the same type as the class.
4. Final fields that are set from the constructor.
5. Other static methods.
6. Static properties and constants.
7. Mutable properties, each in the order getter, private field, setter, without newlines separating them.
8. Read-only properties (other than `hashCode`).
9. Operators (other than `==`).
10. Methods (other than `toString` and `build`).
11. The `build` method, for `Widget` and `State` classes.
12. `operator ==`, `hashCode`, `toString`, and diagnostics-related methods, in that order.

Be consistent in the order of members. If a constructor lists multiple fields, then those fields should be declared in the same order, and any code that operates on all of them should operate on them in the same order (unless the order matters).

### Constructor syntax

If you call `super()` in your initializer list, put a space between the constructor arguments' closing parenthesis and the colon. If there's other things in the initializer list, align the `super()` call with the other arguments. Don't call `super` if you have no arguments to pass up to the superclass.

```dart
// one-line constructor example
abstract class Foo extends StatelessWidget {
  Foo(this.bar, { Key key, this.child }) : super(key: key);
  final int bar;
  final Widget child;
  // ...
}

// fully expanded constructor example
abstract class Foo extends StatelessWidget {
  Foo(
    this.bar, {
    Key key,
    Widget childWidget,
  }) : child = childWidget,
       super(
         key: key,
       );
  final int bar;
  final Widget child;
  // ...
}
```

### Prefer a maximum line length of 80 characters

Aim for a maximum line length of roughly 80 characters, but prefer going over if breaking the line would make it less readable, or if it would make the line less consistent with other nearby lines. Prefer avoiding line breaks after assignment operators.

```dart
// BAD (breaks after assignment operator and still goes over 80 chars)
final int a = 1;
final int b = 2;
final int c =
    a.very.very.very.very.very.long.expression.that.returns.three.eventually().but.is.very.long();
final int d = 4;
final int e = 5;

// BETTER (consistent lines, not much longer than the earlier example)
final int a = 1;
final int b = 2;
final int c = a.very.very.very.very.very.long.expression.that.returns.three.eventually().but.is.very.long();
final int d = 4;
final int e = 5;
```

```dart
// BAD (breaks after assignment operator)
final List<FooBarBaz> _members =
  <FooBarBaz>[const Quux(), const Qaax(), const Qeex()];

// BETTER (only slightly goes over 80 chars)
final List<FooBarBaz> _members = <FooBarBaz>[const Quux(), const Qaax(), const Qeex()];

// BETTER STILL (fits in 80 chars)
final List<FooBarBaz> _members = <FooBarBaz>[
  const Quux(),
  const Qaax(),
  const Qeex(),
];
```

### Indent multi-line argument and parameter lists by 2 characters

When breaking an argument list into multiple lines, indent the arguments two characters from the previous line.

Example:

```dart
Foo f = Foo(
  bar: 1.0,
  quux: 2.0,
);
```

When breaking a parameter list into multiple lines, do the same.

### If you have a newline after some opening punctuation, match it on the closing punctuation

And vice versa.

Example:

```dart
// BAD:
  foo(
    bar, baz);
  foo(
    bar,
    baz);
  foo(bar,
    baz
  );

// GOOD:
  foo(bar, baz);
  foo(
    bar,
    baz,
  );
  foo(bar,
    baz);
```

### Use a trailing comma for arguments, parameters, and list items, but only if they each have their own line

Example:

```dart
List<int> myList = [
  1,
  2,
];
myList = <int>[3, 4];

foo1(
  bar,
  baz,
);
foo2(bar, baz);
```

Whether to put things all on one line or whether to have one line per item is an aesthetic choice. We prefer whatever ends up being most readable. Typically this means that when everything would fit on one line, put it all on one line, otherwise, split it one item to a line.

However, there are exceptions. For example, if there are six back-to-back lists and all but one of them need multiple lines, then one would not want to have the single case that does fit on one line use a different style than the others.

```dart
// BAD (because the second list is unnecessarily and confusingly different than the others):
List<FooBarBaz> myLongList1 = <FooBarBaz>[
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
];
List<Quux> myLongList2 = <Quux>[ Quux(1), Quux(2) ];
List<FooBarBaz> myLongList3 = <FooBarBaz>[
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
];

// GOOD (code is easy to scan):
List<FooBarBaz> myLongList1 = <FooBarBaz>[
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
];
List<Quux> myLongList2 = <Quux>[
  Quux(1),
  Quux(2),
];
List<FooBarBaz> myLongList3 = <FooBarBaz>[
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
  FooBarBaz(one: firstArgument, two: secondArgument, three: thirdArgument),
];
```

### Prefer single quotes for strings

Use double quotes for nested strings or (optionally) for strings that contain single quotes. For all other strings, use single quotes.

Example:

```dart
print('Hello ${name.split(" ")[0]}');
```

### Consider using `⇒` for short functions and methods

But only use `⇒` when everything, including the function declaration, fits on a single line.

Example:

```dart
// BAD:
String capitalize(String s) =>
  '${s[0].toUpperCase()}${s.substring(1)}';

// GOOD:
String capitalize(String s) => '${s[0].toUpperCase()}${s.substring(1)}';

String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}
```

### Use `⇒` for inline callbacks that just return list or map literals

If your code is passing an inline closure that merely returns a list or map literal, or is merely calling another function, then if the argument is on its own line, then rather than using braces and a `return` statement, you can instead use the `⇒` form. When doing this, the closing `]`, `}`, or `)` bracket will line up with the argument name, for named arguments, or the `(` of the argument list, for positional arguments.

For example:

```dart
  // GOOD, but slightly more verbose than necessary since it doesn't use =>
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) { print('Selected: $value'); },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'Friends',
            child: MenuItemWithIcon(Icons.people, 'Friends', '5 new')
          ),
          PopupMenuItem<String>(
            value: 'Events',
            child: MenuItemWithIcon(Icons.event, 'Events', '12 upcoming')
          ),
        ];
      }
    );
  }

  // GOOD, does use =>, slightly briefer
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) { print('Selected: $value'); },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'Friends',
          child: MenuItemWithIcon(Icons.people, 'Friends', '5 new')
        ),
        PopupMenuItem<String>(
          value: 'Events',
          child: MenuItemWithIcon(Icons.event, 'Events', '12 upcoming')
        ),
      ]
    );
  }
```

The important part is that the closing punctuation lines up with the start of the line that has the opening punctuation, so that you can easily determine what's going on by just scanning the indentation on the left edge.

### Use braces for long functions and methods

Use a block (with braces) when a body would wrap onto more than one line (as opposed to using `⇒`; the cases where you can use `⇒` are discussed in the previous two guidelines).

### Separate the 'if' expression from its statement

Don't put the statement part of an 'if' statement on the same line as the expression, even if it is short. (Doing so makes it unobvious that there is relevant code there. This is especially important for early returns.)

Example:

```dart
// BAD:
if (notReady) return;

// GOOD:
// Use this style for code that is expected to be publicly read by developers
if (notReady) {
  return;
}
```

If the body is more than one line, or if there is an `else` clause, wrap the body in braces:

```dart
// BAD:
if (foo)
  bar(
    'baz',
  );

// BAD:
if (foo)
  bar();
else
  baz();

// GOOD:
if (foo) {
  bar(
    'baz',
  );
}

// GOOD:
if (foo) {
  bar();
} else {
  baz();
}
```

We require bodies to make it very clear where the bodies belong.

### Align expressions

Where possible, subexpressions on different lines should be aligned, to make the structure of the expression easier. When doing this with a `return` statement chaining `||` or `&&` operators, consider putting the operators on the left hand side instead of the right hand side.

```dart
// BAD:
if (foo.foo.foo + bar.bar.bar * baz - foo.foo.foo * 2 +
    bar.bar.bar * 2 * baz > foo.foo.foo) {
  // ...
}

// GOOD (notice how it makes it obvious that this code can be simplified):
if (foo.foo.foo     + bar.bar.bar     * baz -
    foo.foo.foo * 2 + bar.bar.bar * 2 * baz   > foo.foo.foo) {
  // ...
}
// After simplification, it fits on one line anyway:
if (bar.bar.bar * 3 * baz > foo.foo.foo * 2) {
  // ...
}
```

```dart
// BAD:
return foo.x == x &&
    foo.y == y &&
    foo.z == z;

// GOOD:
return foo.x == x &&
       foo.y == y &&
       foo.z == z;

// ALSO GOOD:
return foo.x == x
    && foo.y == y
    && foo.z == z;
```

### Prefer += over ++

We generally slightly prefer `+=` over `++`.

In some languages/compilers postfix `++` is an antipattern because of performance reasons, and so it's easier to just avoid it in general.

Because of the former, some people will use the prefix `++`, but this leads to statements that lead with punctuation, which is aesthetically displeasing.

In general, mutating variables as part of larger expressions leads to confusion about the order of operations, and entwines the increment with another calculation.

Using `++` does not make it obvious that the underlying variable is actually being mutated, whereas `+=` more clearly does (it's an assignment with an `=` sign).

Finally, `+=` is more convenient when changing the increment to a number other than 1.

### Use double literals for double constants

To make it clearer when something is a double or an integer, even if the number is a round number, include a decimal point in double literals. For example, if a function `foo` takes a double, write `foo(1.0)` rather than `foo(1)` because the latter makes it look like the function takes an integer.
