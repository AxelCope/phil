import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/pages/page_commerciaux.dart';
import 'package:phil/pages/page_pointdeventes.dart';

void main()
{
  runApp(FluentApp(home: Test()));
}
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  var _currentIndex = 0;
  List<NavigationPaneItem> pages = [
    PaneItem(
        body:  PageCommerciaux(),
        title:  Text("Nos commerciaux"),
        icon:  Icon(FluentIcons.contact, size: 20,)),
    PaneItem(
        body:  PagePointsDeVentes(),
        title: Text("Nos Points de ventes"),
        icon:  Icon(FluentIcons.transition, size: 20,)),
    // PaneItem(
    //     body:  StatistiquesGenerales(),
    //     title:  Text("Statistiques générales"),
    //     icon:  Icon(FluentIcons.chart, size: 20,)),
  ];

  @override
  Widget build(BuildContext context) {
    return InheritedNavigationView(
      oldIndex: 0,
        currentItemIndex: -1,
        child: Text("What the fuck is this ?"),
        displayMode: PaneDisplayMode.auto,
        pane: NavigationPane(
          selected: _currentIndex,
          onChanged: (i) => setState(() => _currentIndex = i),
          displayMode: PaneDisplayMode.auto,

          items: pages,

    ),
    );
  }
}
