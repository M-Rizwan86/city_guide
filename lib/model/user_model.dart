

class UserModel {
  final String uId;
  final String username;
  final String email;
  final bool isAdmin;



  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.isAdmin,

  });

  // Serialize the UserModel instance to a JSON map

    Map<String, dynamic> toMap() {
      return {
        'uId': uId,
        'username': username,
        'email': email,
        'isAdmin': isAdmin,
      };
    }

    // Create a UserModel instance from a JSON map

      factory UserModel.fromMap(Map<String, dynamic> json)
    {
      return UserModel(
        uId: json['uId'],
        username: json['username'],
        email: json['email'],
        isAdmin: json['isAdmin'],
      );
    }
    }