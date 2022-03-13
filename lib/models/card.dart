class Card {
  String? name;
  String? url;

  Card({
    this.name,
    this.url,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      name: json['name'],
      url: json['url'],
    );
  }
}
