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

    await HiveDatabase.newEnvelope(name, _selectedColor.value, goal!, 0.0, await HiveDatabase.envelopeOrder(_placeAtStart));

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            final w = constraints.maxWidth;
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

              // ── TOP HEADER: paw + title ──────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: w * 0.11,
                    height: w * 0.11,
                    child: Image.asset('assets/Cat_Paw.png',width: w * 0.11,height: h * 0.11,color:_blueText,),
                  ),
                  SizedBox(width: w * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Meownvelope',
                        style: GoogleFonts.mochiyPopPOne(
                          textStyle: TextStyle(fontSize: w * 0.06, color: _blueText),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: w * 0.3),
                        child: Text("Creation",
                          style: GoogleFonts.mochiyPopPOne(
                            textStyle: TextStyle(fontSize: w * 0.06, color: _blueText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: h * 0.04),

              // ── ENVELOPE NAME INPUT ──────────────────────────────
              Center(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SizedBox(
                      width: w * 0.75,
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: _monoStyle(w * 0.065, _blueText),
                        decoration: InputDecoration(
                          hintText: 'New Envelope',
                          hintStyle: _monoStyle(w * 0.05, _blueText.withOpacity(0.5), letterSpacing: 1.2),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: _blueText)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: _blueText, width: 2)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: _blueText.withOpacity(0.5))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: w * -0.02,
                      child: Image.asset(
                        'assets/Vector.png',
                        width: w * 0.12,
                        height: h * 0.12,
                        color: _blueText,)

                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.06),

              // ── ENVELOPE PREVIEW + COLOR PICKER ─────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: h * 0.20,
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
                            height: h * 0.20,
                          ),
                          Positioned(
                            top: 10,
                            child:
                            Text(
                              _nameController.text.isEmpty ? 'New Envelope' : _nameController.text,
                              style: _monoStyle(w * 0.037,_blueText.withOpacity(0.8),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.07),
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
              SizedBox(height: h * 0.06),

              // ── PLACEMENT RADIO BUTTONS ──────────────────────────
              _PlacementOption(
                label: 'Place my envelope at the\n start of my list.',
                value: true,
                groupValue: _placeAtStart,
                activeColor: _blueText,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              SizedBox(height: h * 0.03),
              _PlacementOption(
                label: 'Place my envelope at the\n end of my list.',
                value: false,
                groupValue: _placeAtStart,
                activeColor: _blueText,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              SizedBox(height: h * 0.05),

              // ── ENVELOPE GOAL ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Envelope goal:',
                    style: _monoStyle(w * 0.055, _blueText,),
                  ),
                  Text("\$",
                    style: _monoStyle( w * 0.055, _blueText),
                  ),
                  SizedBox(width: w * 0.015),
                  SizedBox(
                    width: w * 0.18,
                    child: TextField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      style: _monoStyle(w * 0.04, _blueText,),
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
              SizedBox(height: h * 0.07),

              // ── CREATE / CANCEL BUTTONS ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _createEnvelope,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: h * 0.018),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                          child: Text('Create', style: _monoStyle(w * 0.04, Colors.white)),
                      ),
                    ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _btnColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: h * 0.018),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                          child: Text('Cancel', style: _monoStyle(w * 0.04, Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
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


