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
As in the `R`'s [reshape](http://had.co.nz/reshape/) package, there are 
two functions `melt` and `cast` to allow for reshaping of data. 


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/thumbert/table/issues

