import 'package:runtime_keygen_openapi/api.dart';

/// Thrown by Keygen actions when there is an error.
class KeygenError {

  /// If an exception from OpenAPI was thrown, then this is the underlying exception from OpenAPI.
  ApiException? e;

  /// If OpenAPI returned null, then this is the message
  String? msg;

  KeygenError(this.e);

  KeygenError.fromString(this.msg);

  @override
  String toString() {

    if (msg != null) {
      return msg!;
    }

    if (e != null) {
      return e.toString();
    }

    return 'invalid KeygenError';
  }
}
