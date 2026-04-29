import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meownvelope_mobile/data/repositories/envelope_repository.dart';
import 'package:meownvelope_mobile/data_types/envelope_data.dart';
import 'package:meownvelope_mobile/pages/home_pages/envelope_list_dialog.dart';
import 'package:meownvelope_mobile/pages/home_pages/envelope_list_view_model.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_view_model.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/import_money/import_money_page_view.dart';
import 'package:meownvelope_mobile/pages/standalone_pages/envelope_creation_page/envelope_creation_view.dart';
import 'package:meownvelope_mobile/pages/fill_envelopes/fill_envelopes_view.dart';
import 'package:meownvelope_mobile/pages/fill_envelopes/fill_envelopes_view_model.dart';
import 'package:meownvelope_mobile/utils/widgets/bills/bill_view_model.dart';
import 'package:meownvelope_mobile/pages/home_pages/abstract_home_page.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_colors.dart';
import 'package:meownvelope_mobile/pages/envelope_details/envelope_details_view.dart';
import 'package:meownvelope_mobile/utils/styling/meownvelope_font.dart';
import 'package:meownvelope_mobile/utils/widgets/popup_notifier.dart';
import 'package:provider/provider.dart';

class EnevelopeListPage extends AbstractHomePage {
  const EnevelopeListPage({super.key});

  @override
  State<EnevelopeListPage> createState() => _EnevelopeListPageState();

  @override
  IconData getIcon() {
    return Icons.list;
  }
}

class _EnevelopeListPageState extends State<EnevelopeListPage> {
  late EnvelopeListViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EnvelopeListViewModel();
    _viewModel.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // cash visual
            Stack(
              alignment: AlignmentGeometry.centerStart,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipOval(
                    child: Container(
                      width: 180,
                      height: 60,
                      decoration: BoxDecoration(
                        color: MeownvelopeColors.lightBlue,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/leastcash.png',
                    width: 150,
                    height: 120,
                  ),
                ),
              ],
            ),
            // buttons for importing and filling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    maximumSize: Size(180, 70),
                    minimumSize: Size(130, 50),
                    elevation: 5,
                    shadowColor: MeownvelopeColors.lightBlue,
                    backgroundColor: MeownvelopeColors.darkBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    "Import Funds",
                    style: GoogleFonts.martianMono(
                      textStyle: TextStyle(height: 2, fontSize: 17),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ImportMoneyPage()),
                    );
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    maximumSize: Size(180, 70),
                    minimumSize: Size(130, 50),
                    elevation: 5,
                    shadowColor: MeownvelopeColors.lightBlue,
                    backgroundColor: MeownvelopeColors.darkBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: Text(
                    "Fill Envelopes",
                    style: GoogleFonts.martianMono(
                      textStyle: TextStyle(height: 2, fontSize: 15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (_) => BillViewModel(),
                            ),
                            ChangeNotifierProvider(
                              create: (ctx) => FillEnvelopesViewModel(
                                ctx.read<BillViewModel>(),
                              ),
                            ),
                          ],
                          child: FillEnvelopesPage(),
                        ),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  }, //temp until fill envelopes page is made
                ),
              ],
            ),
            // bottom section that shows envelope previews
            //SizedBox(width: 30, height:50), // for space between top and bottom sections
            Container(
              //background box containing envelope list
              height: 450,
              width: 380,
              color: MeownvelopeColors.secondaryBgColor,

              child: GridView.count(
                // container that actually holds envelopes
                crossAxisCount: 2,
                children: envelopeList(),
                //envelopeBuilder(Colors.white, "Groceries")
              ),
            ),
          ],
        ),
        Positioned.fill(
          // background box for cash visual and buttons
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Share code button
                  if (_viewModel.isLoggedIn)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MeownvelopeColors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.upload,
                              color: MeownvelopeColors.darkBlue,
                              size: 40,
                            ),
                            Icon(
                              Icons.mail_outline,
                              color: MeownvelopeColors.darkBlue,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        final w = MediaQuery.of(context).size.width;
                        final h = MediaQuery.of(context).size.height;
                        showEnvelopeCodeDialog(context, w, h, _viewModel);
                      },
                    )
                  else
                    const SizedBox.shrink(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MeownvelopeColors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: MeownvelopeColors.darkBlue,
                            size: 40,
                          ),
                          Icon(
                            Icons.mail_outline,
                            color: MeownvelopeColors.darkBlue,
                            size: 40,
                          ),
                        ],
                      ),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EnvelopeCreationView(),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget envelopeBuilder(
    Color userColor,
    String userLabel,
    EnvelopeData envelope,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EnvelopeDetailsView(
              viewModel: EnvelopeDetailsViewModel(envelope),
            ),
          ),
        ).then((value) => setState(() {}));
      },
      child: Container(
        color: userColor,
        margin: EdgeInsets.only(bottom: 30, top: 40, left: 10, right: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/envelope.png'),
            Positioned(
              top: 15,
              child: Text(userLabel, style: martian(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> envelopeList() {
    List<EnvelopeData> sortedEnvelopes = EnvelopeRepository.getEnvelopes()
        .values
        .toList();
    sortedEnvelopes.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    List<Widget> envList = [];
    for (var envelope in sortedEnvelopes) {
      envList.add(
        envelopeBuilder(Color(envelope.color), envelope.name, envelope),
      );
    }
    //envList.sort();
    return envList;
  }
}
