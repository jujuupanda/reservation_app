part of 'repositories.dart';

class UserRepo {
  late String statusCode;
  late String error;

  /// get single user by username
  getUser(String username) async {
    statusCode = "";
    try {
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      if (resultUser.docs.isNotEmpty) {
        statusCode = "200";
        final user = resultUser.docs.first;
        final userModel = UserModel.fromJson(user.data());
        return userModel;
      } else {
        statusCode = "200";
        return;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// tambah user
  register(
    String agency,
    String username,
    String password,
    String fullName,
    String role,
  ) async {
    statusCode = "";
    error = "";

    try {
      /// check if user already exist
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("username", isEqualTo: username.toLowerCase())
          .get();
      if (resultUser.docs.isNotEmpty) {
        /// username is exist
        error = "Username sudah digunakan";
      } else {
        /// add user
        await Repositories().db.collection("users").add({
          "id": "",
          "agency": agency,
          "username": username.toLowerCase(),
          "password": password,
          "fullName": fullName,
          "email": "",
          "phone": "",
          "image": "",
          "role": role,
        }).then(
          (value) {
            Repositories()
                .db
                .collection("users")
                .doc(value.id)
                .update({"id": value.id});
          },
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///admin: Get user berdasarkan instansi
  getAllUserByAgency(String agency) async {
    statusCode = "";
    try {
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("agency", isEqualTo: agency)
          .where("role", isEqualTo: "2")
          .get();
      if (resultUser.docs.isNotEmpty) {
        statusCode = "200";
        final List<UserModel> users =
            resultUser.docs.map((e) => UserModel.fromJson(e)).toList();

        return users;
      } else {
        statusCode = "200";
        final List<UserModel> users = [];
        return users;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///super admin: get all user
  getAllUserSuperAdmin() async {
    statusCode = "";
    try {
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("role", isEqualTo: "1")
          .get();
      if (resultUser.docs.isNotEmpty) {
        statusCode = "200";
        final List<UserModel> users =
            resultUser.docs.map((e) => UserModel.fromJson(e)).toList();

        return users;
      } else {
        statusCode = "200";
        final List<UserModel> users = [];
        return users;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///delete user
  deleteUser(String id) async {
    statusCode = "";
    try {
      await Repositories().db.collection("users").doc(id).delete();
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///delete user
  deleteUserSuperAdmin(String agency) async {
    statusCode = "";
    WriteBatch batch = Repositories().db.batch();
    try {
      final responseListUser = await Repositories()
          .db
          .collection("users")
          .where("agency", isEqualTo: agency)
          .get();
      final List<UserModel> listUser = responseListUser.docs
          .map(
            (e) => UserModel.fromJson(e),
          )
          .toList();
      for (var user in listUser) {
        DocumentReference docRef =
            Repositories().db.collection("users").doc(user.id);
        batch.delete(docRef);
      }
      await batch.commit();
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///edit/update user
  editUser(
    String id,
    String agency,
    String username,
    String password,
    String fullName,
    String email,
    String phone,
  ) async {
    statusCode = "";
    try {
      await Repositories().db.collection("users").doc(id).update({
        "agency": agency,
        "username": username,
        "password": password,
        "fullName": fullName,
        "email": email,
        "phone": phone,
      });
      statusCode = "200";
    } catch (e) {
      throw Exception(e);
    }
  }

  ///edit profile picture
  editProfilePicture(
    String id,
    String image,
  ) async {
    statusCode = "";
    try {
      await Repositories().db.collection("users").doc(id).update({
        "image": image,
      });
      statusCode = "200";
    } catch (e) {
      throw Exception(e);
    }
  }

  ///edit password
  editPassword(
    String id,
    String username,
    String oldPassword,
    String newPassword,
  ) async {
    statusCode = "";
    error = "";
    try {
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("username", isEqualTo: username)
          .get();

      if (resultUser.docs.isNotEmpty) {
        final doc = resultUser.docs.first;
        if (doc["password"] == oldPassword) {
          await Repositories().db.collection("users").doc(id).update({
            "password": newPassword,
          });
        } else {
          error = "Password lama anda salah!";
        }
      } else {
        error = "Pengguna tidak ditemukan!";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// change username only
  changeUsername(
    String id,
    String username,
  ) async {
    error = "";

    /// check if user already exist
    QuerySnapshot resultUser = await Repositories()
        .db
        .collection("users")
        .where("username", isEqualTo: username.toLowerCase())
        .get();
    if (resultUser.docs.isNotEmpty) {
      /// username is exist
      error = "Username sudah digunakan";
    } else {
      await Repositories().db.collection("users").doc(id).update({
        "username": username,
      });
    }

    /// add user
  }
}
