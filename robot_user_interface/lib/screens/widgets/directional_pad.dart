import 'dart:async';
import 'package:flutter/material.dart';
import 'package:robot_user_interface/app_styles.dart';

enum DPadDirection { up, down, left, right }

class CustomDirectionalPad extends StatefulWidget {
  final Function(DPadDirection direction) onPressed;

  const CustomDirectionalPad({super.key, required this.onPressed});

  @override
  State<CustomDirectionalPad> createState() => _CustomDirectionalPadState();
}

class _CustomDirectionalPadState extends State<CustomDirectionalPad> {
  DPadDirection? _pressedDirection;
  Timer? _holdTimer;

  void _startHolding(DPadDirection direction) {
    _pressedDirection = direction;
    widget.onPressed(direction);

    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      widget.onPressed(direction);
    });

    setState(() {});
  }

  void _stopHolding() {
    _pressedDirection = null;
    _holdTimer?.cancel();
    setState(() {});
  }

  Color _getButtonColor(DPadDirection direction) {
    return _pressedDirection == direction
        ? AppStyles.generalColors['details']!
        : AppStyles.generalColors['primary']!;
  }

  Widget _buildButton({
    required DPadDirection direction,
    required IconData icon,
    required Alignment alignment,
    required double width,
    required double height,
  }) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTapDown: (_) => _startHolding(direction),
        onTapUp: (_) => _stopHolding(),
        onTapCancel: _stopHolding,
        child: Container(
          width: width,
          height: height,
          //padding: padding,
          decoration: BoxDecoration(
            color: _getButtonColor(direction),
            border: Border.all(color: AppStyles.generalColors['secondary']!),
            borderRadius:
                BorderRadius.all(Radius.circular(AppStyles.smallRadius)),
          ),
          child: Center(
              child: Icon(icon, color: AppStyles.generalColors['secondary'])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 200;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Up
          _buildButton(
            direction: DPadDirection.up,
            icon: Icons.keyboard_arrow_up,
            alignment: Alignment.topCenter,
            width: size / 3,
            height: size / 3,
          ),
          // Down
          _buildButton(
            direction: DPadDirection.down,
            icon: Icons.keyboard_arrow_down,
            alignment: Alignment.bottomCenter,
            width: size / 3,
            height: size / 3,
          ),
          // Left
          _buildButton(
            direction: DPadDirection.left,
            icon: Icons.keyboard_arrow_left,
            alignment: Alignment.centerLeft,
            width: size / 3,
            height: size / 3,
          ),
          // Right
          _buildButton(
            direction: DPadDirection.right,
            icon: Icons.keyboard_arrow_right,
            alignment: Alignment.centerRight,
            width: size / 3,
            height: size / 3,
          ),
          // Center (opcional)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: size / 3,
              height: size / 3,
              decoration: BoxDecoration(
                border:
                    Border.all(color: AppStyles.generalColors['secondary']!),
                borderRadius:
                    BorderRadius.all(Radius.circular(AppStyles.smallRadius)),
                color: AppStyles.generalColors['tertiary'],
                shape: BoxShape.rectangle,
              ),
              child: Icon(Icons.control_camera_rounded,
                  size: size / 4, color: AppStyles.generalColors['details']),
            ),
          ),
        ],
      ),
    );
  }
}
