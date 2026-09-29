import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10,
            shadowColor: const Color(0xFF2196F3).withOpacity(0.4),
            textStyle: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 12,
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
            borderRadius: BorderRadius.circular(24),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          labelStyle: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white.withOpacity(0.75),
          selectedItemColor: Color(0xFF2196F3),
          unselectedItemColor: Colors.grey.shade600,
          elevation: 16,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Search')), // Placeholder for future screen
    const Center(child: Text('Notifications')), // Placeholder for future screen
    const Center(child: Text('Profile')), // Placeholder for future screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_rounded),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showUnselectedLabels: false,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedItemColor: Color(0xFF2196F3),
          ),
        ),
      ),
    );
  }
}
