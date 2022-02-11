class UserModel {
  final String id;
  final String email;
  String name;
  final String phone;
  final String bio;
  final String qrCodeLink;
  String photo;
  final List<String> roles;
  final double fee;
  final bool isOnline;
  final String gender;
  final bool isAnonymous;
  final String anonymousId;

  UserModel(
      {this.id,
      this.email,
      this.name,
      this.phone,
      this.bio,
      this.qrCodeLink,
      this.photo,
      this.roles,
      this.fee,
      this.isOnline,
      this.gender,
      this.isAnonymous,
      this.anonymousId});

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      phone: data['phone'] ?? '',
      bio: data['bio'] ?? '',
      qrCodeLink: data['qrCodeLink'] ?? '',
      photo: (data['photo'] != null) ? '${data['photo']['url']}' : '',
      roles: data['roles'] ?? [],
      fee: data['fee'],
      isOnline: data['isOnline'],
      gender: data['gender'],
      isAnonymous: data['isAnonymous'],
      anonymousId: data['anonymousId']);
}
