import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/models/modeldotationsglobales.dart';
import 'package:phil/provider/dotation_provider.dart';
import 'package:phil/provider/queries_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PageDetailsCommerciaux extends StatefulWidget {
  const PageDetailsCommerciaux({Key? key, this.commId, this.commName}) : super(key: key);

  final String? commId;
  final String? commName;


  @override
  State<PageDetailsCommerciaux> createState() => _PageDetailsCommerciauxState();
}

class _PageDetailsCommerciauxState extends State<PageDetailsCommerciaux>{


  List<Dotations> ListDotations = [];
  bool gotData = true;
  bool getDataError = false;
  late final QueriesProvider _provider;
  late DotationProvider dv;


    DateTime? selected1 = DateTime(2023, 03, 13);
    DateTime? selected2 = DateTime.now();
    String holDate = "2023-03-13";
    String holDate2 = "${DateTime.now()}";


  @override
  void initState() {
    super.initState();
    _initProvider();
  }


  Future<void> _initProvider() async {
    dv = await DotationProvider.instance;
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {


    return NavigationView(
      appBar: NavigationAppBar(),
      content: ScaffoldPage.scrollable(
          children: [
            SfCartesianChart(
                title: ChartTitle(text: "Dotation journalière de ${widget.commName}"),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(
                    isVisible: true
                ),
                primaryXAxis: CategoryAxis(
                ),
                series: <SplineSeries<Dotations, String>>[
                  SplineSeries<Dotations, String>(
                      markerSettings: const MarkerSettings(isVisible: true),
                    name: 'Dotations journalières',
                    dataSource: ListDotations,
                    xValueMapper: (Dotations rt, _) => myDate(rt.dates),
                    yValueMapper: (Dotations rt, _) => rt.dotations,
                    enableTooltip: true
                  )]
            ),
            Center(
              child: Container(
                width: 300,
                child: Card(
                  child:  Wrap(
                    children: [
                      DatePicker(
                        header: 'Début',
                        selected: selected1,
                        onChanged: (time) => setState(() {
                          selected1 = time;
                          holDate = '${selected1?.year}-${selected1?.month}-${selected1?.day}';
                          print(holDate);
                          ListDotations.clear();
                          _fetchData();
                        }),
                      ),


                      DatePicker(
                        header: 'Fin',
                        selected: selected2,
                        onChanged: (time) => setState(() {
                          selected2 = time;
                          holDate2 = '${ selected2?.year}-${ selected2?.month}-${ selected2?.day}';
                          print(holDate2);
                          ListDotations.clear();
                          _fetchData();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

             Wrap(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                    child: Column(
                      children: [
                        Text("Dotations journalière"),
                        Card(
                          borderRadius: BorderRadius.circular(10),
                          child: Text("12", style: TextStyle(fontSize: 20),),
                        )
                      ],
                    )
            ),
                 ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                    child: Column(
                      children: [
                        Text("Montant reconverti"),
                        Card(
                          borderRadius: BorderRadius.circular(10),
                          child: Text("3.000.000" ,style: TextStyle(fontSize: 20),),
                        )
                      ],
                    )
            ),
                 ),
               ]
             )
          ]
      ),
    );
  }

  String myDate(formattedString)
  {
     var day = DateTime.parse(formattedString).day;
     var month = DateTime.parse(formattedString).month;
     var year = DateTime.parse(formattedString).year;

     return "$day-$month-$year";

  }

  // Widget DatePickers(){
  //   return
  // }


  Future<void> _fetchData() async {
    dv.getAllDotation(
      //TODO set this to true
      startDate: holDate,
      endDate: holDate2,
      commId: widget.commId,
        secure: false,
        onSuccess: (r) {
          setState(() {
            ListDotations = r;
            print(ListDotations);
          });
        },
        onError: (e) {
          print(e);
        });
  }
}
