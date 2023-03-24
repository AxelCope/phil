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

  Dotations dt = Dotations(startDate: DateTime.parse(holDate), endDate: DateTime.parse(holDate2));

  static DateTime? selected1 = DateTime(2023, 03, 13);
  static DateTime? selected2 = DateTime.now();
  static String holDate = "2023-03-13";
  static String holDate2 = "${DateTime.now()}";


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
                width: 400,
                child: Card(
                  child: Wrap(
                    children: [
                      DatePicker(
                        header: 'Date de début',
                        selected: selected1,
                        onChanged: (time) => setState(() {
                          selected1 = time;
                          dt.startDate = time;
                          holDate = '${dt.startDate?.year}-0${dt.startDate?.month}-${dt.startDate?.day}';
                          ListDotations.clear();
                          _fetchData();
                        }),
                      ),
                      SizedBox(width: 20,),

                      DatePicker(
                        header: 'Date de fin',
                        selected: selected2,
                        onChanged: (time) => setState(() {
                          dt.endDate = time;
                          selected2 = time;
                          holDate2 = '${ dt.endDate?.year}-0${ dt.endDate?.month}-${ dt.endDate?.day}';
                          ListDotations.clear();
                          _fetchData();
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }

  String myDate(formattedString)
  {
     var day = DateTime.parse(formattedString).day;
     var month = DateTime.parse(formattedString).month;
     var year = DateTime.parse(formattedString).year;

     return "$day/$month/$year";

  }

  // Widget DatePickers(){
  //   return
  // }


  Future<void> _fetchData() async {
    dv.getAllDotation(
      //TODO set this to true
      startDate: dt.startDate.toString(),
      endDate: dt.endDate.toString(),
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
