import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meownvelope_mobile/pages/envelope_details/withdrawal_control_view.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_dialog.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/widgets/delete_confirmation_dialog.dart';
import 'package:meownvelope_mobile/pages/envelope_details/transfer_controls_view.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:meownvelope_mobile/utils/widgets/envelope_preview.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_view_model.dart';

class EnvelopeDetailsView extends StatefulWidget {
  final EnvelopeDetailsViewModel viewModel;

  const EnvelopeDetailsView({super.key, required this.viewModel});

  @override
  State<EnvelopeDetailsView> createState() => _EnvelopeDetailsViewState();
}

class _EnvelopeDetailsViewState extends State<EnvelopeDetailsView> {
  late EnvelopeDetailsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(titleText: 'Envelope Details'),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _viewModel.onPop();
          }
        },
        child: LayoutBuilder(
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
                          // ── ENVELOPE PREVIEW & CLOUD BUTTON ──────────────────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                // Empty space on left to balance the button on the right
                                SizedBox(width: w * 0.15),
                                // Envelope takes up remaining space and centers itself
                                Expanded(
                                  child: EnvelopePreview(
                                    color: Color(_viewModel.pendingColor),
                                    label:
                                        '\$${_viewModel.envelope.budgetTarget.toStringAsFixed(2)}',
                                    width: w * 0.65,
                                    height: h * 0.22,
                                    fontSize: w * 0.06,
                                  ),
                                ),
                                // Button on the right
                                SizedBox(width: w * 0.02),
                                SizedBox(
                                  width: w * 0.15,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          MeownvelopeColors.lightBlue,
                                      padding: EdgeInsets.symmetric(
                                        vertical: h * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _viewModel.handleCloudButtonTap(
                                          onLocked: () =>
                                              showLockedCloudDialog(context, w),
                                          onCloud: () =>
                                              showUploadEnvelopeDialog(
                                                context,
                                                w,
                                                () => _viewModel
                                                    .handleCloudButtonPress(),
                                              ),
                                          onUploaded: () => showUploadedCloudDialog(
                                            context,
                                            w,
                                            () async {
                                              String?
                                              shareCode = await _viewModel
                                                  .handleShareCodeButtonPress();
                                              if (shareCode != null) {
                                                showShareCode(
                                                  context,
                                                  w,
                                                  shareCode,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                    child: Icon(
                                      _viewModel.getCloudButtonState() ==
                                              CloudButtonState.locked
                                          ? Icons.lock_outline
                                          : _viewModel.getCloudButtonState() ==
                                                CloudButtonState.cloud
                                          ? Icons.cloud_outlined
                                          : Icons.cloud_upload_outlined,
                                      color: MeownvelopeColors.darkBlue,
                                      size: w * 0.095,
                                    ),
                                  ),
                                ),
                              ],
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
                                  '${_viewModel.pendingName}:   \$${_viewModel.envelope.balance.toStringAsFixed(2)}',
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
                                      _viewModel.pendingName,
                                      (val) => _viewModel.handleNameChange(val),
                                    ),
                                    backgroundColor:
                                        MeownvelopeColors.lightBlue,
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
                                      (val) =>
                                          _viewModel.handleColorChange(val),
                                    ),
                                    backgroundColor:
                                        MeownvelopeColors.lightBlue,
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
                              onPressed: () =>
                                  _viewModel.toggleTransferFields(),
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
                          if (_viewModel.showTransferFields)
                            TransferControlsView(
                              envelope: _viewModel.envelope,
                              pendingName: _viewModel.pendingName,
                            ),
                          // ── WITHDRAWAL MONEY BUTTON ─────────────────────────────────
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ElevatedButton(
                              onPressed: () =>
                                  _viewModel.toggleWithdrawalFields(),
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
                                    'Withdraw money',
                                    style: martian(
                                      fontSize: w * 0.05,
                                      color: MeownvelopeColors.darkBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.money_off,
                                      size: w * 0.065,
                                      color: MeownvelopeColors.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_viewModel.showWithdrawalFields)
                            WithdrawalControlView(
                              envelope: _viewModel.envelope,
                              pendingName: _viewModel.pendingName,
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
                                      await _viewModel.handleSave();
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
                                  'Are you sure you want to delete "${_viewModel.pendingName}"?',
                                  'Delete',
                                  () async {
                                    EasyLoading.show(status: "Deleting...");
                                    List<dynamic> results = await Future.wait([
                                      _viewModel.handleDelete(),
                                      Future.delayed(
                                        Duration(milliseconds: 200),
                                      ),
                                    ]);
                                    EasyLoading.dismiss();
                                    if (results[0]) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Successfully deleted envelope "${_viewModel.pendingName}"',
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Something went wrong... try again later",
                                          ),
                                        ),
                                      );
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
      ),
    );
  }
}
