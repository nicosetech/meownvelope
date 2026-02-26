import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';

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
  const Color(0xFFFFCCCC), // pink
  const Color(0xFFFFEDCC), // yellow
  const Color(0xFFCCF5D5), // green
  const Color(0xFFE8CCFF), // purple
  const Color(0xFFCCE5FF), // blue
  const Color(0xFFE8E8E8), // grey
  const Color(0xFFFFE5F2), // light pink
  const Color(0xFFCCFFED), // mint
  const Color(0xFFFFFFFF), // white
  ];

  Color _selectedColor = const Color(0xFFFFFFFF); // default white
  bool _placeAtStart = true;

  // ── App colors ─────────────────────────────────────────────────
  static const Color _bgColor      = Color(0xFFF0F6FA); // page background
  static const Color _blueText     = Color(0xFF5B87B0); // main blue text
  static const Color _btnColor     = Color(0xFF7AAAC8); // button blue

  // ── Fonts ─────────────────────────────────────────────────────
  static TextStyle _monoStyle(double size, Color color, {
    double? letterSpacing,
    FontStyle? fontStyle,
  }) => GoogleFonts.martianMono(
    textStyle: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w600,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
    ),
  );

  //  ── Envelope Type Display ───────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _nameController.addListener((){
      setState(() {});
    });
  }
  

  // ── Save to Hive ───────────────────────────────────────────────
  Future<void> _createEnvelope() async {
    final name = _nameController.text.trim();
    const nonInclusive = {'/','"','\'','*','\\', '#',};

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an envelope name')),
      );
      return;
    }

    if (name.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name must be 20 characters or less')),
      );
      return;
    }

    if (nonInclusive.any((char) => name.contains(char))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name contains invalid characters')),
      );
      return;
    }

    if (_goalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a goal amount'))
      );
    return;
    }

    double goal = double.tryParse(_goalController.text)!;
    if (goal < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal must be greater than 0')),
      );
      return;
    }

 // await HiveDatabase.newEnvelope(name, _selectedColor.value, goal!, 0.0, HiveDatabase.EnvelopeOrder(_placeAtStart),);

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text('Meownvelope',
                        style: GoogleFonts.mochiyPopPOne(
                          textStyle: TextStyle(fontSize: 30, color: _blueText),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left:180),
                        child: Text("Creation",
                          style: GoogleFonts.mochiyPopPOne(
                            textStyle: TextStyle(fontSize:30, color: _blueText),
                          ),
                        ),
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
                      width: 320,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: _monoStyle(28, _blueText),
                        decoration: InputDecoration(
                          hintText: 'New Envelope',
                          hintStyle: _monoStyle(20, _blueText.withOpacity(0.5), letterSpacing: 1.2),
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
                      height: 180,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/Envelope.png',
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 200,
                          ),
                          Positioned(
                            top: 10,
                            child:
                            Text(
                              _nameController.text.isEmpty ? 'New Envelope' : _nameController.text,
                              style: _monoStyle(18,_blueText.withOpacity(0.8),
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
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _presetColors.length,
                      itemBuilder: (context, index) {
                        final color = _presetColors[index];
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(1),
                              border: isSelected
                                  ? Border.all(color: _blueText, width: 2.5)
                                  : Border.all(color: _blueText.withOpacity(1), width: 2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),

              // ── PLACEMENT RADIO BUTTONS ──────────────────────────
              _PlacementOption(
                label: 'Place my envelope at the\n start of my list.',
                value: true,
                groupValue: _placeAtStart,
                activeColor: _blueText,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              const SizedBox(height: 30),
              _PlacementOption(
                label: 'Place my envelope at the\n end of my list.',
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
                  Text('Envelope goal:',
                    style: _monoStyle(25, _blueText,),
                  ),
                  Text("\$",
                    style: _monoStyle(35, _blueText),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      style: _monoStyle(18, _blueText,),
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
              const SizedBox(height: 70),

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
        Transform.scale(
          scale: 1.8,
          child: Radio<bool>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: activeColor,
            fillColor: MaterialStateProperty.all(activeColor),
          ),
        ),
        const SizedBox(width:10),
        Expanded(
          child: Text(label, style: GoogleFonts.martianMono(
            textStyle: TextStyle(
              fontSize: 17,
              color: activeColor,
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
          )),
        ),
      ],
    );
  }
}

// ─── Hive Setup in main.dart ──────────────────────────────────────────────────
// await Hive.openBox('envelopes');
//
// Navigate to this page:
// Navigator.push(context, MaterialPageRoute(
//   builder: (_) => const EnvelopeCreationPage(),
// ));


