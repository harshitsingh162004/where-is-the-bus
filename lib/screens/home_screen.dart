import 'package:flutter/material.dart';
import '../data/bus_stops.dart';
import 'bus_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? _selectedStartStop;
  String? _selectedEndStop;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _searchBuses() {
    if (_selectedStartStop == null || _selectedEndStop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end stops')),
      );
      return;
    }

    if (_selectedStartStop == _selectedEndStop) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Start and end stops cannot be the same')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BusListScreen(
              startLocation: _selectedStartStop!,
              endLocation: _selectedEndStop!,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Bus Tracker'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_bus,
                            size: 64,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Track Your Bus',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Real-time bus tracking',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Select Route',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(height: 28),

                        /// FROM
                        DropdownButtonFormField<String>(
                          value: _selectedStartStop,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            prefixIcon: Icon(Icons.trip_origin),
                          ),
                          items:
                              busStops
                                  .map(
                                    (stop) => DropdownMenuItem(
                                      value: stop.name,
                                      child: Text(stop.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => _selectedStartStop = value),
                        ),

                        const SizedBox(height: 24),

                        /// TO
                        DropdownButtonFormField<String>(
                          value: _selectedEndStop,
                          decoration: const InputDecoration(
                            labelText: 'To',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          items:
                              busStops
                                  .map(
                                    (stop) => DropdownMenuItem(
                                      value: stop.name,
                                      child: Text(stop.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) =>
                                  setState(() => _selectedEndStop = value),
                        ),

                        const SizedBox(height: 36),
                        ElevatedButton.icon(
                          onPressed: _searchBuses,
                          icon: const Icon(Icons.search),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Find Buses',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
