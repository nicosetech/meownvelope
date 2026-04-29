import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:flutter/services.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/pages/envelope_details/transfer_controls_view_model.dart';

class TransferControlsView extends StatefulWidget {
  final EnvelopeData envelope;
  final String pendingName;

  const TransferControlsView({
    super.key,
    required this.envelope,
    required this.pendingName,
  });

  @override
  State<TransferControlsView> createState() => _TransferControlsViewState();

}

class _TransferControlsViewState extends State<TransferControlsView> {
  final TextEditingController _transferAmountController = TextEditingController();
  late TransferControlsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TransferControlsViewModel(widget.envelope);
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
                    items: EnvelopeRepository.getEnvelopes().values
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
                    onChanged: (val) => _viewModel.handleEnvelopeSelect(val),
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
                    EasyLoading.show(status: "Transfering...");
                    final error = await _viewModel.validateAndTransfer(
                        _transferAmountController.text,
                    );
                    EasyLoading.dismiss();
                    if (error == 'invalid_amount') {
                        PopupNotifier.displayPopup(context, "Enter Amount", "Ensure you input a valid value into the \"Amount\" field.");
                    } else if (error == 'no_envelope') {
                        PopupNotifier.displayPopup(context, "Select an Envelope", "Ensure you select an envelope to transfer funds to.");
                    } else if (error == 'insufficient_funds') {
                        PopupNotifier.displayPopup(context, "Insufficient Funds", "You don't have enough funds in ${widget.envelope.name}.");
                    } else {
                        _transferAmountController.clear();
                        PopupNotifier.displayPopup(context, "Success", "Your transfer has been completed!");
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
