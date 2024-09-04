import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';

/// Keygen provides identity management for your customers,
/// which allows you to authenticate them using an email/password by creating a token.
///
/// https://keygen.sh/docs/api/users/
class KeygenUsersApi {

  /// The Keygen client for a specific account.
  final KeygenClient client;

  KeygenUsersApi(this.client);

  /// Creates a new user resource using
  /// the [token] that is a product token,
  /// the [firstName] of the user,
  /// the [lastName] of the user,
  /// the unique [email] of the user, and
  /// the [password] for the user.
  ///
  /// Returns the [User] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-create
  Future<User> createUser({
    required Token token,
    String? firstName,
    String? lastName,
    required String email,
    String? password,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    CreateUserRequest createUserRequest = CreateUserRequest(
      data: CreateUserRequestData(
        type: CreateUserRequestDataTypeEnum.users,
        attributes: CreateUserRequestDataAttributes(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          metadata: metadata,
        ),
      ),
    );

    try {

      CreateUserResponse? resp = await usersApi.createUser(client.accountId, createUserRequest);

      if (resp == null) {
        throw KeygenError.fromString('createUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Permanently deletes a [user] using
  /// the [token] that has admin privileges.
  ///
  /// Returns `true` if successful.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-delete
  Future<bool> deleteUser({
    required Token token,
    required User user,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      await usersApi.deleteUser(client.accountId, user.id);

      return true;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Retrieves the details of an existing user using
  /// the [token] that has privileges to manage the resource, and
  /// the [userEmail] of the user to be retrieved.
  ///
  /// Returns the [User] that was retrieved.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-retrieve
  Future<User> retrieveUser({
    required Token token,
    required String userEmail,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      RetrieveUserResponse? resp = await usersApi.retrieveUser(client.accountId, userEmail);

      if (resp == null) {
        throw KeygenError.fromString('retrieveUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the [user]'s password using
  /// the [token] that has privileges to manage the resource,
  /// the [currentPassword] for the user, and
  /// the [newPassword] for the user.
  ///
  /// Returns the [User] whose password was updated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-actions-update-password
  Future<User> updateUserPassword({
    required Token token,
    required User user,
    required String currentPassword,
    required String newPassword,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    UpdateUserPasswordRequest updateUserPasswordRequest = UpdateUserPasswordRequest(
      meta: UpdateUserPasswordRequestMeta(
        oldPassword: currentPassword,
        newPassword: newPassword,
      ),
    );

    try {

      UpdateUserPasswordResponse? resp = await usersApi.updateUserPassword(client.accountId, user.id, updateUserPasswordRequest);

      if (resp == null) {
        throw KeygenError.fromString('updateUserPassword returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Fulfills a [user]'s password reset request using
  /// the [passwordResetToken] emailed to the user, and
  /// the [newPassword] for the user.
  ///
  /// Returns the [KeygenUser] whose password ws reset.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-actions-reset-password
  Future<User> resetUserPassword({
    required User user,
    required Token passwordResetToken,
    required String newPassword,
  }) async {

    //
    // no authentication
    //

    UsersApi usersApi = UsersApi(ApiClient());

    ResetUserPasswordRequest resetUserPasswordRequest = ResetUserPasswordRequest(
      meta: ResetUserPasswordRequestMeta(
        passwordResetToken: passwordResetToken.id,
        newPassword: newPassword,
      ),
    );

    try {

      ResetUserPasswordResponse? resp = await usersApi.resetUserPassword(client.accountId, user.id, resetUserPasswordRequest);

      if (resp == null) {
        throw KeygenError.fromString('resetUserPassword returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Bans a [user] using
  /// the [token] with admin privileges or a product token.
  ///
  /// Returns the banned [User].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-actions-ban
  Future<User> banUser({
    required Token token,
    required User user,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      BanUserResponse? resp = await usersApi.banUser(client.accountId, user.id);

      if (resp == null) {
        throw KeygenError.fromString('banUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Unbans a [user] using
  /// the [token] with admin privileges or a product token.
  ///
  /// Returns the unbanned [KeygenUser].
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-actions-unban
  Future<User> unbanUser({
    required Token token,
    required User user,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      UnbanUserResponse? resp = await usersApi.unbanUser(client.accountId, user.id);

      if (resp == null) {
        throw KeygenError.fromString('unbanUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Generates a new [user] token resource using
  /// the [token] with admin privileges, or a product.
  ///
  /// Returns the [Token] that was created.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-tokens
  Future<Token> createUserToken({
    required Token token,
    required User user,
    String? name,
    DateTime? expiry,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    GenerateUserTokenRequest generateUserTokenRequest = GenerateUserTokenRequest(
      data: GenerateProductTokenRequestData(
        type: GenerateProductTokenRequestDataTypeEnum.tokens,
        attributes: GenerateProductTokenRequestDataAttributes(
          name: name,
          expiry: expiry,
        ),
      ),
    );

    try {

      GenerateUserTokenResponse? resp = await usersApi.generateUserToken(client.accountId, user.id,
        generateUserTokenRequest: generateUserTokenRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('generateUserToken returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Updates the specified [user] resource by setting the values of the
  /// parameters passed using
  /// the [token] with privileges to manage the resource.
  ///
  /// Returns the [KeygenUser] that was updated.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-update
  Future<User> updateUser({
    required Token token,
    required User user,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    UpdateUserRequest updateUserRequest = UpdateUserRequest(
      data: UpdateUserRequestData(
        type: UpdateUserRequestDataTypeEnum.users,
        attributes: UpdateUserRequestDataAttributes(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          metadata: metadata,
        ),
      ),
    );

    try {

      UpdateUserResponse? resp = await usersApi.updateUser(client.accountId, user.id,
        updateUserRequest: updateUserRequest,
      );

      if (resp == null) {
        throw KeygenError.fromString('updateUser returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }

  /// Returns a list of users using
  /// the [token] with privileges to view the resources.
  ///
  /// Throws [KeygenError] on error.
  ///
  /// https://keygen.sh/docs/api/users/#users-list
  Future<List<User>> listUsers({
    required Token token,
    Map<String, int>? page,
    int? limit,
    String? status,
    bool? assigned,
    String? product,
    String? group,
    List<String>? roles,
    Map<String, String>? metadata,
  }) async {

    // cannot do HttpBearerAuth(accessToken: xxx)
    HttpBearerAuth bearer = HttpBearerAuth();
    bearer.accessToken = token.attributes.token;

    UsersApi usersApi = UsersApi(
      ApiClient(
        authentication: bearer,
      ),
    );

    try {

      ListUsersResponse? resp = await usersApi.listUsers(client.accountId,
        page: page,
        limit: limit,
        status: status,
        assigned: assigned,
        product: product,
        group: group,
        roles: roles,
        metadata: metadata,
      );

      if (resp == null) {
        throw KeygenError.fromString('listUsers returned null');
      }

      return resp.data;

    } on ApiException catch (e) {
      throw KeygenError(e);
    }
  }
}
