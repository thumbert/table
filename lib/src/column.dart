library column;

import 'dart:math';

class Column<E> {
  List<E?> data;
  String name;

  static int defaultDisplayDigits = 6;

  Column(this.data, this.name);

  E? operator [](int i) => data[i];

  operator []=(int i, E value) => data[i] = value;

  List<E?> toList() => data;

  Iterable<String> paddedOutput(
      {int? width, String Function(E?)? format, String? nullToString}) {
    if (E == double && format == null) {
      /// check if it has fewer decimals than the defaultDisplayDigits
      /// calculate the number of zeros, and define a format function.
      format = (e) {
        if (e == null && nullToString != null) return nullToString;
        return (e as double).toStringAsFixed(defaultDisplayDigits);
      };
      var nZeros = data.fold(defaultDisplayDigits,
          (dynamic prev, e) => min(prev as int, _trailingZeros(format!(e))));
      if (nZeros > 0) {
        format = (e) => (e as num)
            .toDouble()
            .toStringAsFixed(defaultDisplayDigits - nZeros);
      }
    }

    /// the default format
    format ??= (e) {
      if (e == null && nullToString != null) return nullToString;
      return e.toString();
    };
    width ??= data.fold(
        name.length,
        ((prev, e) => max<int>(
            prev!,
            (e == null && nullToString != null)
                ? nullToString.length
                : format!(e).length)));

    var out = <String>[name.padLeft(width!)];
    for (var i = 0; i < data.length; i++) {
      if (data[i] == null && nullToString != null) {
          out.add(nullToString.padLeft(width));
      } else {
        out.add(format(data[i]).padLeft(width));
      }
    }
    return out;
  }

  /// Column data is aligned right (same as in an R data frame)
  /// [width] is the width of the colum, if not specified it will be calculated
  /// from the data.
  ///
  /// [nullToString] controls how to display null values and overrides the
  /// treatment in [format].
  ///
  /// For a numeric column, you can use custom formatting:
  /// (num e) => e.toStringAsFixed(3);
  ///
  @override
  String toString(
      {int? width, String? nullToString, String Function(E?)? format}) {
    return paddedOutput(
            width: width, format: format, nullToString: nullToString)
        .join('\n');
  }

  /// Count the number of zeros from the end of the string to the decimal point.
  int _trailingZeros(String x) {
    var n = x.length - 1;
    while (x[n] != '.' && x[n] == '0') {
      n--;
    }
    return x.length - 1 - n;
  }
}
