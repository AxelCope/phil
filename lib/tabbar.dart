import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/pages/page_commerciaux.dart';
import 'package:phil/pages/page_pointdeventes.dart';
import 'package:phil/pages/page_statistiquesgenerales.dart';

void main()
{
  runApp(NavBarTab());
}

class NavBarTab extends StatefulWidget {
  const NavBarTab({Key? key}) : super(key: key);

  @override
  State<NavBarTab> createState() => _NavBarTabState();
}

class _NavBarTabState extends State<NavBarTab> {

  CloseButtonVisibilityMode CloseVision = CloseButtonVisibilityMode.never;
  int currentIndex = 0;
  List<Tab> pages = [
    Tab(text: Text("Nos commerciaux"), body: PageCommerciaux()),
    Tab(text: Text("Nos points de vente"), body: PagePointsDeVentes()),
    //Tab(text: Text("Statistiques générales"), body: StatistiquesGenerales()),
  ];
  @override
  Widget build(BuildContext context) {
    return  NavigationView(
      content: TabView(
footer: Padding(
  padding: const EdgeInsets.all(8.0),
  child:   Icon(FluentIcons.settings, size: 25, fill: 1, color: Colors.black,),
),
        closeButtonVisibility: CloseVision,
          currentIndex: currentIndex,
          onChanged: (index) => setState(() => currentIndex = index),
          tabs: pages
      ),
    );
  }
}
