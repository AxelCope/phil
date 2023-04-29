import 'dart:io';
import 'package:flutter/material.dart' hide Card, ListTile, Divider, Colors,  FilledButton;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluent_ui/fluent_ui.dart' hide showDialog;
import 'package:phil/models/model_commerciaux.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:phil/models/model_segmentation.dart';
import 'package:phil/models/model_inactifs.dart';
import 'package:phil/models/model_inactifs_distincts.dart';
import 'package:phil/models/model_univers.dart';
import 'package:phil/models/univers_total.dart';
import 'package:phil/provider/queries_provider.dart';
import 'package:phil/widget/CardHiglight.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class ActiviteGene extends StatefulWidget {
  const ActiviteGene({Key? key,     required this.comms
  }) : super(key: key);


  final Comms comms;

  @override
  State<ActiviteGene> createState() => _ActiviteGeneState();
}

class _ActiviteGeneState extends State<ActiviteGene> {

  List<InactifsDistincts> inactivite = [];

  List<Inactifs> listInact = [];//Liste des inactifs
  List<countUnivers> listCountUnivers = [];//liste pour récup les nombre de pdvs total

  //Listes pour les differents segments de points
  List<Segmentation> zoneA = [];
  List<Segmentation> zoneB = [];
  List<Segmentation> zoneC = [];
  List<Segmentation> zoneD = [];
  List<Segmentation> zoneE = [];

  //List pour recup les pdv et leurs infos
  List<Univers> listUnivers = [];


  String filename = '';//Recuperation du fichiers Excel

  //Variables pour la progress
  bool gotData = true;
  bool getDataError = false;
  bool gotDialogData = true;

   late final QueriesProvider _provider;


  @override
  void initState() {
    super.initState();
    _initProvider();
  }

