library examples.diamond_analysis;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:table/table.dart';

/**
 * Investigate how fluid the table interface is for basic data analysis.
 *
 */

/**
 * Pull the diamond data from the web.  Hopefully the url is stable.
 * Return a table.
 */
Future<Table> loadData() async {
  String url = "https://vincentarelbundock.github.io/Rdatasets/csv/Ecdat/Diamond.csv";
  HttpClientRequest request = await new HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String res = await response.transform(UTF8.decoder).join();

  List<Map> rows = [];
  List keys = ['id', 'carat', 'color', 'clarity', 'certification', 'price'];
  List<List> aux = new CsvToListConverter(eol: '\n').convert(res);
  aux.skip(1).forEach((List row) => rows.add(new Map.fromIterables(keys, row)));

  return new Table.from(rows);
}

dataAnalysis(Table data){
  print('\ncount of diamonds per clarity');
  Table c = data.groupApply(['clarity'], ['clarity'], (x) => x.length);
  print(c);

  print('\ncount of clarity vs. color');
  Table cc = data.cast(['clarity'], ['color'], (x) => x.length, fill: 0);
  print(cc);


}


main() async {

  Table data = await loadData();
  print(data.head());
  print('number of rows: ${data.nrow}');

  dataAnalysis(data);

}