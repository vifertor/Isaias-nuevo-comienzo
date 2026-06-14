import 'package:flutter/material.dart';
import 'er_widgets.dart';

/// ROOM 4 — Final Vault: animated lock + epic success screen
class EscapeRoomRoom4 extends StatefulWidget {
  final Map<String, String> codes;
  final VoidCallback onComplete;
  const EscapeRoomRoom4({super.key, required this.codes, required this.onComplete});
  @override
  State<EscapeRoomRoom4> createState() => _EscapeRoomRoom4State();
}

class _EscapeRoomRoom4State extends State<EscapeRoomRoom4>
    with TickerProviderStateMixin {
  final TextEditingController _ctrl = TextEditingController();
  bool _wrong = false;
  bool _unlocked = false;

  late AnimationController _shakeCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _unlockCtrl;
  late AnimationController _celebrateCtrl;

  late Animation<double> _shakeAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _unlockScale;
  late Animation<double> _unlockOpacity;
  late Animation<double> _celebrateScale;

  String get _hint {
    final r1 = widget.codes['r1'] ?? '0A';
    final r2 = widget.codes['r2'] ?? '0B';
    final r3 = widget.codes['r3'] ?? '0C';
    return '${r1[0]} — ${r2[0]} — ${r3[0]}';
  }

  @override
  void initState() {
    super.initState();

    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    _unlockCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _celebrateCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);

    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -16.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -16.0, end: 16.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 16.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(_shakeCtrl);

    _glowAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _unlockScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _unlockCtrl, curve: Curves.elasticOut));
    _unlockOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _unlockCtrl, curve: const Interval(0, 0.4)));
    _celebrateScale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _celebrateCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _glowCtrl.dispose();
    _unlockCtrl.dispose();
    _celebrateCtrl.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (_ctrl.text.trim().length >= 3) {
      setState(() => _unlocked = true);
      _glowCtrl.stop();
      _unlockCtrl.forward();
    } else {
      setState(() => _wrong = true);
      _shakeCtrl.forward(from: 0);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _wrong = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _unlocked ? _buildSuccessScreen() : _buildPuzzleScreen();
  }

  Widget _buildPuzzleScreen() {
    const accent = Color(0xFFFFB703);

    return ERScaffold(
      topColor: const Color(0xFF0A0A1A),
      botColor: const Color(0xFF1A1500),
      roomLabel: '🔮 Room 4 — Final Puzzle',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ERProgress(current: 0, total: 1, color: accent),
          const SizedBox(height: 16),

          // Pilot character
          DialogueScene(
            characterFace: '😨',
            characterBody: '👨‍✈️',
            characterColor: accent,
            characterName: 'Captain Rivera',
            message: 'YOU MADE IT! This is the final room. The passport is locked in this vault. Combine your SCORES from the 3 rooms to build the secret 3-digit code!',
          ),
          const SizedBox(height: 24),

          // Score table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Scores  →  Combine them!',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 12),
                _scoreRow('📖', 'Room 1 — Vocabulary', widget.codes['r1'] ?? '?'),
                _scoreRow('✍️', 'Room 2 — Grammar', widget.codes['r2'] ?? '?'),
                _scoreRow('🎧', 'Room 3 — Listening', widget.codes['r3'] ?? '?'),
                const Divider(color: Colors.white24, height: 20),
                Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    const Text('Your code: ', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    Text(_hint, style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 4)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Vault + code input
          _buildVault(accent),
          const SizedBox(height: 20),

          // Input
          AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_wrong ? _shakeAnim.value : 0, 0),
              child: child,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _wrong ? ERColors.red : accent, width: 3),
                boxShadow: [BoxShadow(
                  color: (_wrong ? ERColors.red : accent).withAlpha(80),
                  blurRadius: 16,
                )],
              ),
              child: TextField(
                controller: _ctrl,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
                maxLength: 6,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 12,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '_ _ _',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(50), fontSize: 32, letterSpacing: 12),
                  filled: true,
                  fillColor: const Color(0xFF0D1B2A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 22),
                ),
              ),
            ),
          ),
          if (_wrong) ...[
            const SizedBox(height: 8),
            const Text('❌ Enter at least 3 characters!', textAlign: TextAlign.center,
              style: TextStyle(color: ERColors.red, fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 20),
          ERNextButton(label: '🔓  Unlock the Passport!', onTap: _check, color: accent),
        ],
      ),
    );
  }

  Widget _buildVault(Color accent) {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, child) => Center(
        child: Container(
          width: 140, height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0D1B2A),
            border: Border.all(color: _wrong ? ERColors.red : accent, width: 4),
            boxShadow: [
              BoxShadow(
                color: (_wrong ? ERColors.red : accent).withAlpha((180 * _glowAnim.value).toInt()),
                blurRadius: 30,
                spreadRadius: 8,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(_wrong ? '❌' : '🔒', style: const TextStyle(fontSize: 64)),
        ),
      ),
    );
  }

  Widget _scoreRow(String icon, String label, String code) {
    final digit = code.isNotEmpty ? code[0] : '?';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600))),
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: ERColors.accent.withAlpha(40),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ERColors.accent.withAlpha(150)),
            ),
            alignment: Alignment.center,
            child: Text(digit, style: const TextStyle(color: ERColors.accent, fontWeight: FontWeight.w900, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A2A0A), Color(0xFF0D4A0D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _unlockOpacity,
            child: ScaleTransition(
              scale: _unlockScale,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated passport
                    AnimatedBuilder(
                      animation: _celebrateScale,
                      builder: (_, child) => Transform.scale(
                        scale: _celebrateScale.value,
                        child: child,
                      ),
                      child: Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0D4A0D),
                          border: Border.all(color: ERColors.accent, width: 4),
                          boxShadow: [
                            BoxShadow(color: ERColors.accent.withAlpha(150), blurRadius: 40, spreadRadius: 10),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text('📘', style: TextStyle(fontSize: 80)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('🎉 🎊 🎉', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 16),

                    // Characters celebrating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _miniChar('😄', '🧳', ERColors.accent),
                        const SizedBox(width: 16),
                        _miniChar('😤', '👮', ERColors.lightBlue),
                        const SizedBox(width: 16),
                        _miniChar('😮', '📢', const Color(0xFFA855F7)),
                        const SizedBox(width: 16),
                        _miniChar('😨', '👨‍✈️', ERColors.orange),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [BoxShadow(color: ERColors.accent.withAlpha(120), blurRadius: 30)],
                      ),
                      child: Column(
                        children: [
                          const Text('PASSPORT RECOVERED!', style: TextStyle(
                            color: Color(0xFF0D1B2A),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          )),
                          const SizedBox(height: 10),
                          const Text(
                            'Congratulations! You solved all 4 challenges and recovered the passport. Your flight is SAVED! ✈️',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0x881B263B), fontSize: 14, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    ERNextButton(
                      label: '🏆  See Final Results!',
                      onTap: widget.onComplete,
                      color: ERColors.accent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniChar(String face, String body, Color color) {
    return TalkingCharacter(
      face: face,
      body: body,
      bubbleColor: color,
      size: 52,
      isTalking: true,
    );
  }
}
