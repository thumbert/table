# Changelog

## TODO:
- Make a setter `options` for `Table`.
- Don't print `null`s.  Make an option to ignore them by default. 

## 2.1.0, Release 2022-11-26
- Refactor `Column` to its own file
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