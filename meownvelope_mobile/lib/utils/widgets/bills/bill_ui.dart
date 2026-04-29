import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:flutter/material.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';

class BillUi extends StatelessWidget{
  const BillUi({
    super.key,
    required this.billValue, 
    required this.numberOfBills, 
    required this.valueAsString, 
    required this.onDragCompleted, 
    required this.onSelectMultiple,
    required this.onBreakBill,
    required this.dragValue, 
    required this.w, 
    required this.h
  });


  final double billValue;
  final double dragValue; 
  final int numberOfBills;
  final String valueAsString;
  final VoidCallback onDragCompleted; 
  final VoidCallback onBreakBill;
  final VoidCallback onSelectMultiple; 
  final num w;
  final num h;


 @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2, 
          child:Container(
            alignment: AlignmentGeometry.topLeft, 
            padding: EdgeInsets.only(left: w * 0.01), 
            color: MeownvelopeColors.secondaryBgColor, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: Text("\$$valueAsString", style: martian())),
                if (numberOfBills > 0)
                  FittedBox(fit: BoxFit.scaleDown, child: Text("x$numberOfBills", style: martian()))
                ]),
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
                        if (value == 'break') onBreakBill();
                        if (value == 'select') onSelectMultiple();
                      },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'break',
                        child: SizedBox(
                          child: Text("Break Bill", style: martian(height: 1, fontSize: 12)))
                      ),
                      PopupMenuItem(
                        value: 'select',
                        child: SizedBox(
                          child: Text("Select Multiple", style: martian(height: 1, fontSize: 12)))
                      ),
                    ],
                    child: Draggable(
                      data: dragValue, 
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