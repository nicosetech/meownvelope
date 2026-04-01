import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meownvelope_mobile/pages/fill_envelopes/fill_envelopes_view_model.dart';
import 'package:meownvelope_mobile/utils/widgets/meownvelope_app_bar.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/meowStyledButton.dart';
import 'package:provider/provider.dart';

class FillEnvelopesPage extends StatelessWidget {
  const FillEnvelopesPage({super.key, required this.viewModel});
  
  final FillEnvelopesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: const _FillEnvelopesView(), 
      );
  }
}

class _FillEnvelopesView extends StatelessWidget {
  const _FillEnvelopesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FillEnvelopesViewModel>();
    final billsMap = [
      {'value': 100.0, 'amount': viewModel.amountHund, 'label': '100'},
      {'value': 50.0, 'amount': viewModel.amountFifty, 'label': '50'},
      {'value': 20.0, 'amount': viewModel.amountTwenty, 'label': '20'},
      {'value': 10.0, 'amount': viewModel.amountTen, 'label': '10'},
      {'value': 5.0, 'amount': viewModel.amountFive, 'label': '5'},
      {'value': 1.0, 'amount': viewModel.amountOne, 'label': '1'},
    ];

    return Scaffold(
      backgroundColor: MeownvelopeColors.bgColor,
      appBar: MeownvelopeAppBar(
        titleText: "Fill Envelopes",
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = MediaQuery.of(context).size.height * 0.9; // height base
            final w = MediaQuery.of(context).size.width; // width base
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
              children: [
                SizedBox(height: h * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Text("Current Funds:\$" + viewModel.userFunds.truncate().toString(), style: martian(fontWeight: FontWeight(500), fontSize: w * 0.05)), 
                    SizedBox(width: w * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:MeownvelopeColors.lightBlue,
                        padding: EdgeInsets.symmetric(vertical: h * 0.012),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                              context: context, 
                              builder: (context){ 
                                return AlertDialog(
                                  backgroundColor: MeownvelopeColors.lightBlue,
                                  title: Text("Piggy bank currently contains " + (viewModel.piggyBankFunds * 100).toStringAsFixed(0) + " cents.", style: martian(fontSize: w * 0.05)),
                                  actions: [ 
                                    TextButton( 
                                      style: TextButton.styleFrom(
                                          backgroundColor:MeownvelopeColors.darkBlue

                                        ),
                                      onPressed: () {Navigator.of(context).pop();}, 
                                      child: Text("Ok", style: martian(color: Colors.white)))]
                                  );
                                }
                              );
                          }, 
                      child:Icon(Icons.savings_outlined, color: MeownvelopeColors.darkBlue, size: w * 0.095),
                      ),
                    ],
                  ), 
                SizedBox(height: h * 0.02),
                Column(
                  children: [
                    Text("Drag bills to desired envelopes.", style: martian()), 
                    Container(
                      height: h * 0.272,
                      width: w * 0.886,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.0385),
                      color: MeownvelopeColors.medBlue,
                      child: GridView.count(
                        mainAxisExtent: h* 0.0889,
                        mainAxisSpacing: h * 0.003,
                        crossAxisSpacing: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: [
                          for (var bill in billsMap)
                            billBoxBuilder(
                              billValue: bill['value'] as double,
                              numberOfBills: bill['amount'] as int,
                              valueAsString: bill['label'] as String,
                              onDragCompleted: () => viewModel.onBillDragged(bill['value'] as double),
                              onBreakBill: () => viewModel.breakBill(bill['value'] as double),
                              w: w,
                              h: h
                            )
                        ],
                      ),
                    ),
                  ],
                ), 
                SizedBox(height: h * 0.025),
                Container(
                  height: h * 0.38,
                  width: w * 0.9,
                  margin: EdgeInsets.symmetric(horizontal: w * 0.035),
                  color: MeownvelopeColors.secondaryBgColor,
                  padding: EdgeInsets.only(top: h * 0.03),

                  child: GridView.count(
                    mainAxisExtent: h * 0.12,
                    mainAxisSpacing: h * 0.03,
                    crossAxisCount: 2,
                    children: [ 
                      for (var envelope in viewModel.getSortedEnvelopes())
                        DragTarget<double>(
                          builder: (context, accepted, rejected) {
                            final amountIn = viewModel.getEnvelopeBalance(envelope);
                            return envelopeBuilder(Color(envelope.color), envelope.name, amountIn, w, h);
                          },
                          onAcceptWithDetails:(details) {
                            viewModel.onEnvelopeAccept(envelope, details.data);
                          }
                        )
                    ]
                  ),
                ),
                SizedBox(height: h * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MeowStyledButton(
                      text: "Save",
                      backgroundColor: MeownvelopeColors.darkBlue,
                      horizontalPadding: w * 0.09,
                      onPressed: () async {
                        final navigator = Navigator.of(context); // capture context synchronously
                        await viewModel.commitEnvelopes(); // save changes to hive 
                        navigator.pop();
                        }, 
                      ),  
                    SizedBox(width: w * 0.16,),
                    MeowStyledButton(
                      text: "Cancel",
                      backgroundColor: MeownvelopeColors.darkBlue,
                      horizontalPadding: w * 0.06,
                      onPressed: () async {
                        viewModel.revertEnvelopes(); // do not save changes to hive
                        Navigator.pop(context);
                        }, 
                    )
                    ],
                  )
              ],
            );
          }
        ),
      )
    );
  }
 
  Widget envelopeBuilder(Color userColor, String userLabel, double amountIn, num w, num h) {
    return Container(
      color: userColor,
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/envelope.png', scale: w * 0.001),
          Positioned(
            bottom: h * 0.005,
            child: Text(amountIn.toInt().toString(), style: martian(fontSize: w * 0.035)),
          ),
          Positioned(
            top: h * 0.008,
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(userLabel, style: martian(fontSize: w * 0.032)),)
          ),
        ],
      ),
    );
  }

  Widget billBoxBuilder({required double billValue, required int numberOfBills, required String valueAsString, required VoidCallback onDragCompleted, required VoidCallback onBreakBill, required num w, required num h,}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2, 
          child:Container(
            alignment: AlignmentGeometry.topLeft, 
            padding: EdgeInsets.only(left: w * 0.01), 
            color: MeownvelopeColors.secondaryBgColor, 
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(valueAsString, style: martian())),
          ), 
        ),
        
        Expanded(
          flex: 5, 
          child:Container(
            padding: EdgeInsets.all(h * 0.008), 
            color:MeownvelopeColors.secondaryBgColor, 
            child: numberOfBills > 0
                  ? PopupMenuButton(
                    padding : const EdgeInsets.all(0.10),
                    position: PopupMenuPosition.over,
                    color: MeownvelopeColors.lightBlue,
                    enabled: billValue != 1,
                    onSelected: (value) {
                      if (value == 'break') {
                        onBreakBill();
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'break',
                        child: SizedBox(
                          child: Text("Break Bill", style: martian(height: 1, fontSize: 12)))
                      ),
                    ],
                    child: Draggable(
                      data: billValue, 
                      onDragCompleted: onDragCompleted,                                 
                      feedback: Image.asset('assets/dollarbill.png', scale: w * 0.0075), 
                      child: FittedBox(fit: BoxFit.contain, child: Image.asset('assets/dollarbill.png')), 
                    )
                  )
                  : const SizedBox.expand(),                             
          ), 
        ),
        
      ]
    );
  }
}