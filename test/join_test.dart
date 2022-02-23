import 'package:test/test.dart';
import 'package:table/table.dart' as table;
import 'package:table/table_base.dart' as table_base;

void tests() {
  group('Join two tables', () {
    test('joins by one column, no aggregation function', () {
      var t1 = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ];
      var t2 = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmax': 95},
        {'code': 'ORH', 'Tmax': 92},
        {'code': 'LAX', 'Tmax': 82}
      ];
      var ti = table.join(t1, t2);
      expect(ti.length, 2);
      expect(ti.map((e) => e['code']).toList(), ['BOS', 'LAX']);
      expect(ti.map((e) => e['Tmax']).toList(), [95, 82]);

      var tl = table.join(t1, t2, joinType: table_base.JoinType.left);
      expect(tl.length, 3);
      expect(tl.map((e) => e['Tmax']).toList(), [95, 82, null]);

      var tr = table.join(t1, t2, joinType: table_base.JoinType.right);
      expect(tr.length, 3);
      expect(tr.map((e) => e['code']).toList(), ['BOS', 'LAX', 'ORH']);
      expect(tr.map((e) => e['Tmin']).toList(), [30, 49, null]);

      var to = table.join(t1, t2, joinType: table_base.JoinType.outer);
      expect(to.length, 4);
      expect(to.map((e) => e['code']).toList(), ['BOS', 'LAX', 'BWI', 'ORH']);
      expect(to.map((e) => e['Tmin']).toList(), [30, 49, 32, null]);
      expect(to.map((e) => e['Tmax']).toList(), [95, 82, null, 92]);
    });
    test('joins by one column, with aggregation function', () {
      var t1 = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmin': 30},
        {'code': 'BWI', 'Tmin': 32},
        {'code': 'LAX', 'Tmin': 49}
      ];
      var t2 = <Map<String, dynamic>>[
        {'code': 'BOS', 'Tmax': 95},
        {'code': 'ORH', 'Tmax': 92},
        {'code': 'LAX', 'Tmax': 82}
      ];
      var ti = table.join(t1, t2,
          f: (x, y) => [MapEntry('Tmax - Tmin', y['Tmax'] - x['Tmin'])]);
      expect(ti.length, 2);
      expect(ti.map((e) => e['code']).toList(), ['BOS', 'LAX']);
      expect(ti.map((e) => e['Tmax - Tmin']).toList(), [65, 33]);
    });
    test('join with specified column names', () {
      var t1 = <Map<String, dynamic>>[
        {'code': 'BOS', 'value': 30},
        {'code': 'BWI', 'value': 32},
        {'code': 'LAX', 'value': 49}
      ];
      var t2 = <Map<String, dynamic>>[
        {'code': 'BOS', 'value': 95},
        {'code': 'ORH', 'value': 92},
        {'code': 'LAX', 'value': 82}
      ];
      var ti = table.join(t1, t2,
          byColumns: ['code'],
          f: (x, y) => [MapEntry('value', y['value'] - x['value'])]);
      expect(ti.length, 2);
      expect(ti.map((e) => e['code']).toList(), ['BOS', 'LAX']);
      expect(ti.map((e) => e['value']).toList(), [65, 33]);
    });
  });
}

void main() {
  tests();
}
