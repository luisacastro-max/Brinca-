import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static var db, userCollection;

  static connect() async {
    db = await Db.create("SUA_URL_DO_MONGODB_AQUI");
    await db.open();
    userCollection = db.collection("users");
  }

  static Future<bool> verificarLogin(String email, String senha) async {
    try {
      // Busca o usuário pelo email
      var user = await userCollection.findOne(where.eq('email', email));

      if (user != null) {
        // Em um app real, use criptografia (ex: BCrypt) para comparar a senha
        if (user['senha'] == senha) {
          return true; // Login bem-sucedido
        }
      }
      return false;
    } catch (e) {
      print("Erro ao conectar ao MongoDB: $e");
      return false;
    }
  }
}