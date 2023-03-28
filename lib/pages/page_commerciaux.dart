import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/methods/methods.dart';
import 'package:phil/models/commerciaux.dart';
import 'package:phil/pages/CommsTab.dart';
import 'package:phil/pages/page_detail_commerciaux.dart';
import 'package:phil/provider/queries_provider.dart';

class PageCommerciaux extends StatefulWidget {
  const PageCommerciaux({Key? key}) : super(key: key);

  @override
  State<PageCommerciaux> createState() => _PageCommerciauxState();
}

class _PageCommerciauxState extends State<PageCommerciaux> {

  List<Map<String, dynamic>> listCom = [];
  List<Comms> commerciaux = [];
  Comms cm = Comms();
  bool gotData = true;
  bool getDataError = false;
  late final QueriesProvider _provider;

  @override
  void initState()
  {
    super.initState();
    _initProvider();
  }

  //Initalisation du provider
  void _initProvider() async{
    _provider = await QueriesProvider.instance;
    getCommerciaux();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text("Nos commerciaux"),),
        content:
         builWidget(),
    );
  }

  //Récupération des données depuis notre requête du provider
  Future<void> getCommerciaux([bool rebuild = true]) async{

      setState(() {
        gotData = true;
        getDataError = false;
      });

    await _provider.fetchCommerciaux(
        secure: false,
        onSuccess: (cms)
        {
          listCom = cms;
          for (var element in cms) {
            commerciaux.add(Comms.MapComm(element));
          }

            setState(() {
              gotData = false;
              getDataError = false;
            });


        },
        onError: (error)
        {
          print(error);


            setState(() {
              gotData = false;
              getDataError = true;
            });
        }
    );
  }

  Widget builWidget()
  {
    if(gotData)
    {
      return const Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: ProgressBar(),
        ),
      );
    }

    if(getDataError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Une erreur est survenue.'
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                getCommerciaux();
              },
              child: const Text('Relancer'
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: listCom.length,
        itemBuilder: (BuildContext c, int index)
        {
          return listeCommerciaux(commerciaux[index]);
        }
    );

  }
  //Widget de la liste
  Widget listeCommerciaux(Comms com) {

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile.selectable(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Color(0xFF000000))),
        onPressed: (){
          nextPage(context,   CommsTab(commId: com.id, commName: com.nomCommerciaux,));
        },
        leading: const Icon(FluentIcons.contact, size: 30,),
        title: Text(com.nomCommerciaux ?? "Aucun nom", style: const TextStyle(fontSize: 20),),
        subtitle: Text(com.id, style: const TextStyle(fontSize: 15),),
      ),

    );
  }

}
