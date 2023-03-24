// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:phil/models/modeldotationsglobales.dart';
// import 'package:phil/provider/dotation_provider.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class StatistiquesGenerales extends StatefulWidget {
//   const StatistiquesGenerales({Key? key}) : super(key: key);
//
//   @override
//   State<StatistiquesGenerales> createState() => _StatistiquesGeneralesState();
// }
//
// class _StatistiquesGeneralesState extends State<StatistiquesGenerales> {
//
//   late DotationProvider dv;
//   List<Dotations> sr = [];
//   @override
//   void initState() {
//     super.initState();
//     _initProvider();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  NavigationView(
//         appBar: NavigationAppBar(),
//       content:SfCartesianChart(
//           title: ChartTitle(text: "Courbe des dotations journalières"),
//           legend: Legend(
//               isVisible: true
//           ),
//           primaryXAxis: CategoryAxis(),
//           series: <LineSeries<Dotations, String>>[
//             LineSeries<Dotations, String>(
//               name: 'Dotations journalières',
//               dataSource: sr,
//               xValueMapper: (Dotations rt, _) => rt.dates.toString(),
//               yValueMapper: (Dotations rt, _) => rt.dotations,
//             )]
//       ),);
//   }
//
//   Future<void> _initProvider() async {
//     dv = await DotationProvider.instance;
//     _fetchData();
//   }
//
//   Future<void> _fetchData() async {
//     dv.getAllDotation(
//       //TODO set this to true
//       secure: false,
//         onSuccess: (r) {
//         setState(() {
//           sr = r;
//           print(sr);
//         });
//         },
//         onError: (e) {
//         print(e);
//         });
//   }
// }
//
