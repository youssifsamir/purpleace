// ignore_for_file: deprecated_member_use

// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// provider
import '/providers/sidebar.dart';

// widgets
import 'item.dart';
import 'logo.dart';
import 'user.dart';

class SidebarWidget extends StatefulWidget {
  const SidebarWidget({super.key});

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Show shadow if scrolled more than 0
    if (_scrollController.offset > 0 && !_showShadow) {
      setState(() {
        _showShadow = true;
      });
    } else if (_scrollController.offset <= 0 && _showShadow) {
      setState(() {
        _showShadow = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sidebarProvider = context.watch<SidebarProvider>();

    return Stack(
      children: [
        Container(
          width: 55.w,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 10.h),

              // Logo container with conditional shadow
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25.r)),
                child: LogoWithName(logoPath: './assets/imgs/logo.jpg'),
              ),
              SizedBox(height: 50.h),

              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 2.w,
                    radius: Radius.circular(8.r),
                    interactive: true,
                    scrollbarOrientation: ScrollbarOrientation.left,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: List.generate(
                          sidebarProvider.visibleSidebarItems.length,
                          (index) {
                            final item =
                                sidebarProvider.visibleSidebarItems[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: SelectableGradientContainer(
                                index: index,
                                icon: item['icon'],
                                text: item['text'],
                                onSelected: () {
                                  sidebarProvider.select(index);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              SidebarUserPanel(
                isLoggedIn: true, // or false
                userName: 'Youssif Samir',
                userRole: 'Admin',
                onLogout: () => Navigator.pop(context),
                onLogin: () => print('Login clicked'),
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),

        // Right gradient
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 2.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  colorScheme.shadow.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
