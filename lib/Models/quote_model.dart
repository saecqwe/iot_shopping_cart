class Quote {
  final String q;
  final String a;
  final String h;

  Quote({
    required this.q,
    required this.a,
    required this.h,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      q: json['q'],
      a: json['a'],
      h: json['h'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'a': a,
      'h': h,
    };
  }
}
