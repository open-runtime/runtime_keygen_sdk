import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


// String basicPolicyName = 'BasicPolicy';
// String proPolicyName = 'ProPolicy';
// String productName = 'Product1';
String firstNameJohn = 'John';
String firstNameBob = 'Bob';
// String userLastNameJohnDoe = 'Doe';
String emailJohnDoe = 'john@doe.com';
String passwordJohnDoe = 'secret5';
String newPasswordJohnDoe = 'secret6';

Duration wait = Duration(seconds: 1);


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

      await Future.delayed(wait);

    });

    tearDownAll(() async {

      await Future.delayed(wait);

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

      await Future.delayed(wait);

    });

    tearDown(() async {

      await Future.delayed(wait);

      bool valid = await usersApi.deleteUser(
        token: adminToken,
        user: user,
      );

      expect(valid, true);

    });

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

      await Future.delayed(wait);

      expect(user2.attributes.firstName, firstNameJohn);

      await usersApi.updateUser(
        token: adminToken,
        user: user2,
        firstName: firstNameBob,
      );

      await Future.delayed(wait);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      expect(user2.attributes.firstName, firstNameBob);

    });

    test('list users', () async {

      List<User> users = await usersApi.listUsers(
        token: adminToken,
      );

      expect(users.length, 1);
      expect(users[0].id, user.id);

    });

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

    test('update password as user', () async {

      Token userToken = await usersApi.createUserToken(
        token: adminToken,
        user: user,
      );

      await Future.delayed(wait);

      try {

        await usersApi.updateUserPassword(
          token: userToken,
          user: user,
          currentPassword: passwordJohnDoe,
          newPassword: newPasswordJohnDoe,
        );

        await Future.delayed(wait);

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

    //
    // may not write a test for forgotPassword because this requires an email
    // account to receive email
    //
    // test('reset password', () async {
    //
    //   usersApi.resetUserPassword(user: user, passwordResetToken: passwordResetToken, newPassword: newPassword)
    //
    // });

    test('ban user', () async {

      User user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      await Future.delayed(wait);

      expect(user2.attributes.status, UserAttributesStatusEnum.ACTIVE);

      await usersApi.banUser(
        token: adminToken,
        user: user2,
      );

      await Future.delayed(wait);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      await Future.delayed(wait);

      expect(user2.attributes.status, UserAttributesStatusEnum.BANNED);

      await usersApi.unbanUser(
        token: adminToken,
        user: user2,
      );

      await Future.delayed(wait);

      user2 = await usersApi.retrieveUser(
        token: adminToken,
        userEmail: emailJohnDoe,
      );

      expect(user2.attributes.status, UserAttributesStatusEnum.ACTIVE);

    });
    
    test('create user token', () async {

      Token userToken = await usersApi.createUserToken(
        token: adminToken,
        user: user,
      );

      await Future.delayed(wait);

      expect(userToken.attributes.token, startsWith('user-'));

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: userToken,
      );

    });

  });
}
