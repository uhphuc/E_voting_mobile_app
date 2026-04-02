import 'dart:math';
import 'dart:typed_data';
import 'package:project/models/key_model.dart';

class PaillierService {

  static final Random _random = Random.secure();

  static String encryptVote(KeyModel pubKey, bool isYes) {

    final BigInt n = pubKey.n;
    final BigInt g = pubKey.g;
    final BigInt nSquared = n * n;

    final BigInt m = isYes ? BigInt.one : BigInt.zero;

    /// generate random r
    final BigInt r = _generateRandom(n);

    final BigInt part1 = g.modPow(m, nSquared);
    final BigInt part2 = r.modPow(n, nSquared);

    final BigInt cipher = (part1 * part2) % nSquared;

    return cipher.toString();
  }

  static BigInt _generateRandom(BigInt n) {

    final int byteLength = (n.bitLength / 8).ceil();

    final Uint8List bytes = Uint8List(byteLength);

    for (int i = 0; i < byteLength; i++) {
      bytes[i] = _random.nextInt(256);
    }

    BigInt r = BigInt.zero;

    for (final b in bytes) {
      r = (r << 8) | BigInt.from(b);
    }

    return r % n;
  }
  static String encryptVoteIsolate(KeyModel publicKey) {

    final cipher = PaillierService.encryptVote(
      publicKey,
      true,
    );

    return cipher;
  }
}