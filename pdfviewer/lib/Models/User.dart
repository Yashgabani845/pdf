class UserModel {
  String uid;
  String name;
  String email;
  String password;
  String dob;
  String? gender;
  String? profileImageUrl; // New field for profile image URL

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.dob,
    required this.gender,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'dob': dob,
      'gender': gender,
      'profileImageUrl': profileImageUrl, // Include the profile image URL in the map
    };
  }

  // Convert a Map to a User object
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'],
      email: map['email'],
      password: map['password'],
      dob: map['dob'],
      gender: map['gender'],
      profileImageUrl: map['profileImageUrl'], // Fetch the profile image URL
    );
  }
}
