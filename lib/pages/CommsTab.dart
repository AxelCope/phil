import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/pages/page_commerciaux.dart';
import 'package:phil/pages/page_detail_commerciaux.dart';
import 'package:phil/pages/page_pointdeventes.dart';

class CommsTab extends StatefulWidget {
  const CommsTab({Key? key, this.commId, this.commName}) : super(key: key);
  final String? commId;
  final String? commName;
  @override
  State<CommsTab> createState() => _CommsTabState();
}

class _CommsTabState extends State<CommsTab> {
  CloseButtonVisibilityMode CloseVision = CloseButtonVisibilityMode.never;
  int currentIndex = 0;
  Icon ic = Icon(FluentIcons.bar_chart4);

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: TabView(
          closeButtonVisibility: CloseVision,
          currentIndex: currentIndex,
          onChanged: (index) => setState(() => currentIndex = index),
          tabs: <Tab> [
      Tab(text: const Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Courbe des dotations    '),
            WidgetSpan(child: Icon(FluentIcons.bar_chart4)),

          ],
        ),
      ), body: PageDetailsCommerciaux(commId: widget.commId, commName: widget.commName,)),
    //Tab(text: Text("Statistiques générales"), body: StatistiquesGenerales()),
    ]
      ),
    );;
  }
}
