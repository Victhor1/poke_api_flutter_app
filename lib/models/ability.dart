class Ability {
  String? name;

  Ability({this.name});

  factory Ability.fromJson(Map<String, dynamic> json) => Ability(
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {"name": name};
}
