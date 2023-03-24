import 'package:fluent_ui/fluent_ui.dart';
import 'package:genos_dart/genos_dart.dart';
import 'package:phil/navbar.dart';
import 'package:phil/pages/test.dart';
import 'package:phil/tabbar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (BuildContext context) {  },
  child: const MyMain(),));
}

class MyMain extends StatefulWidget {
  const MyMain({Key? key}) : super(key: key);

  @override
  State<MyMain> createState() => _MyMainState();
}

class _MyMainState extends State<MyMain> {

  bool _genosInit = false;

  @override
  void initState() {
    super.initState();
    _initGenos();
  }

  @override
  Widget build(BuildContext context) {
    if(!_genosInit)
      {
        ProgressRing();
      }
    return  FluentApp( debugShowCheckedModeBanner: false, home: NavBarTab());
  }
  Future<void> _initGenos() async {
    Genos.instance
        .initialize(
        appSignature: '91a2dbf0-292d-11ed-91f1-4f98460f463c',
        appWsSignature: '91a2dbf0-292d-11ed-91f1-4f98460f464c',
        appPrivateDirectory: '.',
        encryptionKey: '91a2dbf0-292d-11ed-91f1-4f98460d',
        host: 'localhost',
        port: '8080',
        unsecurePort: '80',
        onInitialization: (ge) async {
          setState(() {
            _genosInit = true;
          });
        }
    );
  }

  void showContentDialog(BuildContext context) async {
     showDialog<String>(
      context: context,
      builder: (context) => const ContentDialog(
        title: Text("Connexion au serveur..."),
        content: Text("En attente de connexion"),
      ),
    );
    setState(() {});
  }

}
