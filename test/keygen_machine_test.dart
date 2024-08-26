import 'package:dotenv/dotenv.dart';
import 'package:keygen/keygen.dart';
import 'package:machineid/machineid.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';


String basicPolicyName = 'Basic Policy';
// String proPolicyName = 'Pro Policy';
String productName = 'Product 1';
// String userFirstNameJohnDoe = 'John';
// String userLastNameJohnDoe = 'Doe';
String emailJohnDoe = 'john@doe.com';
// String userPasswordJohnDoe = 'secret5';
// String userNewPasswordJohnDoe = 'secret6';
String machineName = 'Machine Name';
String newMachineName = 'Machine Name 2';

Duration wait = Duration(seconds: 1);


void main() {

  group('Keygen Machine Test', () {

    late String accountId;
    late String adminEmail;
    late String adminPassword;

    late KeygenClient client;

    late KeygenTokensApi tokensApi;
    late KeygenProductsApi productsApi;
    late KeygenUsersApi usersApi;
    late KeygenPoliciesApi policiesApi;
    late KeygenLicensesApi licensesApi;
    late KeygenMachinesApi machinesApi;
    late KeygenMiscApi miscApi;

    late Token adminToken;
    late Product product;
    late Token productToken;
    late User user;
    late Policy policy;
    late License license;
    late Machine machine;

    setUpAll(() async {

      DotEnv env = DotEnv(includePlatformEnvironment: true)
        ..load();

      accountId = env['KEYGEN_ACCOUNTID']!;
      adminEmail = env['KEYGEN_ADMIN_EMAIL']!;
      adminPassword = env['KEYGEN_ADMIN_PASSWORD']!;

      client = KeygenClient(accountId);
      tokensApi = KeygenTokensApi(client);
      productsApi = KeygenProductsApi(client);
      usersApi = KeygenUsersApi(client);
      policiesApi = KeygenPoliciesApi(client);
      licensesApi = KeygenLicensesApi(client);
      machinesApi = KeygenMachinesApi(client);
      miscApi = KeygenMiscApi(client);

      adminToken = await tokensApi.createToken(
        email: adminEmail,
        password: adminPassword,
      );

      await Future.delayed(wait);

      product = await productsApi.createProduct(
        token: adminToken,
        name: productName,
      );

      await Future.delayed(wait);

      productToken = await productsApi.createProductToken(
        token: adminToken,
        product: product,
      );

      await Future.delayed(wait);

      user = await usersApi.createUser(
        token: adminToken,
        email: emailJohnDoe,
      );

      await Future.delayed(wait);

      policy = await policiesApi.createPolicy(
        token: adminToken,
        product: product,
        name: basicPolicyName,
      );

      await Future.delayed(wait);

      license = await licensesApi.createLicense(
        token: adminToken,
        policy: policy,
        user: user,
      );

      await Future.delayed(wait);

    });

    tearDownAll(() async {

      await Future.delayed(wait);

      await licensesApi.deleteLicense(
        token: adminToken,
        license: license,
      );

      await Future.delayed(wait);

      await policiesApi.deletePolicy(
        token: adminToken,
        policy: policy,
      );

      await Future.delayed(wait);

      await usersApi.deleteUser(
        token: adminToken,
        user: user,
      );

      await Future.delayed(wait);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: productToken,
      );

      await Future.delayed(wait);

      await productsApi.deleteProduct(
        token: adminToken,
        product: product,
      );

      await Future.delayed(wait);

      await tokensApi.revokeToken(
        token: adminToken,
        tokenToBeRevoked: adminToken,
      );

    });

    setUp(() async {

      String fingerprint = await MachineID.machineid;

      machine = await machinesApi.activateMachine(
        token: adminToken,
        license: license,
        fingerprint: fingerprint,
        name: machineName,
      );

      await Future.delayed(wait);

    });

    tearDown(() async {

      await Future.delayed(wait);

      bool valid = await machinesApi.deactivateMachine(
        token: adminToken,
        machine: machine,
      );

      expect(valid, true);

    });

    test('update machine', () async {

      //
      // first verify that machine has machineName
      // then change machine name
      // then verify that machine now has newMachineName
      //

      Machine machine2 = await machinesApi.retrieveMachine(
        token: adminToken,
        machineId: machine.id,
      );

      await Future.delayed(wait);

      expect(machine2.attributes.name, machineName);

      await machinesApi.updateMachine(
        token: adminToken,
        machine: machine2,
        name: newMachineName,
      );

      await Future.delayed(wait);

      machine2 = await machinesApi.retrieveMachine(
        token: adminToken,
        machineId: machine.id,
      );

      expect(machine2.attributes.name, newMachineName);

    });

    test('list machines', () async {

      List<Machine> machines = await machinesApi.listMachines(
        token: adminToken,
      );

      expect(machines.length, 1);
      expect(machines[0].id, machine.id);

    });

    test('ping heartbeat', () async {

      Machine machine2 = await machinesApi.retrieveMachine(
        token: adminToken,
        machineId: machine.id,
      );

      await Future.delayed(wait);

      expect(machine2.attributes.heartbeatStatus, MachineAttributesHeartbeatStatusEnum.NOT_STARTED);

      await machinesApi.pingHeartbeat(
        token: adminToken,
        machine: machine2,
      );

      await Future.delayed(wait);

      machine2 = await machinesApi.retrieveMachine(
        token: adminToken,
        machineId: machine.id,
      );

      await Future.delayed(wait);

      expect(machine2.attributes.heartbeatStatus, MachineAttributesHeartbeatStatusEnum.ALIVE);

      await machinesApi.resetHeartbeat(
        token: adminToken,
        machine: machine2,
      );

      await Future.delayed(wait);

      machine2 = await machinesApi.retrieveMachine(
        token: adminToken,
        machineId: machine.id,
      );

      expect(machine2.attributes.heartbeatStatus, MachineAttributesHeartbeatStatusEnum.NOT_STARTED);

    });

    //
    // changeOwner is currently missing from keygen-openapi.yml
    //
    test('change owner', () async {

      User newOwner = await miscApi.whoAmI(
        token: adminToken,
      );

      await Future.delayed(wait);

      try {

        await machinesApi.changeOwner(
          token: adminToken,
          machine: machine,
          owner: newOwner,
        );

        fail('should have thrown');

      } on KeygenError catch (e) {

        expect(e.msg, isNotNull);
      }

    });

  });
}
