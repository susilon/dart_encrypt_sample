import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

void main() async {
  final publicKey = await parseKeyFromFile<RSAPublicKey>('files/rsa.public');
  final privKey = await parseKeyFromFile<RSAPrivateKey>('files/rsa.private');

// encrypt decrypt
  print('encrypt decrypt');
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final encrypter = Encrypter(RSA(publicKey: publicKey));
  final encrypted = encrypter.encrypt(plainText);
  //print(encrypted.bytes);
  //print(encrypted.base16);
  print(encrypted.base64);
  // --
  final decrypter = Encrypter(RSA(privateKey: privKey));
  final decrypted = decrypter.decrypt(encrypted);
  print(decrypted);

// signature verification
  print('signature verification');
  final signer = Signer(RSASigner(RSASignDigest.SHA256, privateKey: privKey));
  final signedtext = signer.sign(decrypted).base64;
  print(signedtext);
  // --
  final verifier =
      Signer(RSASigner(RSASignDigest.SHA256, publicKey: publicKey));
  print(verifier.verify64(plainText, signedtext));
}
