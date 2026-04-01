import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';

class ImportMoneyPage extends StatefulWidget {
  const ImportMoneyPage({super.key});

  @override
  State<ImportMoneyPage> createState() => _ImportMoneyPageState();
}

class _ImportMoneyPageState extends State<ImportMoneyPage> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  static TextStyle _monoStyle(double size, Color color) =>
      GoogleFonts.martianMono(
        textStyle: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      );

  Future<void> _importFunds() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final double? amount = double.tryParse(_amountController.text);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than \$0')),
      );
      return;
    }
    await HiveDatabase.importFunds(amount);

    await HiveDatabase.newTransaction(null, null, amount, 0);
    await HiveDatabase.checkImportBadges();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '\$${amount.toStringAsFixed(2)} added to your balance!',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(titleText: 'Import Funds'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = MediaQuery.of(context).size.height * 0.9;
            final w = MediaQuery.of(context).size.width;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                w * 0.06,
                h * 0.06,
                w * 0.06,
                h * 0.05,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 56
                ),
              child: IntrinsicHeight(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount to deposit:',
                    style: _monoStyle(w * 0.05, MeownvelopeColors.darkBlue),
                  ),
                  SizedBox(height: h * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\$',
                        style: _monoStyle(w * 0.07, MeownvelopeColors.darkBlue),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        width: w * 0.5,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          style: _monoStyle(
                            w * 0.06,
                            MeownvelopeColors.darkBlue,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: _monoStyle(
                              w * 0.06,
                              MeownvelopeColors.darkBlue.withValues(alpha: 0.4),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: MeownvelopeColors.darkBlue.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: MeownvelopeColors.darkBlue,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.08),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _importFunds,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MeownvelopeColors.medBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: h * 0.02),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: _monoStyle(w * 0.045, Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.04),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MeownvelopeColors.medBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: h * 0.02),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: _monoStyle(w * 0.045, Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.03),

                  Center(
                    child: Text(
                      'Or',
                      style: _monoStyle(w * 0.05, MeownvelopeColors.darkBlue),
                    ),
                  ),
                  SizedBox(height: h * 0.03),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Recurring payments — coming soon!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MeownvelopeColors.medBlue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: h * 0.02),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Recurring Payments',
                        style: _monoStyle(w * 0.045, Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MeownvelopeColors.darkBlue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'This page is to add funds to your profile, which can be distributed to envelopes.',
                      textAlign: TextAlign.center,
                      style: _monoStyle(w * 0.04, MeownvelopeColors.darkBlue),
                    ),
                  ),
                ],
                ),
              ),
              ),
            );
          },
        ),
      ),
    );
  }
}
