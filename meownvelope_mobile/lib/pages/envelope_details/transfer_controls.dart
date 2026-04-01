import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/hive/hive_database.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';

class TransferControls extends StatefulWidget {
  final EnvelopeData envelope;
  final String pendingName;

  const TransferControls({
    super.key,
    required this.envelope,
    required this.pendingName,
  });

  @override
  State<TransferControls> createState() => _TransferControlsState();

}

class _TransferControlsState extends State<TransferControls> {
  final TextEditingController _transferAmountController = TextEditingController();
  EnvelopeData? _transferEnvelopeData;


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
                  'From',
                  style: martian(color: MeownvelopeColors.darkBlue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MeownvelopeColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.pendingName,
                      style: martian(color: MeownvelopeColors.darkBlue)
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'To:',
                  style: martian(color: MeownvelopeColors.darkBlue)
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<EnvelopeData>(
                    isExpanded: true,
                    decoration: InputDecoration(
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
                    hint: Text(
                      '-',
                      style: martian(fontSize: 12),
                    ),
                    items: HiveDatabase.getEnvelopes().values
                        .where((e) => e.key != widget.envelope.key)
                        .map(
                          (e) => DropdownMenuItem<EnvelopeData>(
                            value: e,
                            child: Text(
                              e.name,
                              style: martian(fontSize: 12),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      _transferEnvelopeData = val;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '\$',
                  style: martian(color: MeownvelopeColors.darkBlue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _transferAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Amount',
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
                    if (double.tryParse(_transferAmountController.text) == null){
                      PopupNotifier.displayPopup(context, "Enter Amount", "Ensure you input a valid value into the \"Amount\" field.");
                      return;
                    }
                    else if (_transferEnvelopeData == null){
                      PopupNotifier.displayPopup(context, "Select an Envelope", "Ensure you select an envelope to transfer funds to.");
                      return;
                    } else if (widget.envelope.balance - double.parse(_transferAmountController.text) < 0){
                      PopupNotifier.displayPopup(context, "Insufficient Funds", "You don't have enough funds in ${widget.envelope.name}.");
                      return;
                    }
                    EasyLoading.show(status: "Transfering...");
                    await Future.wait([
                      HiveDatabase.checkTransferBadges(),
                      HiveDatabase.transactionWithEdit(
                        widget.envelope,
                        _transferEnvelopeData,
                        double.parse(_transferAmountController.text),
                        null,
                      ),
                      Future.delayed(Duration(milliseconds: 200))
                    ]);
                    _transferAmountController.clear();
                    EasyLoading.dismiss();
                    PopupNotifier.displayPopup(context, "Success", "Your transfer has been completed!");
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
