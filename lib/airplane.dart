class Airplane {
///the unique identifier
  final int? id;
  ///brand and model of the airplane
  final String type;
  //capacity of airplane
  final int passengers;
  ///maximum speed
  final int maxSpeed;
  ///range distance of the airplane
  final int range;

  Airplane({
    this.id,
    required this.type,
    required this.passengers,
    required this.maxSpeed,
    required this.range,
  });
///toMap:the representation of the event in a form
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'passengers': passengers,
      'maxSpeed': maxSpeed,
      'range': range,
    };
  }
///creates an instance of airplane from a map
  factory Airplane.fromMap(Map<String, dynamic> map) {
    return Airplane(
      id: map['id'],
      type: map['type'],
      passengers: map['passengers'],
      maxSpeed: map['maxSpeed'],
      range: map['range'],
    );
  }
}
