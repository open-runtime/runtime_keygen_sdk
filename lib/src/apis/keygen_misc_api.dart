import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';

/// Miscellaneous actions.
class KeygenMiscApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenMiscApi(this.client);

  /// Retrieves the details of the currently authenticated bearer i.e. the
  /// resource who the current API token belongs to using
  /// the [token].
  ///
  /// Returns the [User] who the current API token belongs to.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/profiles/
  Future<User> whoAmI({
    required Token token,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    ProfilesApi profilesApi = ProfilesApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveProfileResponse? resp = await profilesApi.retrieveProfile(client.accountId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveProfile returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Requests a password reset for a user using
  /// the [email] of the user.
  ///
  /// Returns `true` is successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/passwords/
  Future<bool> forgotPassword({
    required String email,
    bool deliver = true,
  }) async {

    //
    // no authentication
    //

    PasswordsApi passwordsApi = PasswordsApi(ApiClient());

    ForgotPasswordRequest forgotPasswordRequest = ForgotPasswordRequest(
      meta: ForgotPasswordRequestMeta(
        email: email,
        deliver: deliver,
      ),
    );

    try {

      await passwordsApi.forgotPassword(client.accountId, forgotPasswordRequest);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
