library all_test;

import 'flatten_test.dart' as flatten;
import 'nest_test.dart' as nest;
import 'reorder_columns_test.dart' as reorder;
import 'reshape_test.dart' as reshape;
import 'table_test.dart' as table;
import 'unique_test.dart' as unique;

main() {
  flatten.main();
  nest.main();
  reorder.tests();
  reshape.tests();
  table.main();
  unique.tests();
}
