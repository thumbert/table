library all_test;

import 'flatten_test.dart' as flatten;
import 'nest_test.dart' as nest;
import 'reshape_test.dart' as reshape;
import 'table_test.dart' as table;

main() {
  flatten.main();
  nest.main();
  reshape.tests();
  table.main();
}
