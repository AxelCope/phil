import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/pages/page_commerciaux.dart';
import 'package:phil/pages/page_pointdeventes.dart';
import 'package:phil/pages/page_statistiquesgenerales.dart';



class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);



  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>  {

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

  int _currentIndex = 0;
 
  @override
  Widget build(BuildContext context) {
     return InheritedNavigationView(
       displayMode: PaneDisplayMode.auto,
       child: Text("Fcuk this "),
       pane:NavigationPane(
         key: PageStorageKey<String>("listViewKey1"),
       selected: _currentIndex,
       onChanged: (i) => setState(() => _currentIndex = i),

       items: pages,


     ),);
     // IndexedStack(
     //      index: _currentIndex,
     //      children: [
     //      ]);
  }

}

// class NavBar extends StatefulWidget {
//   const NavBar({Key? key}) : super(key: key);
//
//   @override
//   State<NavBar> createState() => _NavBarState();
// }
//
// class _NavBarState extends State<NavBar> {
//   int index  = 0;
//   @override
//   Widget build(BuildContext context) {
//     return  NavigationView(
//       content: IndexedStack(
//           index: index,
//           children: [
//                  PagePointsDeVentes(),
//                  StatistiquesGenerales(),
//
//           ]),
//       pane: NavigationPane(
//         selected: index,
//         onChanged: (i) {
//           setState(() => index = i);
//         },
//         items: [
//       PaneItem(
//       icon: Icon(
//       FluentIcons.home,
//       ),
//       title: Text("One"),
//     ),
//     PaneItem(
//     icon: Icon(
//     FluentIcons.home,
//     ),
//     title: Text("Two"),
//     ),
//     PaneItem(
//     icon: Icon(
//     FluentIcons.home,
//     ),
//     title: Text("Three"),
//     ),
//     ]));
//   }
// }
//
