import 'package:sinflix/core/constants/app_strings.dart';

class ProfileResponse {
  Response? response;
  ProfileResponseData? data;

  ProfileResponse({this.response, this.data});

  bool get isSuccess => response?.code == 200 && data != null;
  bool get hasError => !isSuccess;
  String? get token => data?.token;
  String get errorMessage => response?.message ?? AppStrings.unknownError;

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    data = json['data'] != null ? new ProfileResponseData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Response {
  int? code;
  String? message;

  Response({this.code, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class ProfileResponseData {
  String? sId;
  String? id;
  String? name;
  String? email;
  String? photoUrl;
  String? token;

  ProfileResponseData({this.sId, this.id, this.name, this.email, this.photoUrl, this.token});

  ProfileResponseData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photoUrl = json['photoUrl'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['token'] = this.token;
    return data;
  }
}
