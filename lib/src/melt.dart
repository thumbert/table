library melt.dart;

List<Map<String,dynamic>> melt(List<Map<String,dynamic>> xs,
    Set<String> tagsKey, Set<String> variablesKey, {String value: 'value'}) {
  var aux = <Map<String,dynamic>>[];
  for (var x in xs) {
    for (var key in variablesKey) {
      var one = Map.fromEntries(x.entries.where((e) => tagsKey.contains(e.key)));
      one['variable'] = key;
      one[value] = x[key];
      aux.add(one);
    }
  }
  return aux;
}
