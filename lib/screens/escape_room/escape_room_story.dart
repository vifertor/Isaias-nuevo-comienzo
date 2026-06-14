import 'package:flutter/material.dart';
import 'er_widgets.dart';

class EscapeRoomStory extends StatefulWidget {
  final VoidCallback onFinish;
  const EscapeRoomStory({super.key, required this.onFinish});
  @override
  State<EscapeRoomStory> createState() => _EscapeRoomStoryState();
}

class _EscapeRoomStoryState extends State<EscapeRoomStory>
    with SingleTickerProviderStateMixin {
  int _sceneIndex = 0;
  bool _canNext = false;

  final List<_Scene> _scenes = const [
    _Scene(
      face: '😊',
      body: '🎒',
      charColor: Color(0xFFFFB703),
      charName: 'Alex',
      message: 'Hi! I\'m Alex, a student like you. Today we were supposed to fly to an international English conference... ✈️',
      topColor: Color(0xFF0D1B2A),
      botColor: Color(0xFF1B3A5C),
    ),
    _Scene(
      face: '😰',
      body: '🧳',
      charColor: Color(0xFFE63946),
      charName: 'Alex',
      message: 'But when I arrived at the airport... the security guard said my PASSPORT IS MISSING! 😱 Oh no!',
      topColor: Color(0xFF1A0A0A),
      botColor: Color(0xFF3A1010),
    ),
    _Scene(
      face: '😤',
      body: '👮',
      charColor: Color(0xFF778DA9),
      charName: 'Officer Carlos',
      message: 'Sorry sir. You cannot board without a passport. Your passport was taken to the English Department. You must solve 4 challenges to get it back.',
      topColor: Color(0xFF0A1520),
      botColor: Color(0xFF1B2A3B),
    ),
    _Scene(
      face: '🤔',
      body: '📧',
      charColor: Color(0xFF8CB369),
      charName: 'Alex',
      message: 'I just got an email! It says: "Your passport is locked behind 4 rooms. Solve VOCABULARY, GRAMMAR, LISTENING and the FINAL PUZZLE to escape!"',
      topColor: Color(0xFF0A200A),
      botColor: Color(0xFF1A3A1A),
    ),
    _Scene(
      face: '😎',
      body: '🔑',
      charColor: Color(0xFFFFB703),
      charName: 'Alex',
      message: 'OK! I need YOUR help! Let\'s solve the 4 rooms together and get my passport back before the flight leaves! Are you READY? 🚀',
      topColor: Color(0xFF1A1500),
      botColor: Color(0xFF2A2500),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scene = _scenes[_sceneIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scene.topColor, scene.botColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(_scenes.length, (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _sceneIndex ? 22 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: i == _sceneIndex ? scene.charColor : Colors.white.withAlpha(60),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Scene number badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: scene.charColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: scene.charColor.withAlpha(80)),
                  ),
                  child: Text(
                    'Scene ${_sceneIndex + 1} of ${_scenes.length}',
                    style: TextStyle(color: scene.charColor, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // Character + dialogue
                Expanded(
                  child: DialogueScene(
                    key: ValueKey(_sceneIndex),
                    characterFace: scene.face,
                    characterBody: scene.body,
                    characterColor: scene.charColor,
                    characterName: scene.charName,
                    message: scene.message,
                    onMessageDone: () => setState(() => _canNext = true),
                  ),
                ),
                const SizedBox(height: 20),

                // Next button
                AnimatedOpacity(
                  opacity: _canNext ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 400),
                  child: ERNextButton(
                    label: _sceneIndex < _scenes.length - 1 ? '→  Continue' : '🚀  Start the Mission!',
                    color: scene.charColor,
                    onTap: () {
                      if (_sceneIndex < _scenes.length - 1) {
                        setState(() {
                          _sceneIndex++;
                          _canNext = false;
                        });
                      } else {
                        widget.onFinish();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Scene {
  final String face;
  final String body;
  final Color charColor;
  final String charName;
  final String message;
  final Color topColor;
  final Color botColor;
  const _Scene({
    required this.face,
    required this.body,
    required this.charColor,
    required this.charName,
    required this.message,
    required this.topColor,
    required this.botColor,
  });
}
