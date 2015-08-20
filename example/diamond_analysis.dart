library examples.diamond_analysis;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:table/table.dart';

/**
 * Investigate how fluid is the table interface for basic data analysis.
 *
 */

/**
 * Pull the diamond data from the web.  Hopefully the url is stable.
 * Return a table.
 */
Future<Table> load_data() async {
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

main() async {

  Table data = await load_data();
  print(data.head());

}