import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/models/model_commerciaux.dart';
import 'package:phil/models/model_reconversion.dart';
import 'package:phil/models/modeldotationsglobales.dart';
import 'package:phil/provider/dotation_provider.dart';
import 'package:phil/provider/queries_provider.dart';
import 'package:phil/provider/reconversion_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailsDotations extends StatefulWidget {
  const DetailsDotations({
    Key? key,
    required this.comms
  }) : super(key: key);

  final Comms comms;


  @override
  State<DetailsDotations> createState() => _DetailsDotationsState();
}

class _DetailsDotationsState extends State<DetailsDotations> {


  List<Dotations> ListDotations = [];
  List<String> labels = ["Courbes de dotations", "Courbe de reconversions"];
  List<Rec> reconversion = [];
  bool gotData = true;
  bool getDataError = false;
  late final QueriesProvider _provider;
  late DotationProvider dv;
  late ReconversionProvider rv;

  DateTime dt = DateTime.now().subtract(Duration(days: 7));

  late String holDate = "${dt.year}-${dt.month}-${dt.day}";
  String holDate2 = "${DateTime.now()}";
  int? selected;


  @override
  void initState() {
    super.initState();
    _initProvider();
  }


  Future<void> _initProvider() async {
    dv = await DotationProvider.instance;
    rv = await ReconversionProvider.instance;
    _provider = await QueriesProvider.instance;
    _fetchData();
    _fetchDataRec();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(),
      content: ScaffoldPage.scrollable(
          children: [


        Chart(),

            Center(
              child: Container(
                width: 300,
                child: Card(
                  child: Wrap(
                    children: [

                      DatePicker(
                        header: 'Début',
                        selected: widget.comms.startDateTime,
                        onChanged: (time) =>
                            setState(() {
                              widget.comms.startDateTime = time;
                              holDate = '${widget.comms.startDateTime?.year}-'
                                  '${widget.comms.startDateTime?.month}-'
                                  '${widget.comms.startDateTime?.day}';
                              ListDotations.clear();
                              _fetchData();
                             }),
                      ),


                      DatePicker(
                        header: 'Fin',
                        selected: widget.comms.endDateTime,
                        onChanged: (time) =>
                            setState(() {
                              widget.comms.endDateTime = time;
                              holDate2 = '${ widget.comms.endDateTime?.year}-'
                                  '${ widget.comms.endDateTime?.month}-'
                                  '${ widget.comms.endDateTime?.day}';
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

  String myDate(formattedString) {
    var day = DateTime
        .parse(formattedString)
        .day;
    var month = DateTime
        .parse(formattedString)
        .month;
    var year = DateTime
        .parse(formattedString)
        .year;

    return "$day-$month-$year";
  }


  Future<void> _fetchDataRec() async {
    rv.getAllReconversion(
      //TODO set this to true
        startDate: holDate,
        endDate: holDate2,
        commId: widget.comms.id,
        secure: false,
        onSuccess: (r) {
          setState(() {
            reconversion = r;
          });
        },
        onError: (e) {
          print(e);
        });
  }

  List<ChartSeries<dynamic, dynamic>> gotCHarts()
   {
    return <ChartSeries>[
      SplineSeries<Dotations, String>(

        markerSettings: const MarkerSettings(isVisible: true),
        name: 'Dotations journalières',
        dataSource: ListDotations,
        xValueMapper: (Dotations rt, _) => myDate(rt.dates),
        yValueMapper: (Dotations rt, _) => rt.dotations,
        color: Color.fromRGBO(8, 142, 255, 1),
      ),

    ];
  }

  Widget Chart()
  {
    if(gotData)
    {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 100.0),
          child: SizedBox(
            height: 100,
            width: 100,
            child: ProgressBar(),
          ),
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
                _fetchData();
              },
              child: const Text('Relancer'
              ),
            ),
          ),
        ],
      );
    }
     return SfCartesianChart(
        title: ChartTitle(text: "Dotation journalière de ${widget.comms
            .nomCommerciaux}"),
        tooltipBehavior: TooltipBehavior(enable: true),
        legend: Legend(
            isVisible: true,
            toggleSeriesVisibility: true
        ),
        primaryXAxis: CategoryAxis(
        ),
        series: gotCHarts()
    );
  }


  Future<void> _fetchData() async {
    setState(() {
      gotData = true;
      getDataError = false;
    });
    dv.getAllDotation(
      //TODO set this to true
        startDate: holDate,
        endDate: holDate2,
        commId: widget.comms.id,
        secure: false,
        onSuccess: (r) {
          setState(() {
            ListDotations = r;
          });
          setState(() {
            gotData = false;
            getDataError = false;
          });
        },

        onError: (e) {
          setState(() {
            gotData = false;
            getDataError = true;
          });
          print(e);
        });
  }


}

