import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/envelope_details/withdrawl_control_view_model.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class WithdrawalControlView extends StatefulWidget {
  final EnvelopeData envelope;
  final String pendingName;

  const WithdrawalControlView({
    super.key,
    required this.envelope,
    required this.pendingName,
  });

  @override
  State<WithdrawalControlView> createState() => _WithdrawalControlViewState();

}

class _WithdrawalControlViewState extends State<WithdrawalControlView> {
  final TextEditingController _withdrawalAmountController = TextEditingController();
  late WithdrawalControlsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WithdrawalControlsViewModel(widget.envelope);
    _viewModel.addListener(() => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: MeownvelopeColors.secondaryBgColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '\$',
                  style: martian(color: MeownvelopeColors.darkBlue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _withdrawalAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Amount to Withdraw',
                      hintStyle: martian(color: MeownvelopeColors.darkBlue),
                      filled: true,
                      fillColor: MeownvelopeColors.lightBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: "Withdrawing...");
                    final error = await _viewModel.validateAndTransfer(
                        _withdrawalAmountController.text,
                    );
                    EasyLoading.dismiss();
                    if (error == 'invalid_amount') {
                        PopupNotifier.displayPopup(context, "Enter Amount", "Ensure you input a valid value into the \"Amount\" field.");
                    } else if (error == 'insufficient_funds') {
                        PopupNotifier.displayPopup(context, "Insufficient Funds", "You don't have enough funds in ${widget.envelope.name}.");
                    } else {
                        _withdrawalAmountController.clear();
                        PopupNotifier.displayPopup(context, "Success", "Your withdrawal has been completed!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MeownvelopeColors.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: martian(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
