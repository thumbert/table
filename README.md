# table

Various utilities for interacting with tabular like data.  In particular, 
it contains an implementation of the *Nest* framework as introduced in 
the [D3](https://github.com/d3/d3-collection#nests) nests package.

## Usage
Here's an example using Cleveland's barley data.  
To calculate the total yield by year and variety do

```dart
var nest = Nest()
  ..key((d) => d['year'])
  ..key((d) => d['variety'])
  ..rollup((List xs) => sum(xs.map((e) => e['yield'])));
var res = nest.map(barley) as Map;
```
The result will be a two-level nested map.


 
#### Reshape (melt and cast) 
As in the `R`'s [reshape](http://had.co.nz/reshape/) package, there is the function 
`melt` to allow for reshaping the data into a 
[third normal form](https://en.wikipedia.org/wiki/Third_normal_form). 

Use `aggregate` to apply a function to several columns given a set of grouping factors. 

Use `join` to join two lists of maps in SQL sense.  For example, given 
```dart
var t1 = <Map<String,dynamic>>[
  {'code': 'BOS', 'Tmin': 30},
  {'code': 'BWI', 'Tmin': 32},
  {'code': 'LAX', 'Tmin': 49}
];
var t2 = <Map<String,dynamic>>[
  {'code': 'BOS', 'Tmax': 95},
  {'code': 'ORH', 'Tmax': 92},
  {'code': 'LAX', 'Tmax': 82}
];
```
Return the rows that match by the common columns, in this case only the column `code`.
```dart
var t12 = table.join(t1, t2);
// the default is to do an inner join
//[
//  {'code': 'BOS', 'Tmin': 30, 'Tmax': 95},
//  {'code': 'LAX', 'Tmin': 49, 'Tmax': 82}
//];
```
You can also pass in a function to calculate new columns.  For example, given the two 'tables' above, 
to calculate a new column with the `Tmax - Tmin` difference for each airport do
```dart
var diff = table.join(t1, t2, f: (x, y) => [MapEntry('diff', y['Tmax'] - x['Tmin'])]);
//{'code': 'BOS', 'diff': 65},
//{'code': 'LAX', 'diff': 33}
```
The argument `f` is only taken into account for an inner join. 


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

