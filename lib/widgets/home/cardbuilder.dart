// ignore_for_file: deprecated_member_use

// packages
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_floating_widget/widgets/floating_widget.dart';

// providers
// import '/providers/auth.dart';
// import '/providers/branch.dart';

// widgets
// import '/widgets/branchmang/addnew.dart';
import '/widgets/home/3DContainer.dart';
import '/widgets/home/animatedcolortxt.dart';

class BranchCardsBuilder extends StatefulWidget {
  final double cardWidth;
  final double cardHeight;
  final double imgWidth;
  final double horizontalSpacing;
  final double verticalSpacing;
  final Duration animationDuration;
  final Duration reverseDuration;
  final Gradient? gradient;
  final Gradient? hoveredgradient;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final NeumorphicLightSource lightSource;
  final double depth;
  final double intensity;
  final bool enableTilt;
  final bool isArabic;
  final double tiltAngle;
  final double hoverScale;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final void Function(int branchId)? onTap;

  const BranchCardsBuilder({
    super.key,
    this.cardWidth = 260,
    this.imgWidth = 120,
    required this.isArabic,
    this.cardHeight = 140,
    this.horizontalSpacing = 16,
    this.verticalSpacing = 16,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.reverseDuration = const Duration(milliseconds: 1000),
    this.gradient,
    this.hoveredgradient,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.lightSource = NeumorphicLightSource.bottomRight,
    this.depth = 10,
    this.intensity = 0.1,
    this.enableTilt = true,
    this.tiltAngle = 0,
    this.textStyle,
    this.padding,
    this.onTap,
    this.hoverScale = 1.05,
  });

  @override
  State<BranchCardsBuilder> createState() => _BranchCardsBuilderState();
}

class _BranchCardsBuilderState extends State<BranchCardsBuilder> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    // final authprovider = context.watch<AuthProvider>();
    // final branchProvider = Provider.of<BranchProvider>(context);
    // final branches = branchProvider.branches;
    return Wrap(
      spacing: widget.horizontalSpacing,
      runSpacing: widget.verticalSpacing,
      children: List.generate(3, (index) {
        // final branch = branches[index];
        final isHovered = hoveredIndex == index;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.cardWidth + widget.horizontalSpacing,
            ),
            child: MouseRegion(
              onEnter: (_) => setState(() => hoveredIndex = index),
              onExit: (_) => setState(() => hoveredIndex = null),
              child: AnimatedScale(
                scale: isHovered ? widget.hoverScale : 1.0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: GestureDetector(
                  // onTap: () => widget.onTap?.call(branch.id),
                  child: FloatingWidget(
                    verticalSpace: 2,
                    duration: widget.animationDuration,
                    reverseDuration: widget.reverseDuration,
                    child: Column(
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isHovered ? 1 : 0.25,
                          child: Container(
                            // width: widget.imgWidth,
                            width: 200,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isHovered ? 0 : 0,
                                  ),
                                  spreadRadius: 0.1,
                                  blurRadius: 50,
                                  offset: const Offset(0, -10),
                                ),
                              ],
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 10.w),
                              child:
                                  index == 0
                                      ? Image.asset(
                                        './assets/imgs/kingc.gif',
                                        fit: BoxFit.cover,
                                      )
                                      : index == 1
                                      ? Image.asset(
                                        './assets/imgs/queen.gif',
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        './assets/imgs/joker.gif',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: widget.cardWidth,
                          height: widget.cardHeight,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: AnimatedContainer(
                                  width: isHovered ? widget.cardWidth : 0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 250),
                                  child: AnimatedOpacity(
                                    opacity: isHovered ? 0.85 : 0,
                                    curve: Curves.easeOut,
                                    duration: const Duration(milliseconds: 250),
                                    child: Shimmer.fromColors(
                                      direction: ShimmerDirection.ltr,
                                      baseColor: Colors.purple,
                                      highlightColor: Colors.purpleAccent,
                                      enabled: isHovered,
                                      child: NeumorphicContainer(
                                        width: widget.cardWidth,
                                        height: widget.cardHeight,
                                        color: widget.color ?? Colors.black12,
                                        gradient:
                                            isHovered
                                                ? widget.hoveredgradient
                                                : widget.gradient ??
                                                    const LinearGradient(
                                                      colors: [
                                                        Colors.lightBlue,
                                                        Colors.purple,
                                                        Colors.deepPurple,
                                                      ],
                                                    ),
                                        borderRadius: widget.borderRadius,
                                        lightSource: widget.lightSource,
                                        depth: widget.depth,
                                        intensity: widget.intensity,
                                        enableTilt: widget.enableTilt,
                                        tiltAngle: widget.tiltAngle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              if (!isHovered)
                                AnimatedContainer(
                                  width: isHovered ? widget.cardWidth : 0,
                                  curve: Curves.easeIn,
                                  duration: const Duration(milliseconds: 250),
                                  child: NeumorphicContainer(
                                    width: widget.cardWidth,
                                    height: widget.cardHeight,
                                    color: widget.color ?? Colors.black12,
                                    gradient:
                                        widget.gradient ??
                                        const LinearGradient(
                                          colors: [
                                            Colors.lightBlue,
                                            Colors.purple,
                                            Colors.deepPurple,
                                          ],
                                        ),
                                    borderRadius: widget.borderRadius,
                                    lightSource: widget.lightSource,
                                    depth: widget.depth,
                                    intensity: widget.intensity,
                                    enableTilt: widget.enableTilt,
                                    tiltAngle: widget.tiltAngle,
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: HoverColorText(
                                  isHovered: isHovered,
                                  text:
                                      index == 0
                                          ? "King of Employees"
                                          : index == 1
                                          ? "Queen of Tickets"
                                          : "Jack of Rules",
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 5.sp,
                                    fontFamily:
                                        widget.isArabic ? "AlexReg" : 'Poppins',
                                  ),
                                  defaultColor: Colors.black87,
                                  hoverColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 35.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
