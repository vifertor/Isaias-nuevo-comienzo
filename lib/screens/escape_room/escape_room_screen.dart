import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'escape_room_story.dart';
import 'escape_room_room1.dart';
import 'escape_room_room2.dart';
import 'escape_room_room3.dart';
import 'escape_room_room4.dart';
import 'escape_room_finish.dart';

class EscapeRoomScreen extends StatefulWidget {
  const EscapeRoomScreen({super.key});
  @override
  State<EscapeRoomScreen> createState() => _EscapeRoomScreenState();
}

class _EscapeRoomScreenState extends State<EscapeRoomScreen> {
  int _phase = 0;
  final Map<String, String> _codes = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _advance() => setState(() => _phase++);
  void _saveCode(String room, String code) {
    _codes[room] = code;
    _advance();
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case 0: return EscapeRoomStory(onFinish: _advance);
      case 1: return EscapeRoomRoom1(onComplete: (c) => _saveCode('r1', c));
      case 2: return EscapeRoomRoom2(onComplete: (c) => _saveCode('r2', c));
      case 3: return EscapeRoomRoom3(onComplete: (c) => _saveCode('r3', c));
      case 4: return EscapeRoomRoom4(codes: _codes, onComplete: _advance);
      case 5: return const EscapeRoomFinish();
      default: return const EscapeRoomFinish();
    }
  }
}
