import 'package:flutter/material.dart';

/// Extension methods for Widget to provide SwiftUI-like modifier syntax
extension WidgetExtensions on Widget {
  /// Wraps the widget in an Expanded widget
  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  /// Wraps the widget in a Flexible widget
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: this,
    );
  }

  /// Wraps the widget in a Padding widget
  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  /// Adds symmetric padding
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }

  /// Adds padding on all sides
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  /// Adds padding only on specific sides
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// Wraps the widget in a Center widget
  Widget center() {
    return Center(child: this);
  }

  /// Wraps the widget in an Align widget
  Widget align(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  /// Wraps the widget in a SizedBox with width and height
  Widget sized({double? width, double? height}) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// Wraps the widget in a Container
  Widget container({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Wraps the widget in a DecoratedBox
  Widget decorated(Decoration decoration) {
    return DecoratedBox(
      decoration: decoration,
      child: this,
    );
  }

  /// Wraps the widget with rounded corners
  Widget rounded(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// Wraps the widget in an Opacity widget
  Widget opacity(double opacity) {
    return Opacity(
      opacity: opacity,
      child: this,
    );
  }

  /// Wraps the widget in a GestureDetector
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  /// Wraps the widget in an InkWell
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
  }) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      child: this,
    );
  }

  /// Wraps the widget in a Hero widget for animations
  Widget hero(String tag) {
    return Hero(
      tag: tag,
      child: this,
    );
  }

  /// Wraps the widget in a Positioned widget (for use in Stack)
  Widget positioned({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: this,
    );
  }

  /// Wraps the widget in a Transform.scale widget
  Widget scale(double scale) {
    return Transform.scale(
      scale: scale,
      child: this,
    );
  }

  /// Wraps the widget in a Transform.rotate widget
  Widget rotate(double angle) {
    return Transform.rotate(
      angle: angle,
      child: this,
    );
  }

  /// Wraps the widget in a Visibility widget
  Widget visible(bool visible) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  /// Wraps the widget in an IgnorePointer widget
  Widget ignorePointer({bool ignoring = true}) {
    return IgnorePointer(
      ignoring: ignoring,
      child: this,
    );
  }

  /// Wraps the widget in an AbsorbPointer widget
  Widget absorbPointer({bool absorbing = true}) {
    return AbsorbPointer(
      absorbing: absorbing,
      child: this,
    );
  }

  /// Wraps the widget in a SafeArea widget
  Widget safeArea({
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: this,
    );
  }

  /// Wraps the widget in a Card widget
  Widget card({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Wraps the widget in a FittedBox
  Widget fitted({BoxFit fit = BoxFit.contain}) {
    return FittedBox(
      fit: fit,
      child: this,
    );
  }

  /// Wraps the widget in a FractionallySizedBox
  Widget fractionalSize({double? widthFactor, double? heightFactor}) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: this,
    );
  }

  /// Wraps the widget in an AspectRatio widget
  Widget aspectRatio(double aspectRatio) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: this,
    );
  }

  /// Wraps the widget in a ConstrainedBox
  Widget constrained(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: constraints,
      child: this,
    );
  }

  /// Wraps the widget in a LimitedBox
  Widget limited({double maxWidth = double.infinity, double maxHeight = double.infinity}) {
    return LimitedBox(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      child: this,
    );
  }

  /// Wraps the widget in a SingleChildScrollView
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
  }) {
    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      physics: physics,
      child: this,
    );
  }

  /// Wraps the widget in a Material widget
  Widget material({
    Color? color,
    double elevation = 0,
    ShapeBorder? shape,
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.none,
  }) {
    return Material(
      color: color,
      elevation: elevation,
      shape: shape,
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Wraps the widget in an AnimatedContainer
  Widget animatedContainer({
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
  }) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      child: this,
    );
  }

  /// Wraps the widget in a SliverToBoxAdapter (for CustomScrollView)
  Widget sliverBox() {
    return SliverToBoxAdapter(child: this);
  }

  /// Wraps the widget in a Tooltip
  Widget tooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }

  /// Wraps the widget in a Semantics widget
  Widget semantics({
    String? label,
    bool? button,
    bool? enabled,
  }) {
    return Semantics(
      label: label,
      button: button,
      enabled: enabled,
      child: this,
    );
  }
}
