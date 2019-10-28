library all_test;

import 'columns_to_rows_test.dart' as c2r;
import 'rows_to_columns_test.dart' as r2c;
import 'flatten_test.dart' as flatten;
import 'join_test.dart' as join;
import 'nest_test.dart' as nest;
import 'reorder_columns_test.dart' as reorder;
import 'reshape_test.dart' as reshape;
import 'table_test.dart' as table;
import 'unique_test.dart' as unique;

main() {
  c2r.tests();
  r2c.tests();
  flatten.main();
  join.tests();
  nest.main();
  reorder.tests();
  reshape.tests();
  table.main();
  unique.tests();
}
