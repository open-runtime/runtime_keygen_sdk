import 'package:dotenv/dotenv.dart';
import 'package:runtime_keygen_openapi/api.dart';
import 'package:runtime_keygen_sdk/runtime_keygen_sdk.dart';
import 'package:test/test.dart';


const String firstNameJohn = 'John';
const String firstNameBob = 'Bob';
const String emailJohnDoe = 'john@doe.com';
const String passwordJohnDoe = 'secret5';
const String newPasswordJohnDoe = 'secret6';

// Why are there so many calls to `await Future.delayed(wait);` in the tests?
// See Tests section of README
Duration rateLimitDelay = Duration(seconds: 1);


// Users represent an identity for an end-user, or licensee, of your software.
//
// See the README for more information about users and how to use them.
//
// https://keygen.sh/docs/api/users/
void main() {

  group('Keygen User Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenUsersApi usersApi;

    late Token adminToken;
    late User user;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      usersApi = KeygenUsersApi(client);

      adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDownAll(() async {

      await Future.delayed(rateLimitDelay);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

      user = await usersApi.createUser(
        token: adminToken,
        firstName: firstNameJohn,
        email: emailJohnDoe,
        password: passwordJohnDoe,
      );

      await Future.delayed(rateLimitDelay);

    });

    tearDown(() async {

      await Future.delayed(rateLimitDelay);

      bool valid = await usersApi.deleteUser(
        token: adminToken,
        user: user,
      );

      expect(valid, true);

    });

    // Updates the specified user resource by setting the values of the
    // parameters passed.
    //
    // https://keygen.sh/docs/api/users/#users-update
    test('update user', () async {

      //
      // first verify that user has firstNameJohn
      // then change user name
      // then verify that user now has firstNameBob
      //

      User user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      await Future.delayed(rateLimitDelay);

      expect(user2.attributes.firstName, firstNameJohn);

      await usersApi.updateUser(
        token: adminToken,
        user: user2,
        firstName: firstNameBob,
      );

      await Future.delayed(rateLimitDelay);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      expect(user2.attributes.firstName, firstNameBob);

    });

    // Returns a list of users.
    //
    // https://keygen.sh/docs/api/users/#users-list
    test('list users', () async {

      List<User> users = await usersApi.listUsers(
        token: adminToken,
      );

      expect(users.length, 1);
      expect(users[0].id, user.id);

    });

    // Updates the user's password.
    //
    // https://keygen.sh/docs/api/users/#users-actions-update-password
    test('update password as admin', () async {

      try {

        await usersApi.updateUserPassword(
          token: adminToken,
          user: user,
          currentPassword: passwordJohnDoe,
          newPassword: newPasswordJohnDoe,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.e?.code, 403);
      }

    });

    // Updates the user's password.
    //
    // https://keygen.sh/docs/api/users/#users-actions-update-password
    test('update password as user', () async {

      Token userToken = await usersApi.createUserToken(
        token: adminToken,
        user: user,
      );

      await Future.delayed(rateLimitDelay);

      try {

        await usersApi.updateUserPassword(
          token: userToken,
          user: user,
          currentPassword: passwordJohnDoe,
          newPassword: newPasswordJohnDoe,
        );

        await Future.delayed(rateLimitDelay);

        //
        // cannot get new password
        // just test that actions succeeds and does not throw
        //

      } finally {

        await tokensApi.revokeToken(
          token: adminToken,
          tokenToBeRevoked: userToken,
        );
      }

    });

    // may not write a test for forgotPassword because this requires an email
    // account to receive email
    //
    // test('reset password', () async {
    //
    //   usersApi.resetUserPassword(user: user, passwordResetToken: passwordResetToken, newPassword: newPassword)
    //
    // });

    // Bans a user.
    //
    // https://keygen.sh/docs/api/users/#users-actions-ban
    test('ban user', () async {

      User user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      await Future.delayed(rateLimitDelay);

      expect(user2.attributes.status, UserAttributesStatusEnum.ACTIVE);

      await usersApi.banUser(
        token: adminToken,
        user: user2,
      );

      await Future.delayed(rateLimitDelay);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      await Future.delayed(rateLimitDelay);

      expect(user2.attributes.status, UserAttributesStatusEnum.BANNED);

      await usersApi.unbanUser(
        token: adminToken,
        user: user2,
      );

      await Future.delayed(rateLimitDelay);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      expect(user2.attributes.status, UserAttributesStatusEnum.ACTIVE);

    });

    // Generates a new user token resource.
    //
    // https://keygen.sh/docs/api/users/#users-tokens
    test('create user token', () async {

      Token userToken = await usersApi.createUserToken(
        token: adminToken,
        user: user,
      );

      await Future.delayed(rateLimitDelay);

      expect(userToken.attributes.token, startsWith('user-'));

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: userToken,
      );

    });

  });
}
