import 'package:flutter/material.dart';
import 'er_widgets.dart';

class EscapeRoomFinish extends StatelessWidget {
  const EscapeRoomFinish({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ERColors.darkBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.flight_takeoff, size: 100, color: ERColors.accent),
              const SizedBox(height: 24),
              const Text(
                'CONGRATULATIONS!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ERColors.cream,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You found your passport and made it to the gate just in time! Have a great flight!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              ERNextButton(
                label: 'Back to Dashboard',
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
