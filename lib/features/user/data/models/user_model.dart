import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User data model for API communication
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String username,
    required String email,
    required String phone,
    required String website,
    required AddressModel address,
    required CompanyModel company,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts UserModel to User entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      username: username,
      email: email,
      phone: phone,
      website: website,
      address: address.toEntity(),
      company: company.toEntity(),
    );
  }
}

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String street,
    required String suite,
    required String city,
    required String zipcode,
    required GeoModel geo,
  }) = _AddressModel;

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Address toEntity() {
    return Address(
      street: street,
      suite: suite,
      city: city,
      zipcode: zipcode,
      geo: geo.toEntity(),
    );
  }
}

@freezed
class GeoModel with _$GeoModel {
  const factory GeoModel({required String lat, required String lng}) =
      _GeoModel;

  const GeoModel._();

  factory GeoModel.fromJson(Map<String, dynamic> json) =>
      _$GeoModelFromJson(json);

  Geo toEntity() {
    return Geo(lat: lat, lng: lng);
  }
}

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String name,
    required String catchPhrase,
    required String bs,
  }) = _CompanyModel;

  const CompanyModel._();

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Company toEntity() {
    return Company(name: name, catchPhrase: catchPhrase, bs: bs);
  }
}
