import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// No code generation needed — envelopes are stored as Maps in Hive
// {
//   'name': 'Groceries',
//   'color': 4294940672,
//   'goal': 100.0,
//   'placeAtStart': true,
//   'balance': 0.0,
// }

class EnvelopeCreationPage extends StatefulWidget {
  const EnvelopeCreationPage({super.key});

  @override
  State<EnvelopeCreationPage> createState() => _EnvelopeCreationPageState();
}

class _EnvelopeCreationPageState extends State<EnvelopeCreationPage> {
  // ── Controllers ────────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  // ── Preset colors (matches design grid) ────────────────────────
  final List<Color> _presetColors = [
    const Color(0xFFFFB3B3), // pink
    const Color(0xFFFFE0A3), // yellow
    const Color(0xFFB3F0C0), // green
    const Color(0xFFD9B3FF), // purple
    const Color(0xFFB3D9FF), // blue
    const Color(0xFFD3D3D3), // grey
    const Color(0xFFFFCCE5), // light pink
    const Color(0xFFB3FFEE), // mint
  ];

  Color _selectedColor = const Color(0xFFFFB3B3); // default pink
  bool _placeAtStart = true;

  // ── App colors ─────────────────────────────────────────────────
  static const Color _bgColor      = Color(0xFFD6E4EF); // page background
  static const Color _blueText     = Color(0xFF5B87B0); // main blue text
  static const Color _btnColor     = Color(0xFF7AAAC8); // button blue
  static const Color _backBtnColor = Color(0xFF5B7FA6); // back button darker blue

  // ── Save to Hive ───────────────────────────────────────────────
  Future<void> _createEnvelope() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an envelope name')),
      );
      return;
    }

    double? goal;
    if (_goalController.text.isNotEmpty) {
      goal = double.tryParse(_goalController.text);
      if (goal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid goal amount')),
        );
        return;
      }
    }

    final box = Hive.box('envelopes');
    await box.add({
      'name': name,
      'color': _selectedColor.value,
      'goal': goal,
      'placeAtStart': _placeAtStart,
      'balance': 0.0,
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$name" envelope created!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── TOP HEADER: paw + title ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    child: Image.asset('assets/Cat_Paw.png',width: 48,height: 48,color:_blueText,),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Meownvelope Creation',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _blueText, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── ENVELOPE NAME INPUT ──────────────────────────────
              Center(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SizedBox(
                      width: 260,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40, color: _blueText, fontWeight: FontWeight.w500, letterSpacing: 1.2),
                        decoration: InputDecoration(
                          hintText: 'New Envelope',
                          hintStyle: TextStyle(color: _blueText.withOpacity(0.5), fontSize: 30, letterSpacing: 1.2),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: _blueText)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _blueText, width: 2)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _blueText.withOpacity(0.5))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10,
                      child: Image.asset(
                        'assets/Vector.png',
                        width: 50,
                        height: 50,
                        color: _blueText,)

                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // ── ENVELOPE PREVIEW + COLOR PICKER ─────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 120,
                      child:Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/Envelope.png',
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 120,
                          ),
                          Positioned(
                            top: 10,
                            child:
                            Text(
                              _nameController.text.isEmpty ? 'New Envelope' : _nameController.text,
                              style: TextStyle(
                                color: _blueText.withOpacity(0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: _presetColors.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _presetColors.length) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              border: Border.all(color: _blueText.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(Icons.add, color: _blueText, size: 18),
                          );
                        }
                        final color = _presetColors[index];
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(6),
                              border: isSelected
                                  ? Border.all(color: _blueText, width: 2.5)
                                  : Border.all(color: Colors.transparent),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // ── PLACEMENT RADIO BUTTONS ──────────────────────────
              _PlacementOption(
                label: 'Place my envelope at the start of my list.',
                value: true,
                groupValue: _placeAtStart,
                activeColor: _blueText,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              const SizedBox(height: 10),
              _PlacementOption(
                label: 'Place my envelope at the end of my list.',
                value: false,
                groupValue: _placeAtStart,
                activeColor: _blueText,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              const SizedBox(height: 50),

              // ── ENVELOPE GOAL ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Envelope goal:  \$  ',
                    style: TextStyle(fontSize: 30, color: _blueText, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _blueText.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: _blueText, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),

              // ── CREATE / CANCEL BUTTONS ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createEnvelope,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Create',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Placement Option Widget ──────────────────────────────────────────────────

class _PlacementOption extends StatelessWidget {
  final String label;
  final bool value;
  final bool groupValue;
  final Color activeColor;
  final ValueChanged<bool?> onChanged;

  const _PlacementOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<bool>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: activeColor,
        ),
        Text(label, style: TextStyle(fontSize: 17, color: activeColor)),
      ],
    );
  }
}

// ─── Envelope Painter ─────────────────────────────────────────────────────────

class _EnvelopePainter extends CustomPainter {
  final Color color;
  _EnvelopePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left and right edges
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);

    // Top flap V
    final flapPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.45)
      ..lineTo(size.width, 0);
    canvas.drawPath(flapPath, paint);

    // Bottom V
    final bottomPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, size.height * 0.55)
      ..lineTo(size.width, size.height);
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(_EnvelopePainter oldDelegate) =>
      oldDelegate.color != color;
}

// ─── Hive Setup in main.dart ──────────────────────────────────────────────────
// await Hive.openBox('envelopes');
//
// Navigate to this page:
// Navigator.push(context, MaterialPageRoute(
//   builder: (_) => const EnvelopeCreationPage(),
// ));