  //Initalisation du provider
  void _initProvider() async {
    _provider = await QueriesProvider.instance;
    countUniversPdvs();
    getInactifs();
    inactifsCommercialExcel();
    segmentation();
    fetchUnivers();

  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(),
      content: ScaffoldPage.scrollable(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  SizedBox(width: 300, child: cardInactifs()),
                  SizedBox(width: 300, child: cardActifs()),

                  Container(
                    padding: const EdgeInsets.only(top: 15),
                    width: 500,
                      height: 100,
                      child: const Card(child: ProgressBar(value: 40,)))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Segmentation des points du commercial", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),),
            ),

            //Widgets segmentation
            allSegments(),

              Container(
                width: 100,
                height: 100,
                child: listInfosPdv(),
              )

          ]),
    );
  }

  //Récupération des inactifs du commercial
  Future<void>inactifsCommercialExcel([bool rebuild = true]) async {

    await _provider.fetchInactifsZone(
        cmId: widget.comms.id,
        startDate: "04",
        endDate: "04",
        secure: false,
        onSuccess: (cms) {
          for (var element in cms) {
            inactivite.add(InactifsDistincts.MapInactifs(element));
          }
        },
        onError: (error) {
        }
    );
  }

  Widget allSegments()
  {
    return Column(
      children: [
        sgA(),
        const SizedBox(width: 50,),
        sgB(),
        const SizedBox(width: 50,),
        sgC(),
        const SizedBox(width: 50,),
        sgD(),
        const SizedBox(width: 50,),
        sgE(),
      ],
    );
  }

  //Widget du segment A
  Widget sgA
      () {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardHighlight(
        header: const Text("Voir les points de vente de ce segment"),
        codeSnippet: ListView.builder(
            shrinkWrap: true,
            itemCount: zoneA.length,
            itemBuilder: (BuildContext c, int index) {
              return segment(zoneA[index]);
            }
        ),
        child: Text("Segments A: ${zoneA.length} points de ventes"),
      ),
    );
  }
  //Widget du segment B
  Widget sgB
      () {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardHighlight(
        header: const Text("Voir les points de vente de ce segment"),
        codeSnippet: ListView.builder(
            shrinkWrap: true,
            itemCount: zoneB.length,
            itemBuilder: (BuildContext c, int index) {
              return segment(zoneB[index]);
            }
        ),
        child: Text("Segments B: ${zoneB.length} points de ventes"),
      ),
    );
  }
  //Widget du segment C
  Widget sgC
      () {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardHighlight(
        header: const Text("Voir les points de vente de ce segment"),
        codeSnippet: ListView.builder(
            shrinkWrap: true,
            itemCount: zoneC.length,
            itemBuilder: (BuildContext c, int index) {
              return segment(zoneC[index]);
            }
        ),
        child: Text("Segments C: ${zoneC.length} points de ventes"),
      ),
    );
  }
  //Widget du segment D
  Widget sgD
      () {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardHighlight(
        header: const Text("Voir les points de vente de ce segment"),
        codeSnippet: ListView.builder(
            shrinkWrap: true,
            itemCount: zoneD.length,
            itemBuilder: (BuildContext c, int index) {
              return segment(zoneD[index]);
            }
        ),
        child: Text("Segments D: ${zoneD.length} points de ventes"),
      ),
    );
  }
  //Widget du segment E
  Widget sgE
      () {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardHighlight(
        header: const Text("Voir les points de vente de ce segment"),
        codeSnippet: ListView.builder(
            shrinkWrap: true,
            itemCount: zoneE.length,
            itemBuilder: (BuildContext c, int index) {
              return segment(zoneE[index]);
            }
        ),
        child: Text("Segments E: ${zoneE.length} points de ventes"),
      ),
    );}

  //Widget principal de la segmentation
  Widget segment(Segmentation dt) {
     var formatter = NumberFormat("#,###,###");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile.selectable(
            onPressed: (){
               listUnivers.clear();
               fetchUnivers(id: dt.id);
               showInformationDialog(context, dt.id, dt.nom);
              },
            title: Text("${dt.nom} (${dt.id}) : ${formatter.format(dt.somme)} CFA",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
  //Recuperation et repartition des pdvs selon leurs segments
  Future<void> segmentation([bool rebuild = true]) async {
    setState(() {
      gotData = true;
      getDataError = false;
    });
    await _provider.Segmentation(
        cmId: widget.comms.id,
        date: DateTime.now().month,
        secure: false,
        onSuccess: (cms) {
          for (var element in cms) {
            if(element['somme'] > 10000000 ) {
              zoneA.add(Segmentation.MapDepot(element));
            }else
            if(element['somme'] >= 5000000  &&  element['somme'] <= 10000000 ){
              zoneB.add(Segmentation.MapDepot(element));
            }
            else
            if(element['somme'] >= 1000000 &&  element['somme'] <= 5000000 ){
              zoneC.add(Segmentation.MapDepot(element));
            }
            else
            if(element['somme'] >= 1 &&  element['somme'] <= 1000000){
              zoneD.add(Segmentation.MapDepot(element));
            }
            else
            if(element['somme'] == 0){
              zoneE.add(Segmentation.MapDepot(element));
            }
          }
        },
        onError: (error) {
        }
    );
  }

  //Widget pour les card du taux d'ativite et d'inactivite du reseau
  Widget cardActifs() {
    if (gotData) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0),
          child: SizedBox(
            height: 100,
            width: 100,
            child: ProgressRing(),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: listInact.length,
          itemBuilder: (BuildContext c, int index) {
            return showActifs(listInact[index], listCountUnivers[index]);
          }
      ),
    );
  }

  Widget cardInactifs() {
    if (gotData) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 180.0),
          child: SizedBox(
            height: 100,
            width: 100,
            child: ProgressRing(),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: listInact.length,
          itemBuilder: (BuildContext c, int index) {
            return showInactifs(listInact[index], listCountUnivers[index]);
          }
      ),
    );
  }

  Widget showInactifs(Inactifs inac, countUnivers uni) {
    double tauxActivite = ((inac.inactifs! * 100) / uni.pdv_zone!);

    if (gotData) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0),
          child: SizedBox(
            height: 100,
            width: 100,
            child: ProgressRing(),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Button(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Taux d'inactivité", style: TextStyle(fontSize: 25)),
              Text("${tauxActivite.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 50, color: Colors.red),),
            ],
          ),
        ),
        onPressed: () => cardDialog(context),
      ),
    );
  }

  Widget showActifs(Inactifs inac, countUnivers uni) {
    double tauxActivite = ((inac.inactifs! * 100) / uni.pdv_zone!);
    double tauxInactivite = 100 - tauxActivite;


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Button(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Taux d'activité", style: TextStyle(fontSize: 25)),
              Text("${tauxInactivite.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 50, color: Colors.green),),
            ],
          ),
        ),
        onPressed: () => cardDialog(context),
      ),
    );
  }

  //Recuperation du nombre total d'univers
  Future<void> countUniversPdvs([bool rebuild = true]) async {
    setState(() {
      gotData = true;
      getDataError = false;
    });
    await _provider.Pdvszones(
        cmId: widget.comms.id,
        secure: false,
        onSuccess: (cms) {
          for (var element in cms) {
            listCountUnivers.add(countUnivers.MapComm(element));
          }

          setState(() {
            gotData = false;
            getDataError = false;
          });
        },
        onError: (error) {
          setState(() {
          gotData = false;
          getDataError = true;
        });
        }
    );
  }


