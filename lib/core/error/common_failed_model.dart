import 'dart:developer';

import 'package:dio/dio.dart';

abstract class CommonFailedModel {
  String? failureMessage;
  String? failureMessageTitle;
  final DioException modelException;

  CommonFailedModel({
    required this.modelException,
    this.failureMessageTitle,
    required this.failureMessage,
  });
}

class DioFailure extends CommonFailedModel {
  DioFailure({
    super.failureMessage,
    super.failureMessageTitle,
    required super.modelException,
  });

  static String formatServerErrors(dynamic data) {
    if (data is List) {
      final items = data.whereType<String>().toList();
      if (items.isNotEmpty) return items.map((e) => '• $e').join('\n');
    }
    if (data is Map) {
      final List<String> lines = [];
      data.forEach((key, value) {
        if (value is List) {
          for (final v in value) {
            if (v is String) lines.add('• $v');
          }
        } else if (value is String) {
          lines.add('• $value');
        }
      });
      if (lines.isNotEmpty) return lines.join('\n');
    }
    return data?.toString() ?? '';
  }

  factory DioFailure.fromDioException({
    DioExceptionType? dioType,
    DioException? exception,
  }) {
    switch (dioType!) {
      case DioExceptionType.connectionTimeout:
        return DioFailure(
          failureMessageTitle: "Connection Timeout",
          failureMessage:
              'Connection to the server timed out. Please check your internet connection and try again.',
          modelException: exception!,
        );
      case DioExceptionType.sendTimeout:
        log("DioExceptionType.sendTimeout");
        return DioFailure(
          failureMessageTitle: "Send Timeout",
          failureMessage:
              'Taking too long to send data to the server. Please try again.',
          modelException: exception!,
        );
      case DioExceptionType.receiveTimeout:
        return DioFailure(
          failureMessageTitle: "Receive Timeout",
          failureMessage:
              'Taking too long to receive data from the server. Please try again.',
          modelException: exception!,
        );
      case DioExceptionType.badCertificate:
        return DioFailure(
          failureMessageTitle: "Security Error",
          failureMessage:
              'Security certificate verification failed. The connection might be insecure.',
          modelException: exception!,
        );
      case DioExceptionType.badResponse:
        log("DioExceptionType.badResponse");

        return DioFailure(
          failureMessageTitle: "Failed",
          failureMessage:
              exception?.response?.data["message"] ??
              "An error occurred with the server.",
          modelException: exception!,
        );
      case DioExceptionType.cancel:
        return DioFailure(
          failureMessageTitle: "Request Cancelled",
          failureMessage: 'The request to the server was cancelled.',
          modelException: exception!,
        );

      case DioExceptionType.connectionError:
        return DioFailure(
          failureMessageTitle: "No Internet Connection",
          failureMessage:
              'Unable to connect to the server. Please check your network and try again.',
          modelException: exception!,
        );

      case DioExceptionType.unknown:
        return DioFailure(
          failureMessageTitle: "Unexpected Error",
          failureMessage:
              'An unexpected error occurred. Please try again later.',
          modelException: exception!,
        );
      case DioExceptionType.transformTimeout:
        return DioFailure(
          failureMessageTitle: "Data Processing Error",
          failureMessage:
              'Taking too long to process the data. Please try again.',
          modelException: exception!,
        );
    }
  }
}
