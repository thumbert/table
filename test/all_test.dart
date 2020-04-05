library all_test;

import 'aggregate_test.dart' as aggregate;
import 'expand_map_of_list_test.dart' as c2r;
import 'collapse_list_of_map_test.dart' as r2c;
import 'flatten_test.dart' as flatten;
import 'join_test.dart' as join;
import 'melt_test.dart' as melt;
import 'nest_test.dart' as nest;
import 'reorder_columns_test.dart' as reorder;
import 'reshape_test.dart' as reshape;
import 'table_test.dart' as table;
import 'unique_test.dart' as unique;

void main() {
  aggregate.tests();
  c2r.tests();
  r2c.tests();
  flatten.main();
  join.tests();
  melt.tests();
  nest.tests();
  reorder.tests();
  reshape.tests();
  table.main();
  unique.tests();
}
