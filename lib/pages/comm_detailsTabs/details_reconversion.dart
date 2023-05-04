import 'package:fluent_ui/fluent_ui.dart';
import 'package:phil/models/model_commerciaux.dart';
import 'package:phil/models/model_reconversion.dart';
import 'package:phil/provider/queries_provider.dart';
import 'package:phil/provider/reconversion_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class DetailsReconversion extends StatefulWidget {
  const DetailsReconversion({Key? key,
    required this.comms}) : super(key: key);
  final Comms comms;
  @override
  State<DetailsReconversion> createState() => _DetailsReconversionState();
}

class _DetailsReconversionState extends State<DetailsReconversion> {

  List<Rec> reconversion = [];
  late ReconversionProvider rv;
  bool gotData = true;
  bool getDataError = false;
  DateTime dt = DateTime.now().subtract(Duration(days: 7));
  late String holDate = "${widget.comms.startDateTime!.year}-${widget.comms.startDateTime!.month}-${widget.comms.startDateTime!.day}";
  String holDate2 = "${DateTime.now()}";
  late final QueriesProvider _provider;
  int? selected;

  @override
  void initState() {
    super.initState();
    _initProvider();
  }

  Future<void> _initProvider() async {
    rv = await ReconversionProvider.instance;
    _provider = await QueriesProvider.instance;
    _fetchDataRec();
  }
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(),
      content: ScaffoldPage.scrollable(
          children: [
            chart(),



            Center(
              child: Container(
                width: 300,
                child: Card(
                  child: Wrap(
                    children: [

                      DatePicker(
                        header: 'Début',
                        selected: widget.comms.startDateTimeR,
                        onChanged: (time) =>
                            setState(() {
                              widget.comms.startDateTimeR = time;
                              holDate = '${widget.comms.startDateTimeR?.year}-'
                                  '${widget.comms.startDateTimeR?.month}-'
                                  '${widget.comms.startDateTimeR?.day}';
                              print(holDate);
                              reconversion.clear();
                              _fetchDataRec();
                            }),
                      ),


                      DatePicker(
                        header: 'Fin',
                        selected: widget.comms.endDateTimeR,
                        onChanged: (time) =>
                            setState(() {
                              widget.comms.endDateTimeR = time;
                              holDate2 = '${ widget.comms.endDateTimeR?.year}-'
                                  '${ widget.comms.endDateTimeR?.month}-'
                                  '${ widget.comms.endDateTimeR?.day}';
                              print(holDate2);
                              reconversion.clear();
                              _fetchDataRec();
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
  Future<void> _fetchDataRec() async {
    setState(() {
      gotData = true;
      getDataError = false;
    });
    rv.getAllReconversion(
      //TODO set this to true
        startDate: holDate,
        endDate: holDate2,
        commId: widget.comms.id,
        secure: false,
        onSuccess: (r) {
          setState(() {
            gotData = false;
            getDataError = false;
          });
          setState(() {
            reconversion = r;
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

  Widget chart()
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
                _fetchDataRec();
              },
              child: const Text('Relancer'
              ),
            ),
          ),
        ],
      );
    }
    return SfCartesianChart(
        title: ChartTitle(text: "Reconversion journalière de ${widget.comms
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

  List<ChartSeries<dynamic, dynamic>> gotCHarts()
  {
    return <ChartSeries>[
      ColumnSeries<Rec, String>(
          markerSettings: const MarkerSettings(isVisible: true),
          name: 'Reconversion',
          dataSource: reconversion,
          xValueMapper: (Rec rc, _) => myDate(rc.date),
          yValueMapper: (Rec rc, _) => rc.reconversion,
          color: Color.fromRGBO(8, 142, 255, 1)
      ),

    ];
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
}
