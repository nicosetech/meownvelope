import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'select_bills_view_model.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';

class SelectBillsView extends StatelessWidget {
  const SelectBillsView({super.key, required this.viewModel});

  final SelectBillsViewModel viewModel;

  static Future<Map<String, int>?> show(
    BuildContext context,
    SelectBillsViewModel viewModel,
  ) {
    return showDialog<Map<String, int>>(
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
        value: viewModel,
        child: SelectBillsView(viewModel: viewModel),
      ),
    );
  }

  Widget _billRow(BuildContext context, String label) {
    return Consumer<SelectBillsViewModel>(
      builder: (context, vm, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(label, style:martian()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: vm.canDecrement(label)
                      ? () => vm.decrement(label)
                      : null,
                ),
                Text("${vm.getCount(label)}", style: martian()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: vm.canIncrement(label)
                      ? () => vm.increment(label)
                      : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    
    return Dialog(
      backgroundColor: MeownvelopeColors.lightBlue,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select the number of each bill:", style: martian(fontSize: 15), textAlign: TextAlign.center,),
            SizedBox(height: w * 0.04),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ["\$100", "\$50", "\$20"]
                        .map((l) => _billRow(context, l))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: ["\$10", "\$5", "\$1"]
                        .map((l) => _billRow(context, l))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: w * 0.04),
            Row(
              children: [
                SizedBox(width: w* 0.55,),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: MeownvelopeColors.darkBlue),
                  onPressed: () => Navigator.of(context).pop(viewModel.selectedCounts),
                  child: Text("Ok", style: martian(color: Colors.white)),
                ),       
              ],)
          ],
        ),
      ),
    );
  }
}