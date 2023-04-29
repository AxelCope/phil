void main()
{
  DateTime ok = DateTime.now();
  Duration k = Duration(days: 2);
  var substart = ok.subtract(k);

  print("${substart.day}-${substart.month}-${substart.year}");
}