import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/models/commerciaux.dart';
import 'package:phil/models/modeldotationsglobales.dart';
import 'package:phil/provider/dotation_provider.dart';
import 'package:phil/provider/queries_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PageDetailsCommerciaux extends StatefulWidget {
  const PageDetailsCommerciaux({
    Key? key,
    required this.comms
  }) : super(key: key);

  final Comms comms;


  @override
  State<PageDetailsCommerciaux> createState() => _PageDetailsCommerciauxState();
}

class _PageDetailsCommerciauxState extends State<PageDetailsCommerciaux>{


  List<Dotations> ListDotations = [];
  bool gotData = true;
  bool getDataError = false;
  late final QueriesProvider _provider;
  late DotationProvider dv;

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
                title: ChartTitle(text: "Dotation journalière de ${widget.comms.nomCommerciaux}"),
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
                        selected: widget.comms.startDateTime,
                        onChanged: (time) => setState(() {
                          widget.comms.startDateTime = time;
                          holDate = '${widget.comms.startDateTime?.year}-'
                              '${widget.comms.startDateTime?.month}-'
                              '${widget.comms.startDateTime?.day}';
                          print(holDate);
                          ListDotations.clear();
                          _fetchData();
                        }),
                      ),


                      DatePicker(
                        header: 'Fin',
                        selected: widget.comms.endDateTime,
                        onChanged: (time) => setState(() {
                          widget.comms.endDateTime = time;
                          holDate2 = '${ widget.comms.endDateTime?.year}-'
                              '${ widget.comms.endDateTime?.month}-'
                              '${ widget.comms.endDateTime?.day}';
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
      commId: widget.comms.id,
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
