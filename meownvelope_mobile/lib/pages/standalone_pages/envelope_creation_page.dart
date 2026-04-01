import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/envelope_preview.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/labeled_radio_option.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';

class EnvelopeCreationPage extends StatefulWidget {
  const EnvelopeCreationPage({super.key});

  @override
  State<EnvelopeCreationPage> createState() => _EnvelopeCreationPageState();
}

class _EnvelopeCreationPageState extends State<EnvelopeCreationPage> {
  // ── Controllers ────────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();


  Color _selectedColor = const Color(0xFFFFFFFF); // default white
  bool _placeAtStart = true; // true is front of list, false is end of list

// Envelope preview updates in real time
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

    if (_goalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a goal amount'))
      );
    return;
    }
    double? goal = double.tryParse(_goalController.text);
    if (goal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for the goal'))
      );
      return;
    }
    if (goal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal must be greater than 0')),
      );
      return;
    }

    await HiveDatabase.newEnvelope(name, _selectedColor.value, goal, 0.0, await HiveDatabase.envelopeOrder(_placeAtStart));

    // Passes envelope count into checkEnvelopeBadges() to check if user has hit 1,3,or 9 envelopes
    await HiveDatabase.checkEnvelopeBadges(HiveDatabase.getEnvelopes().length);

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
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(titleText: 'Envelope Creation'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = MediaQuery.of(context).size.height * 0.9; // height base
            final w = MediaQuery.of(context).size.width; // width base
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB( w * 0.06, h * 0.02, w * 0.06, h * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // ── ENVELOPE NAME INPUT ──────────────────────────────
              Center(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    SizedBox(
                      width: w * 0.75,
                      child: TextField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),
                          FilteringTextInputFormatter.deny("/"),
                          FilteringTextInputFormatter.deny('"'),
                          FilteringTextInputFormatter.deny("'"),
                          FilteringTextInputFormatter.deny("*"),
                          FilteringTextInputFormatter.deny("\\"),
                          FilteringTextInputFormatter.deny("#"),
                        ],
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: martian(fontSize: w * 0.065, color: MeownvelopeColors.darkBlue),
                        decoration: InputDecoration(
                          hintText: 'New Envelope',
                          hintStyle: martian(fontSize: w * 0.05, color: MeownvelopeColors.darkBlue.withOpacity(0.5), letterSpacing: 1.2),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: MeownvelopeColors.darkBlue)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MeownvelopeColors.darkBlue, width: 2)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MeownvelopeColors.darkBlue.withOpacity(0.5))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: w * -0.02,
                      child: Image.asset(
                        'assets/pencil_symbol.png',
                        width: w * 0.12,
                        height: h * 0.12,
                        color: MeownvelopeColors.darkBlue,)
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
                    child: EnvelopePreview(  
                      color: _selectedColor,
                      label: _nameController.text.isEmpty ? 'New Envelope' : _nameController.text,
                      width: double.infinity,
                      height: h * 0.20,
                      fontSize: w * 0.037,
                    ),
                  ),
                  SizedBox(width: w * 0.07),
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: MeownvelopeColors.presetEnvelopeColors.length,
                      itemBuilder: (context, index) {
                        final color = MeownvelopeColors.presetEnvelopeColors[index];
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(1),
                              border: isSelected
                                  ? Border.all(color: MeownvelopeColors.darkBlue, width: 2.5)
                                  : Border.all(color: MeownvelopeColors.darkBlue.withOpacity(1), width: 2),
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
              LabeledRadioOption(
                label: 'Place my envelope at the start of my list.',
                value: true,
                groupValue: _placeAtStart,
                activeColor: MeownvelopeColors.darkBlue,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              SizedBox(height: h * 0.03),
              LabeledRadioOption(
                label: 'Place my envelope at the end of my list.',
                value: false,
                groupValue: _placeAtStart,
                activeColor: MeownvelopeColors.darkBlue,
                onChanged: (val) => setState(() => _placeAtStart = val!),
              ),
              SizedBox(height: h * 0.05),

              // ── ENVELOPE GOAL ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Envelope goal:',
                    style: martian(fontSize: w * 0.055, color: MeownvelopeColors.darkBlue,),
                  ),
                  Text("\$",
                    style: martian( fontSize: w * 0.055,color: MeownvelopeColors.darkBlue),
                  ),
                  SizedBox(width: w * 0.015),
                  SizedBox(
                    width: w * 0.18,
                    child: TextField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*.?\d{0,2}'),),
                      ],
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      style: martian(fontSize: w * 0.04, color: MeownvelopeColors.darkBlue,),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MeownvelopeColors.darkBlue.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: MeownvelopeColors.darkBlue, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.1),

              // ── CREATE / CANCEL BUTTONS ──────────────────────────
              Row(
                children: [
                  Expanded(
                    child: MeowStyledButton(
                      text: 'Create',
                      onPressed: _createEnvelope,
                      backgroundColor: MeownvelopeColors.medBlue,
                      textColor: Colors.white,
                      verticalPadding: h * 0.025,
                    )
                  ),
                  SizedBox(width: w * 0.04),
                  Expanded(
                    child: MeowStyledButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: MeownvelopeColors.medBlue,
                      textColor: Colors.white,
                      verticalPadding: h * 0.025,
                    )
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