//Envoyer les inactifs au commerciaux respectifs
  void cardDialog(BuildContext context) async {
      await showDialog<String>(

      context: context,
      builder: (context) =>
          ContentDialog(
            title: Text(
                "Envoyer par mail ses inactifs au commercial ${widget.comms.nomCommerciaux} (${widget.comms.mail})"),
            actions: [
              FilledButton(
                child: const Text('Envoyer'),
                onPressed: () {
                  if (inactivite.isEmpty)
                {
                  sendInactifsExcelDialog(context);

                }else {
                    generateExcel();
                    Navigator.pop(context);
                  }

                },
              ),
              FilledButton(
                child: const Text('Annuler'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
    setState(() {});
  }


  Future<void> sendInactifsExcelDialog(BuildContext context ) async
  {
    await showDialog<String>(

      context: context,
      builder: ( context) =>
          ContentDialog(
            content: Text("${widget.comms.nomCommerciaux} N'as pas d'inactifs pour ce mois"),
            actions: [
              FilledButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
    setState(() {});
  }


  Future<void> getInactifs([bool rebuild = true]) async {

    await _provider.fetchActifsZone(
        cmId: widget.comms.id,
        startDate: DateTime.now().month,
        endDate: DateTime.now().month,
        secure: false,
        onSuccess: (cms) {
          for (var element in cms) {
            listInact.add(Inactifs.MapInactifs(element));
          }

        },
        onError: (error) {
        }
    );
  }


  String noms(InactifsDistincts ina)
  {
    return ina.nom_pdv!;
  }
 int numero(InactifsDistincts ina)
  {
    return ina.numero_flooz!;
  }
 //Générer le fichiers excel contenant les inactifs
  Future<void> generateExcel()
  async{

    // Create a new Excel document.

    final Workbook workbook =   Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
//Add Text.
     var p = 0;
     for(var i = 0; i<=inactivite.length-1; i++) {
       p++;
        sheet.getRangeByName('A$p').setText(noms(inactivite[i]));
        sheet.getRangeByName('B$p').setText(numero(inactivite[i]).toString());
      }

//Add Number
// Save the document.
    final List<int> bytes = workbook.saveAsStream();
    //File('AddingTextNumberDateTime.xlsx').writeAsBytes(bytes);
//Dispose the workbook.
    workbook.dispose();

    DateTime date = DateTime.now();


    File("MyExcellllTest.xlsx");

    final String path = ( await getApplicationSupportDirectory()).path;
     filename = Platform.isWindows?'$path\\Inactifs ${widget.comms.nomCommerciaux} du  ${date.month}-${date.year}.xlsx' : '$path/Inactifs ${widget.comms.nomCommerciaux}  du mois de ${date.month}-${date.year}.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(filename);
  }

  void showInformationDialog(BuildContext context,id, nom) {
  //   if (gotDialogData)
  // {
  //    showDialog(
  //       context: context,
  //       builder: (context){
  //         return Center(
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(vertical: 180.0),
  //             child: SizedBox(
  //               height: 100,
  //               width: 100,
  //               child: ProgressRing(),
  //             ),
  //           ),
  //         );
  //       }
  //   );
  // }

       showDialog<String>(
      context: context,
      builder: (context) {

        return StatefulBuilder(
          builder: (context, setState){
            return ContentDialog(
              title: Text("Infos du point"),
              content: listInfosPdv(id: id, nom: nom),
              actions: [
                FilledButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
      }
    );
  }

  Future<void> fetchUnivers({id})
  async{
    await _provider.fetchUnivers(
        pdvId: id,
        secure: false,
        onSuccess: (data)
        {
          for(var emt in data)
            {
              listUnivers.add(Univers.mapUnivers(emt));
            }
          setState(() {
            gotDialogData = false;
          });
        },
        onError: (onError)
        {
          print(onError);
        }
    );
  }


  Widget showInfos(Univers uni, id, nom)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nom du point:  ${nom}", style: TextStyle(fontWeight: FontWeight.bold),),
        SizedBox(height: 9,),
        Text("Numero du point:  ${id}", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 9,),
        Text("Profil:  ${uni.profil!}", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 9,),
        Text("Localisation:  ${uni.localisation!}", style: TextStyle(fontWeight: FontWeight.bold)),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Button(
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Voir l'emplacement du point  "),
                    WidgetSpan(child: Icon(FluentIcons.nav2_d_map_view, size: 17,)),
                  ],
                ),
              ),
              onPressed: (){
                double dl = double.parse(uni.latitude!);
                double dL = double.parse(uni.longitude!);
                MapsLauncher.launchCoordinates(dl, dL, "Le point en question");
              },
            ),
          ),
        )
      ],
    );
  }

  Widget listInfosPdv({id, nom})
  {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listUnivers.length,
        itemBuilder: (context, index)
            {
              return showInfos(listUnivers[index], id, nom);
            }
    );
  }

}