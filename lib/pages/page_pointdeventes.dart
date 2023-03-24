import 'package:fluent_ui/fluent_ui.dart';
class PagePointsDeVentes extends StatefulWidget {
  const PagePointsDeVentes({Key? key}) : super(key: key);

  @override
  State<PagePointsDeVentes> createState() => _PagePointsDeVentesState();
}

class _PagePointsDeVentesState extends State<PagePointsDeVentes> with AutomaticKeepAliveClientMixin{
  int ok = 0;
  @override
  Widget build(BuildContext context) {
    return  NavigationView(
      content:  ScaffoldPage(
        content: Center(
          child: Column(
            children: [
              Text(ok.toString() ,),
              Button(child: Text("ADD"), onPressed: (){setState(() {ok++;});}),

            ],
          ),
        ),
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
