import 'dart:convert';
import 'package:c_lient/core/constants/server_constants.dart';
import 'package:c_lient/core/failure/failure.dart';
import 'package:c_lient/features/auth/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remort_reposiitery.g.dart';

@riverpod
AuthRemortRepositery authRemortRepositery(Ref ref) {
  return AuthRemortRepositery();
}

class AuthRemortRepositery {
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${ServerConstants.baseUrl}/auth/signup"),
        body: jsonEncode({"name": name, "email": email, "password": password}),
        headers: {'Content-Type': "application/json"},
      );
      if (response.statusCode == 201) {
        return right(User.fromJson(response.body));
      }
      final resbody = jsonDecode(response.body);
      throw resbody['detail'];
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, User>> getUserData({required String token}) async {
    try {
      http.Response response = await http.get(
        Uri.parse("${ServerConstants.baseUrl}/auth/"),

        headers: {'Content-Type': "application/json", "x-auth-token": token},
      );
      final resbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(resbody);
        return right(User.fromMap(resbody).copyWith(token: token));
      }
      return left(Failure(message: resbody['detail']));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    print("inside sign in");

    try {
      http.Response response = await http.post(
        Uri.parse("${ServerConstants.baseUrl}/auth/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': "application/json"},
      );
      print(response.body);
      final resbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(resbody);
        return right(
          User.fromMap(resbody['user']).copyWith(token: resbody['token']),
        );
      }

      return left(Failure(message: resbody['detail']));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
