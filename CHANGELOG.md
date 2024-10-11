# Changelog

## TODO:

## Release on 2024-10-11
- Add thead and tbody to the toHtml() method. 
- If specified, use column format in toHtml() method. 

## Release on 2024-09-23
- Improved toHtml() method.  Now allows for adding a class name, caption and 
  customized header rows. 

## Released on 2024-08-02
- Bumped up dependencies

## Released on 2024-02-28
- toHtml() method on Table now correctly applies the 'nullToString' option.

## Released 2023-11-12
- Bumped up dependencies.  Fixed lints.

## Released on 2023-06-16
- Fix bug in join for the JoinType.left and JoinType.right when f != null.
  I was not treating the f != null correctly.  Ouch!

## Released on 2023-05-29
- Bump the skd upper limit to 4.0.0
- Added more tests for toCsv()

## 2.2.0 (Released on 2022-11-27)
- Removed argument `colnamesFromFirstRow` from the `Table.from()` constructor and 
  added a list of column names    
- Cleaned up some package `more` deprecations, remove `Ordering` and use `Comparator`
- Add another example in for `sort_test` to show how to sort by two columns
- Cleaned all analysis errors

## 2.1.1 (Released on 2022-11-27)
- Better treatment for table `toString()` method.  Now using `options` to format  
  individual columns
- Don't print `null`s by default in the `toCsv()` method.  If you need a
  different way to show `null`s, set `options['nullToString']`.
- Modified `copy()` method to accept a list of columns.  Can be used to create 
  another table with a subset of columns in potentially different order
- Added `reorderColumns()` method to shuffle columns in place

## 2.1.0 (Released on 2022-11-26)
- Refactor `Column` to its own file
- Make a setter `options` so you can set the options directly
- Added a new option `nullToString` to deal with null values when printing 
- Better treatment for table `toString()` method.  Now using `options` to format  
individual columns
- Same for `toCsv()` method.  

## Release 2022-11-18
- Add a function to calculate the union of two `List<Map<String,dynamic>>`.   

## 2.0.1 (Released on 2022-05-18)
- Basic support for exporting a table to html

## 2.0.0 (Released on 2021-03-06)
- Migrated to null safety, no new functionality

## 1.2.0 (Released on 2021-03-06)
- Last version before null safety

## 1.1.0 (Released on 2019-03-16)
- Move join functionality out of Table.  Make it work with List<Map<String,dynamic>>.

## 1.0.0 (Released on 2018-09-03)
- First Dart 2 version

## 0.9.0 (Released on 2018-08-30)
- Last Dart 1 version