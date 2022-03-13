class Sprites {
  String? backDefault;
  String? frontDefault;

  Sprites({
    this.backDefault,
    this.frontDefault,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        backDefault: json["back_default"],
        frontDefault: json["front_default"],
      );

  Map<String, dynamic> toJson() => {
        "back_default": backDefault,
        "front_default": frontDefault,
      };
}
