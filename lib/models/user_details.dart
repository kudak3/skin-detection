import 'package:json_annotation/json_annotation.dart';

part 'user_details.g.dart';

@JsonSerializable()
class UserDetails {
  String uid;
  String displayName;
  String email;
  String photoUrl;
  String firstName;
  String lastName;
  String phoneNumber;
  String address;

  UserDetails(this.uid, this.displayName, this.email, this.photoUrl,
      this.firstName, this.lastName, this.phoneNumber, this.address);

  UserDetails.optional(
      {this.uid,
      this.displayName,
      this.email,
      this.photoUrl,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.address});

  //
  @override
  String toString() {
    return 'User{uid:$uid,displayName:$displayName,email:$email,photoUrl:$photoUrl,firstName:$firstName,lastName:$lastName,phoneNumber:$phoneNumber,address:$address}';
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
}
