

library test.collections.flattenmap;

import 'package:test/test.dart';
import 'package:table/src/flattenMap.dart';

test1() {
  Map data = {
    '7x8': {'Jan15': 58.37, 'Feb15': 108.12},
    '2x16H': {'Jan15': 68.29, 'Feb15': 113.95},
    '5x16': {'Jan15': 81.92, 'Feb15': 136.54}
  };

  List res = flattenMap(data);
  res.forEach(print);
//  test('two levels', () {
//      expect(1,1);
//  });
//

}


main() {
  test1();
}
