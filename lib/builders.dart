library jiggle;

import 'package:flutter/material.dart';
import 'package:jiggle/jiggle.dart';

/// A builder that builds a widget given a child.
/// The child should typically be part of the returned widget tree.
typedef JiggleStateBuilder = Widget Function(BuildContext context, JiggleState? state);

class JiggleBuilder extends StatelessWidget {
  /// Creates a widget that delegates its build to a callback.
  ///
  /// The [builder] argument must not be null.
  const JiggleBuilder({
    Key? key,
    required this.controller,
    required this.builder,
  })  : assert(builder != null),
        super(key: key);

  final JiggleStateBuilder builder;

  final JiggleController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JiggleState>(
      stream: controller.stream,
      builder: (context, snapshot) => builder(context, snapshot.data),
    );
  }
}

extension BuilderExtension on JiggleController {
  JiggleBuilder builderJiggleState({
    Key? key,
    required JiggleStateBuilder builder,
  }) =>
      JiggleBuilder(
        key: key,
        builder: builder,
        controller: this,
      );
}
