library column_sum;

  /// Sum the list columns of each element of the input list.
  /// All elements of the input list have the same structure, with entry values
  /// that are either values or lists.
  /// By default, sum all the columns that are lists.  You can restrict the
  /// columns that are aggregated by using [columnsToIgnore] or [columnsToSum].
  /// Use the function [accept] to control which elements get summed.
  List<Map<String, dynamic>> columnSum(List<Map<String, dynamic>> xs,
      {List<String> columnsToIgnore,
      List<String> columnsToSum,
      bool Function(num) accept}) {
    var out = <Map<String, dynamic>>[];
    if (xs.isEmpty) return out;
    accept ??= (num e) => true;
    var keys = xs.first.keys.toSet();
    if (columnsToIgnore != null) keys.removeAll(columnsToIgnore);
    if (columnsToSum != null) keys = columnsToSum.toSet();
    for (var x in xs) {
      var one = <String, dynamic>{};
      for (var column in keys) {
        if (x[column] is List)
          one[column] =
              sum((x[column] as List).cast<num>().where((e) => accept(e)));
        else
          one[column] = x[column];
      }
      out.add(one);
    }
    return out;
  }
