import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const AnimatedIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  AnimatedIndexedStackState createState() => AnimatedIndexedStackState();
}

class AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late int _currentIndex;
  late int _previousIndex;
  bool _ongoing = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _previousIndex = widget.index;

    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(AnimatedIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.index == _currentIndex) return;

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = widget.index;
      _ongoing = true;
    });

    _controller.forward(from: 0).then((_) => setState(() {
      _ongoing = false;
    }));
  }

  @override
  void dispose() {
    _ongoing = false; // Just in case
    _controller.dispose();
    super.dispose();
  }

  Offset _incomingBegin(bool forward) => forward ? const Offset(1, 0) : const Offset(-1, 0);
  Offset _outgoingEnd(bool forward) => forward ? const Offset(-1, 0) : const Offset(1, 0);

  @override
  Widget build(BuildContext context) {
    final isForward = _currentIndex > _previousIndex;
    final animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    
    if (!_ongoing) return widget.children[_currentIndex]; // One navigator at a time otherwise router goes insane

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // outgoing
        SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: _outgoingEnd(isForward),
          ).animate(animation),
          child: widget.children[_previousIndex],
        ),

        // incoming
        SlideTransition(
          position: Tween<Offset>(
            begin: _incomingBegin(isForward),
            end: Offset.zero,
          ).animate(animation),
          child: widget.children[_currentIndex],
        ),
      ],
    );
  }
}