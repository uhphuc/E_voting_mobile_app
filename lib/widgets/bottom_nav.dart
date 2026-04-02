import 'package:flutter/material.dart';
import 'package:project/features/announcement/screen/announcement_screen.dart';
import 'package:project/features/auth/controllers/auth_provider.dart';
import 'package:project/features/home/screens/home_screen.dart';
import 'package:project/features/manage/screens/manager_screen.dart';
import 'package:project/features/manage/screens/voter_screen.dart';
import 'package:project/features/profile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fabAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    if (_currentIndex != index) {

      setState(() {
        _currentIndex = index;
      });

      // Reset animation cho icon mới
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    final _pages = user?.role == "manager"
        ? [
      const HomeScreen(),
      const ManagerScreen(),
      const AnnouncementScreen(),
      const ProfileScreen()
    ]
        : [
      const HomeScreen(),
      const VoterScreen(),
      const AnnouncementScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5170FF).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF5170FF),
            unselectedItemColor: Colors.grey.shade400,
            selectedFontSize: 13,
            unselectedFontSize: 12,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              _buildNavItem(Icons.home_outlined, Icons.home, "Home", 0),
              _buildNavItem(Icons.meeting_room_outlined, Icons.meeting_room, "Room", 1),
              _buildNavItem(Icons.notifications_none_outlined, Icons.notifications, "Notify", 2),
              _buildNavItem(Icons.person_outline, Icons.person, "Profile", 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData outlineIcon, IconData filledIcon, String label, int index) {
    final isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? 1.0 + (_fabAnimation.value * 0.1) : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5170FF).withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isSelected ? filledIcon : outlineIcon,
                color: isSelected ? const Color(0xFF5170FF) : Colors.grey.shade400,
                size: isSelected ? 26 : 24,
              ),
            ),
          );
        },
      ),
      label: label,
    );
  }
}

// Widget hỗ trợ animation chuyển trang
class PageTransitionSwitcher extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Widget Function(Widget, Animation<double>, Animation<double>) transitionBuilder;

  const PageTransitionSwitcher({
    super.key,
    required this.child,
    required this.duration,
    required this.transitionBuilder,
  });

  @override
  State<PageTransitionSwitcher> createState() => _PageTransitionSwitcherState();
}

class _PageTransitionSwitcherState extends State<PageTransitionSwitcher> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Widget? _oldWidget;
  Widget? _currentWidget;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _currentWidget = widget.child;
    _controller.forward();
  }

  @override
  void didUpdateWidget(PageTransitionSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _oldWidget = _currentWidget;
      _currentWidget = widget.child;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (_animation.status == AnimationStatus.completed) {
          return widget.transitionBuilder(_currentWidget!, _animation, _animation);
        }
        return Stack(
          children: [
            if (_oldWidget != null)
              FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_animation),
                child: _oldWidget,
              ),
            if (_currentWidget != null)
              widget.transitionBuilder(_currentWidget!, _animation, _animation),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}