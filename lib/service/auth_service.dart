import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sammychatbot/models/custom_response.dart';
import 'package:sammychatbot/models/user.dart';
import 'package:sammychatbot/service/http_service.dart';
import 'package:sammychatbot/service/storage_service.dart';
import 'package:sammychatbot/widgets/notification_card.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();

  AuthService._internal();
  final _httpService = HttpService();

  factory AuthService() {
    return _singleton;
  }

  Future<bool> register(String fullName, String email, String password) async {
    try {
      final data = {
        "full_name": fullName.trim(),
        "email": email.trim(),
        "password": password
      };

      Response<dynamic>? response =
          await _httpService.post("auth/user/register", data);

      var message = response!.data;
      if (response.statusCode! >= 400) {
        final customResponse = CustomResponse.fromJson(message);
        print("status_code ${customResponse.message}");
        if (customResponse.validationErrors != null &&
            customResponse.validationErrors!.isNotEmpty) {
          customResponse.validationErrors?.forEach((each) {
            showOverlayNotification((context) {
              return notifcationCard(
                  context,
                  "Invalid Input",
                  customResponse.message,
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
            }, duration: const Duration(seconds: 4));
          });
        } else {
          showOverlayNotification((context) {
            return notifcationCard(
                context,
                "Error Occurred",
                customResponse.message,
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ));
          }, duration: const Duration(seconds: 4));
        }
      } else {
        showOverlayNotification((context) {
          return notifcationCard(
              context,
              "Registration Successful 🥳",
              "You'll now be redirected to login page ",
              const Icon(
                Icons.check_circle_rounded,
                color: Color.fromARGB(255, 11, 100, 209),
              ));
        },
            duration: const Duration(
              seconds: 4,
            ));

        return true;
      }
    } catch (e) {
      showOverlayNotification((context) {
        return notifcationCard(
            context,
            "An Error Occured",
            "Please check you network connection",
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
            ));
      }, duration: const Duration(seconds: 4));
    }

    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      Response? response = await _httpService.post(
          "auth/user/authenticate", {"email": email, "password": password});
      print("status_code: ${response!.statusCode}");
      if (response.statusCode! >= 400 && response.data != null) {
        final customResponse = CustomResponse.fromJson(response.data);
        if (customResponse.validationErrors != null &&
            customResponse.validationErrors!.isNotEmpty) {
          customResponse.validationErrors?.forEach((each) {
            showOverlayNotification((context) {
              return notifcationCard(
                  context,
                  "Invalid Input",
                  each,
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ));
            }, duration: const Duration(seconds: 4));
          });
        } else{
          showOverlayNotification((context) {
            return notifcationCard(
                context,
                "Error Occurred",
                customResponse.message??'Please CHeck you internet connection',
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ));
          }, duration: const Duration(seconds: 4));
        }
      }
      else {
        final customResponse = CustomResponse.fromJson(response.data);
        User user = User.fromJson(customResponse.data);
        if (user.token != null) {
          StorageService().storeUserData(user);
          return true;
        } else {
          showOverlayNotification((context) {
            return notifcationCard(
                context,
                "An Error Occurred",
                "Login Failed please retry",
                const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                ));
          }, duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      showOverlayNotification((context) {
        return notifcationCard(
            context,
            "An Error Occurred",
            "Please check you network connection",
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
            ));
      }, duration: const Duration(seconds: 4));
    }

    return false;
  }
}
