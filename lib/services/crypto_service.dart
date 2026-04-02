import 'dart:convert';
import 'package:project/models/key_model.dart';

import '../../../core/constants/api_client.dart';


class CryptoService {

  static Future<KeyModel?> getPublicKey() async {

    final response = await ApiClient.get("/keys/public-key");

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return KeyModel(
        n: BigInt.parse(data["publicKey"]["n"]),
        g: BigInt.parse(data["publicKey"]["g"]),
      );
    }

    return null;
  }
}