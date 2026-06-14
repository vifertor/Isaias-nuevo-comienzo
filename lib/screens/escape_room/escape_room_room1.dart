import 'package:flutter/material.dart';
import 'er_widgets.dart';

/// ROOM 1 — Vocabulary: See picture, tap the correct word from 4 options
class EscapeRoomRoom1 extends StatefulWidget {
  final void Function(String code) onComplete;
  const EscapeRoomRoom1({super.key, required this.onComplete});
  @override
  State<EscapeRoomRoom1> createState() => _EscapeRoomRoom1State();
}

class _EscapeRoomRoom1State extends State<EscapeRoomRoom1>
    with TickerProviderStateMixin {
  int _qi = 0;
  int _correct = 0;
  int _selected = -1;
  bool _answered = false;

  late AnimationController _correctCtrl;
  late AnimationController _wrongCtrl;
  late Animation<double> _correctPop;
  late Animation<double> _wrongShake;

  final List<Map<String, dynamic>> _questions = [
    {
      'prompt': 'What is Alex holding in his hand?',
      'emoji': '📘',
      'label': 'PASSPORT',
      'options': ['Passport', 'Ticket', 'Map', 'Wallet'],
      'correct': 0,
      'charLine': 'Look at the object! What do we call this in English? Pick the right word!',
    },
    {
      'prompt': 'What is Alex carrying for the trip?',
      'emoji': '🧳',
      'label': 'LUGGAGE',
      'options': ['Backpack', 'Luggage', 'Cargo', 'Bag'],
      'correct': 1,
      'charLine': 'He packed everything for the trip. What are those bags called together?',
    },
    {
      'prompt': 'Where do passengers go before boarding?',
      'emoji': '🛃',
      'label': 'CUSTOMS',
      'options': ['Terminal', 'Lounge', 'Customs', 'Office'],
      'correct': 2,
      'charLine': 'They check your bags here when you enter a country. What is this place?',
    },
    {
      'prompt': 'What sign is at the airport gate?',
      'emoji': '✈️',
      'label': 'DEPARTURE',
      'options': ['Arrival', 'Delay', 'Departure', 'Landing'],
      'correct': 2,
      'charLine': 'The plane is leaving soon! What is the word for when a flight LEAVES?',
    },
    {
      'prompt': 'What does Alex need to get on the plane?',
      'emoji': '🎫',
      'label': 'BOARDING PASS',
      'options': ['Hall Pass', 'Work Badge', 'Boarding Pass', 'Club Card'],
      'correct': 2,
      'charLine': 'Without this, you cannot enter the plane. What is it called?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _correctCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _wrongCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _correctPop = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _correctCtrl, curve: Curves.elasticOut));
    _wrongShake = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 0.0), weight: 1),
    ]).animate(_wrongCtrl);
  }

  @override
  void dispose() {
    _correctCtrl.dispose();
    _wrongCtrl.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (_answered) return;
    final isCorrect = i == _questions[_qi]['correct'];
    setState(() {
      _selected = i;
      _answered = true;
      if (isCorrect) _correct++;
    });
    if (isCorrect) {
      _correctCtrl.forward(from: 0);
    } else {
      _wrongCtrl.forward(from: 0);
    }
  }

  void _next() {
    if (_qi < _questions.length - 1) {
      setState(() {
        _qi++;
        _selected = -1;
        _answered = false;
      });
      _correctCtrl.reset();
      _wrongCtrl.reset();
    } else {
      widget.onComplete('${_correct}A');
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_qi];
    final isCorrect = _answered && _selected == q['correct'];

    return ERScaffold(
      topColor: const Color(0xFF0D1B2A),
      botColor: const Color(0xFF1B3050),
      roomLabel: '🔑 Room 1 — Vocabulary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ERProgress(current: _qi + 1, total: _questions.length, color: ERColors.accent),
          const SizedBox(height: 16),

          // Talking character
          DialogueScene(
            key: ValueKey('r1_${_qi}'),
            characterFace: '😊',
            characterBody: '🧳',
            characterColor: ERColors.accent,
            characterName: 'Alex',
            message: q['charLine'] as String,
          ),
          const SizedBox(height: 20),

          // Object display card
          AnimatedBuilder(
            animation: _correctPop,
            builder: (_, child) => Transform.scale(
              scale: _answered && isCorrect ? _correctPop.value : 1.0,
              child: child,
            ),
            child: AnimatedBuilder(
              animation: _wrongShake,
              builder: (_, child) => Transform.translate(
                offset: Offset(_answered && !isCorrect ? _wrongShake.value : 0, 0),
                child: child,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: _answered
                      ? (isCorrect
                          ? ERColors.green.withAlpha(30)
                          : ERColors.red.withAlpha(30))
                      : Colors.white.withAlpha(15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _answered
                        ? (isCorrect ? ERColors.green : ERColors.red)
                        : Colors.white.withAlpha(40),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(q['emoji'] as String, style: const TextStyle(fontSize: 80)),
                    const SizedBox(height: 8),
                    Text(
                      q['prompt'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withAlpha(200), fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    if (_answered) ...[
                      const SizedBox(height: 10),
                      Text(
                        isCorrect ? '🎉 Correct! It\'s "${q['label']}"' : '❌ Not quite...',
                        style: TextStyle(
                          color: isCorrect ? ERColors.green : ERColors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          Text(
            'Choose the correct word:',
            style: TextStyle(color: Colors.white.withAlpha(160), fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 10),
          ...List.generate((q['options'] as List).length, (i) {
            final opt = (q['options'] as List)[i] as String;
            final isOpt = _selected == i;
            final isRightAnswer = i == q['correct'];
            Color bg = Colors.white.withAlpha(15);
            Color border = Colors.white.withAlpha(40);
            Color textColor = Colors.white;

            if (_answered) {
              if (isRightAnswer) { bg = ERColors.green.withAlpha(50); border = ERColors.green; textColor = ERColors.green; }
              else if (isOpt) { bg = ERColors.red.withAlpha(50); border = ERColors.red; textColor = ERColors.red; }
            } else if (isOpt) {
              bg = ERColors.accent.withAlpha(50);
              border = ERColors.accent;
            }

            return GestureDetector(
              onTap: () => _select(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: border, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _answered && isRightAnswer
                            ? ERColors.green
                            : _answered && isOpt
                                ? ERColors.red
                                : Colors.white.withAlpha(20),
                        border: Border.all(color: border, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _answered && isRightAnswer ? '✓' : _answered && isOpt ? '✗' : String.fromCharCode(65 + i),
                        style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(opt, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          if (_answered)
            ERNextButton(
              label: _qi < _questions.length - 1 ? 'Next Question  →' : '🔓 Unlock Room 2!',
              onTap: _next,
            ),
        ],
      ),
    );
  }
}
