import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/envelope_preview.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/labeled_radio_option.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/envelope_creation_page/envelope_creation_view_model.dart';

class EnvelopeCreationView extends StatefulWidget {
  const EnvelopeCreationView({super.key});

  @override
  State<EnvelopeCreationView> createState() => _EnvelopeCreationViewState();
}

class _EnvelopeCreationViewState extends State<EnvelopeCreationView> {
  // ── Controllers ────────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final _viewModel = EnvelopeCreationViewModel();

// Envelope preview updates in real time
  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
    _viewModel.addListener(() => setState(() {}));
  }
  
  // ── Save to Hive ───────────────────────────────────────────────
  Future<void> _createEnvelope() async {
    final error = await _viewModel.validateAndCreate(_nameController.text.trim(), _goalController.text);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${_nameController.text.trim()}" envelope created!')),
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
                      color: _viewModel.selectedColor,
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
                        final isSelected = _viewModel.selectedColor == color;
                        return GestureDetector(
                          onTap: () => _viewModel.handleColorSelect(color),
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
                groupValue: _viewModel.placeAtStart,
                activeColor: MeownvelopeColors.darkBlue,
                onChanged: (val) => _viewModel.handlePlacementChange(val!),
              ),
              SizedBox(height: h * 0.03),
              LabeledRadioOption(
                label: 'Place my envelope at the end of my list.',
                value: false,
                groupValue: _viewModel.placeAtStart,
                activeColor: MeownvelopeColors.darkBlue,
                onChanged: (val) => _viewModel.handlePlacementChange(val!),
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