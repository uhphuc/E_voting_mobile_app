class KeyModel {
  final BigInt n;
  final BigInt g;

  const KeyModel({
    required this.n,
    required this.g,
  });

  factory KeyModel.fromMap(Map<String, String> map) {
    return KeyModel(
      n: BigInt.parse(map['n']!),
      g: BigInt.parse(map['g']!),
    );
  }

  Map<String, String> toMap() {
    return {
      'n': n.toString(),
      'g': g.toString(),
    };
  }
}