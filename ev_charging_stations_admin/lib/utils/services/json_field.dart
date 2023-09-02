class JsonSerializable{
    const JsonSerializable();
}

class JSONField { 
  final String? name;
  final bool? serialize;
  final bool? deserialize;

  const JSONField({this.name, this.serialize, this.deserialize});
}
