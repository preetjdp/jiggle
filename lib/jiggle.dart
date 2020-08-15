library jiggle;

export 'builders.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vector_math/vector_math.dart';
import 'package:basics/basics.dart';


/// Jiggle your Widgets. 👯‍♀️
///
/// Jiggle is useful if you wish to indicate a state of uncertainity or
/// grab the attendtion of somebody.
class Jiggle extends StatefulWidget {
  Jiggle(
      {@required this.child,
      @required this.jiggleController,
      this.extent = 1,
      this.duration = const Duration(milliseconds: 80),
      this.useGestures = false});

  /// This is the extent in degress to which the Widget rotates.
  ///
  /// This defaults to 80 milliseconds.
  final double extent;

  /// This is the duration for which a `Jiggle` lasts.
  ///
  /// This defaults to 80 milliseconds.
  final Duration duration;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The jiggle controller.
  final JiggleController jiggleController;

  /// Set this property to true to automatically
  /// start jiggling when long pressed on the Widget.
  ///
  /// This defaults to false.
  final bool useGestures;

  @override
  _JiggleState createState() => _JiggleState();
}

class _JiggleState extends State<Jiggle> with SingleTickerProviderStateMixin {
  AnimationController _jiggleAnimationController;
  Animation<double> jiggleAnimation;

  @override
  void initState() {
    _jiggleAnimationController = AnimationController(
        vsync: this,
        duration: widget.duration,
        value: 0,
        lowerBound: -1,
        upperBound: 1);

    jiggleAnimation = Tween<double>(begin: 0, end: widget.extent)
        .animate(_jiggleAnimationController);

    _jiggleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _jiggleAnimationController.repeat(reverse: true);
      }
    });
    super.initState();
  }

  void listenForJiggles() {
    widget.jiggleController.stream.listen((event) {
      // print("From Listen" + event.toString());
      if (event == JiggleState.STATIC) {
        _jiggleAnimationController.animateTo(1, duration: Duration.zero);
        _jiggleAnimationController.stop();
      } else if (event == JiggleState.JIGGLING) {
        _jiggleAnimationController.forward();
      }
    });
  }

  void _onLongPress() {
    if (widget.useGestures) widget.jiggleController.toggle();
  }

  @override
  Widget build(BuildContext context) {
    listenForJiggles();
    return GestureDetector(
      onLongPress: _onLongPress,
      child: AnimatedBuilder(
          animation: jiggleAnimation,
          child: widget.child,
          builder: (BuildContext context, Widget child) {
            return Transform.rotate(
              angle: radians(jiggleAnimation.value),
              child: child,
            );
          }),
    );
  }
}

enum JiggleState { JIGGLING, STATIC }

typedef JiggleControllerBuilder = Widget Function(
    BuildContext context, bool isJiggling);

class JiggleController {
  BehaviorSubject<JiggleState> _jiggleSubject =
      BehaviorSubject.seeded(JiggleState.STATIC);

  Stream<JiggleState> get stream => _jiggleSubject.stream.asBroadcastStream();

  JiggleController() {
    stream.listen((event) {
      print("Constructor " + event.toString());
    });
  }

  void toggle() {
    HapticFeedback.mediumImpact();
    if (_jiggleSubject.value == JiggleState.STATIC) {
      _jiggleSubject.value = JiggleState.JIGGLING;
    } else {
      _jiggleSubject.value = JiggleState.STATIC;
    }
  }

  void dispose() {
    _jiggleSubject.close();
  }

  Widget isJigglingBuilder({JiggleControllerBuilder builder}) {
    return StreamBuilder<bool>(
      stream: _jiggleSubject.map((event) => event == JiggleState.JIGGLING),
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> data) {
        return builder(context, data.data);
      },
    );
  }
}
