import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';

/// Keygen authenticates your API requests using tokens.
///
/// https://keygen.sh/docs/api/tokens/
class KeygenTokensApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenTokensApi(this.client);

  /// Generates a new token resource for a user, using the user's [email] and
  /// [password].
  ///
  /// Used for both regular user tokens and admin tokens.
  ///
  /// Returns the [KeygenToken] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/tokens/#tokens-generate
  Future<Token> createToken({
    required String email,
    required String password,
  }) async {

    TokensApi tokensApi = TokensApi(
      ApiClient(
        authentication: HttpBasicAuth(
          username: email,
          password: password,
        ),
      ),
    );

    try {

      GenerateTokenResponse? resp = await tokensApi.generateToken(client.accountId);

      if (resp == null) {
        throw KeygenError.fromString('generateToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing [tokenId] using
  /// the [token] with privileges to view the resource.
  ///
  /// Returns the [KeygenToken] that was retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/tokens/#tokens-retrieve
  Future<Token> retrieveToken({
    required Token token,
    required String tokenToRetrieveId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    TokensApi tokensApi = TokensApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveTokenResponse? resp = await tokensApi.retrieveToken(client.accountId, tokenToRetrieveId);

      if (resp == null) {
        throw KeygenError.fromString('retrieveToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Regenerates an existing [tokenToRegenerateId] resource using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the [KeygenToken] that was regenerated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/tokens/#tokens-regenerate
  Future<Token> regenerateToken({
    required Token token,
    required String tokenToRegenerateId,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    TokensApi tokensApi = TokensApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RegenerateTokenResponse? resp = await tokensApi.regenerateToken(client.accountId, tokenToRegenerateId);

      if (resp == null) {
        throw KeygenError.fromString('regenerateToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently revokes a [tokenToBeRevoked] using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/tokens/#tokens-revoke
  Future<bool> revokeToken({
    required Token token,
    required Token tokenToBeRevoked,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    TokensApi tokensApi = TokensApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await tokensApi.revokeToken(client.accountId, tokenToBeRevoked.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of tokens using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/tokens/#tokens-list
  Future<List<Token>> listTokens({
    required Token token,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    TokensApi tokensApi = TokensApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListTokensResponse? resp = await tokensApi.listTokens(client.accountId);

      if (resp == null) {
        throw KeygenError.fromString('listTokens returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
