import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_dialog.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/widgets/delete_confirmation_dialog.dart';
import 'package:meownvelope_mobile/pages/envelope_details/transfer_controls.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:meownvelope_mobile/utils/widgets/envelope_preview.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';


class EnvelopeDetailsPage extends StatefulWidget {
  final EnvelopeData envelope;

  const EnvelopeDetailsPage({super.key, required this.envelope});

  @override
  State<EnvelopeDetailsPage> createState() => _EnvelopeDetailsPageState();
}

class _EnvelopeDetailsPageState extends State<EnvelopeDetailsPage> {
  late String _pendingName;
  late int _pendingColor;
  bool _showTransferFields = false;

  @override
  void initState() {
    super.initState();
    _pendingName = widget.envelope.name;
    _pendingColor = widget.envelope.color;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(titleText: 'Envelope Details'),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight - 56,
                ),
                child: IntrinsicHeight(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Column(
                      children: [
                        // ── ENVELOPE PREVIEW & GOAL AMOUNT ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: EnvelopePreview(  
                              color: Color(_pendingColor),
                              label: '\$${widget.envelope.budgetTarget.toStringAsFixed(2)}',
                              width: w * 0.65,
                              height: h * 0.22,
                              fontSize: w * 0.06,
                            ),
                          ),
                        ),
                        SizedBox(height: 13),
                        // ── NAME AND BALANCE ──────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: MeownvelopeColors.secondaryBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$_pendingName:  \$${widget.envelope.balance.toStringAsFixed(2)}',
                                style: martian(
                                  fontSize: w * 0.05,
                                  color: MeownvelopeColors.darkBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // ── EDIT BUTTONS ──────────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                SizedBox(  
                                  width: w * 0.38,
                                  child: MeowStyledButton(
                                    text: 'Edit name',
                                    onPressed: () => showEditNameDialog(
                                      context,
                                      _pendingName,
                                      (val) => setState(() => _pendingName = val),
                                    ),
                                    backgroundColor: MeownvelopeColors.lightBlue,
                                    textColor: MeownvelopeColors.darkBlue,
                                    verticalPadding: h * 0.06,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              SizedBox(  
                                  width: w * 0.38,
                                  child: MeowStyledButton(
                                    text: 'Edit color',
                                    onPressed: () => showEditColorDialog(
                                      context,
                                      (val) => setState(() => _pendingColor = val),
                                    ),
                                    backgroundColor: MeownvelopeColors.lightBlue,
                                    textColor: MeownvelopeColors.darkBlue,
                                    verticalPadding: h * 0.06,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        // ── TRANSFER MONEY BUTTON ─────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showTransferFields = !_showTransferFields;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MeownvelopeColors.lightBlue,
                              foregroundColor: MeownvelopeColors.darkBlue,
                              elevation: 0,
                              minimumSize: Size(double.infinity, h * 0.06),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Transfer money',
                                  style: martian(
                                      fontSize: w * 0.05,
                                      color: MeownvelopeColors.darkBlue,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    '\$',
                                    style: TextStyle(
                                      fontSize: w * 0.05,
                                      color: MeownvelopeColors.darkBlue,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: MeownvelopeColors.darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_showTransferFields)
                          TransferControls(
                            envelope: widget.envelope,
                            pendingName: _pendingName,
                          ),
                        // ── SAVE AND CANCEL BUTTONS ───────────────────────────────
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: MeowStyledButton(
                                  text: 'Save',
                                  onPressed: () async {
                                    widget.envelope.name = _pendingName;
                                    widget.envelope.color = _pendingColor;
                                    await widget.envelope.save();
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: MeownvelopeColors.darkBlue,
                                  textColor: Colors.white,
                                  verticalPadding: h * 0.07,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: MeowStyledButton(
                                  text: 'Cancel',
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: MeownvelopeColors.darkBlue,
                                  textColor: Colors.white,
                                  verticalPadding: h * 0.07,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ── DELETE BUTTON ─────────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MeownvelopeColors.secondaryBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () => showDeleteConfirmationDialog( 
                                context,
                                'Delete Envelope',
                                'Are you sure you want to delete "$_pendingName"?',
                                'Delete',
                                () async {
                                  EasyLoading.show(status: "Deleting...");
                                  List<dynamic> results = await Future.wait([
                                    HiveDatabase.deleteEnvelope(widget.envelope),
                                    Future.delayed(Duration(milliseconds: 200))
                                  ]);
                                  EasyLoading.dismiss();
                                  if (results[0]){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully deleted envelope \"$_pendingName\"")));
                                    Navigator.pop(context);
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong... try again later")));
                                  }
                                },
                              ),
                              icon: Icon(
                                Icons.delete_outline,
                                color: MeownvelopeColors.darkBlue,
                                size: w * 0.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}