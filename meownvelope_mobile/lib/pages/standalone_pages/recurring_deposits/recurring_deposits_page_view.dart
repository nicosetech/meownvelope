import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:provider/provider.dart';
import 'recurring_deposits_view_model.dart';
import 'manage_deposits_dialog.dart';

class RecurringPaymentsPage extends StatelessWidget {
  const RecurringPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecurringDepositsViewModel(),
      child: const _RecurringPaymentsView(),
    );
  }
}

class _RecurringPaymentsView extends StatelessWidget {
  const _RecurringPaymentsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RecurringDepositsViewModel>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height * 0.9;
    // React to state changes
    if (viewModel.state == RecurringDepositState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PopupNotifier.displayPopup(
          context,
          'Error',
          viewModel.errorMessage ?? 'Something went wrong.',
        );
        viewModel.resetState();
      });
    }

    if (viewModel.state == RecurringDepositState.success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.popUntil(context, (route) => route.isFirst);
        PopupNotifier.displayPopup(
          context,
          'Success!',
          'Recurring deposit saved!',
          
        );
        viewModel.resetState();
      });
    }

    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(titleText: 'Recurring Deposits'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                  minHeight: constraints.maxHeight - 56,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Label:',
                        style: martian(fontSize: w * 0.05, color: MeownvelopeColors.darkBlue),
                      ),
                      SizedBox(height: h * 0.02),
                      TextField(
                        controller: viewModel.labelController,
                        style: martian(fontSize: w * 0.045, color: MeownvelopeColors.darkBlue),
                        decoration: InputDecoration(
                          hintText: 'e.g. Paycheck',
                          hintStyle: martian(fontSize: w * 0.045, color: MeownvelopeColors.darkBlue.withValues(alpha: 0.4)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      SizedBox(height: h * 0.03),
                      Text(
                        'Amount:',
                        style: martian(fontSize: w * 0.05, color: MeownvelopeColors.darkBlue),
                      ),
                      SizedBox(height: h * 0.02),
                      TextField(
                        controller: viewModel.amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                          ],
                        style: martian(fontSize: w * 0.06, color: MeownvelopeColors.darkBlue),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: martian(fontSize: w * 0.06, color: MeownvelopeColors.darkBlue.withValues(alpha: 0.4)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      SizedBox(height: h * 0.03),
                      Text(
                        'Frequency:',
                        style: martian(fontSize: w * 0.05, color: MeownvelopeColors.darkBlue),
                      ),
                      SizedBox(height: h * 0.02),
                      DropdownButtonFormField<String>(
                        initialValue: viewModel.selectedFrequency,
                        items: viewModel.frequencies
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                        onChanged: (value) => viewModel.setFrequency(value!),
                        style: martian(fontSize: w * 0.04, color: MeownvelopeColors.darkBlue),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue.withValues(alpha: 0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: MeownvelopeColors.darkBlue, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      SizedBox(height: h * 0.05),
                      Row(
                        children: [
                          Expanded(
                            child: MeowStyledButton(
                              text: 'Save',
                              onPressed: () => viewModel.saveDeposit(),
                            ),
                          ),
                          SizedBox(width: w * 0.04),
                          Expanded(
                            child: MeowStyledButton(
                              text: 'Back',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.03),
                      SizedBox(
                        width: double.infinity,
                        child: MeowStyledButton(
                          text: 'Manage',
                          onPressed: () => ManageDepositsDialog.show(context),
                        ),
                      ),
                      const Spacer(),
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
                          'This page is to add funds to the profile at set intervals managed by the drop down.',
                          textAlign: TextAlign.center,
                          style: martian(
                            fontSize: w * 0.04,
                            color: MeownvelopeColors.darkBlue,
                          ),
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
