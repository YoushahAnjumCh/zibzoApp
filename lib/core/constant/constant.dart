import 'package:zibzo_app/core/failure/failure.dart';

String getFailureMessage(Failure failure) {
  final statusCode = failure.statusCode;
  switch (statusCode) {
    case 200:
      return "Success";
    case 201:
      return "Created";
    case 204:
      return "No Content";
    case 400:
      return "Bad Request:";
    case 401:
      return "Unauthorized: ";
    case 403:
      return "Forbidden: ";
    case 404:
      return "Not Found: ";
    case 500:
      return "Internal Server Error: ";
    default:
      return "Unknown Error: ";
  }
}
