class ItombModel {
  final String id;
  final String name;
  final String dateOfBirth;
  final String dateOfPass;
  final String bio;
  final String qrCodeLink;
  final String photo;
  final List<String> video;
  final String gender;
  final String userId;

  ItombModel(
      {this.id,
      this.name,
      this.dateOfBirth,
      this.dateOfPass,
      this.bio,
      this.qrCodeLink,
      this.photo,
      this.video,
      this.gender,
      this.userId});

  factory ItombModel.fromJson(Map<String, dynamic> data) => ItombModel(
      id: data['id'],
      name: data['name'],
      dateOfBirth: data['dob'],
      dateOfPass: data['dop'],
      bio: data['bio'] ?? '',
      qrCodeLink: data['qrCodeLink'] ?? '',
      photo: (data['photo'] != null) && (data['photo'].length > 0)
          ? '${data['photo'].first['url']}'
          : '',
      video: [],
      gender: data['gender'],
      userId: data['user']);
}
