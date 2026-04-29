import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:provider/provider.dart';
import 'manage_deposits_view_model.dart';

class ManageDepositsDialog extends StatelessWidget {
  const ManageDepositsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider(
        create: (_) => ManageDepositsViewModel(),
        child: const ManageDepositsDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ManageDepositsViewModel>();
    final w = MediaQuery.of(context).size.width;

    if (viewModel.state == ManageDepositsState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PopupNotifier.displayPopup(
          context,
          'Error',
          viewModel.errorMessage ?? 'Something went wrong.',
        );
        viewModel.resetState();
      });
    }

    if (viewModel.state == ManageDepositsState.deleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      PopupNotifier.displayPopup(
        context,
        'Deleted!',
        'Recurring deposit removed.',
    );
    viewModel.resetState();
  });
}

    return AlertDialog(
      backgroundColor: MeownvelopeColors.bgColor,
      title: Text(
        'Manage Deposits',
        textAlign: TextAlign.center,
        style: martian(
          fontSize: w * 0.05,
          color: MeownvelopeColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: w * 0.8,
        child: viewModel.deposits.isEmpty
            ? Text(
                'No recurring deposits yet.',
                textAlign: TextAlign.center,
                style: martian(
                  fontSize: w * 0.04,
                  color: MeownvelopeColors.darkBlue,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: viewModel.deposits.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final deposit = viewModel.deposits[index];
                  return ListTile(
                    title: Text(
                      deposit.label,
                      style: martian(
                        fontSize: w * 0.04,
                        color: MeownvelopeColors.darkBlue,
                      ),
                    ),
                    subtitle: Text(
                      '\$${deposit.amount.toStringAsFixed(2)} · ${deposit.frequency}',
                      style: martian(
                        fontSize: w * 0.033,
                        color: MeownvelopeColors.darkBlue,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => viewModel.deleteDeposit(deposit),
                    ),
                  );
                },
              ),
      ),
      actions: [
        MeowStyledButton(
          text: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}