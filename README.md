Keygen package for Dart

Most actions in the [Keygen API](https://keygen.sh/docs/api/) are supported.


## dependencies

machineid package
openapi package


## Example

```
KeygenClient client = KeygenClient('<accountId>');

KeygenLicensesApi licensesApi = KeygenLicensesApi(client);

KeygenLicense? license = await licensesApi.createLicense(
    productToken: productToken,
    policyId: policyId,
    userId: userId
);
```

## Tests

Create a `.env` file and place it in the root of the package.

The `.env` file needs to contain the Keygen AccountID, Admin Email, and Admin Password, specified like this:
```
KEYGEN_ACCOUNTID=<accountid>
KEYGEN_ADMIN_EMAIL=<email>
KEYGEN_ADMIN_PASSWORD=<password>
```

Then you can run:
```
dart test
```

## Supported actions

| Token Actions    | Implemented | Tests |
|------------------|-------------|-------|
| createToken      | ✅           | ✅     |
| retrieveToken    | ✅           | ✅     |
| regenerateToken  | ✅           | ✅     |
| revokeToken      | ✅           | ✅     |
| listTokens       | ✅           | ✅     |

| Product Actions    | Implemented | Tests |
|--------------------|-------------|-------|
| createProduct      | ✅           | ✅     |
| retrieveProduct    | ✅           | ✅     |
| updateProduct      | ✅           | ✅     |
| deleteProduct      | ✅           | ✅     |
| listProducts       | ✅           | ✅     |
| createProductToken | ✅           | ✅     |

| Entitlement Actions | Implemented | Tests |
|---------------------|-------------|-------|
| createEntitlement   | ✅           | ✅     |
| retrieveEntitlement | ✅           | ✅     |
| updateEntitlement   | ✅           | ✅     |
| deleteEntitlement   | ✅           | ✅     |
| listEntitlements    | ✅           | ✅     |

| Policy Actions           | Implemented | Tests |
|--------------------------|-------------|-------|
| createPolicy             | ✅           | ✅     |
| retrievePolicy           | ✅           | ✅     |
| updatePolicy             | ✅           | ✅     |
| deletePolicy             | ✅           | ✅     |
| listPolicies             | ✅           | ✅     |
| attachPolicyEntitlements | ✅           | ✅     |
| detachPolicyEntitlements | ✅           | ✅     |
| listEntitlements         | ✅           | ✅     |

| User Actions         | Implemented | Tests |
|----------------------|-------------|-------|
| createUser           | ✅           | ✅     |
| retrieveUser         | ✅           | ✅     |
| updateUser           | ✅           | ✅     |
| deleteUser           | ✅           | ✅     |
| listUsers            | ✅           | ✅     |
| updatePassword       | ✅           | ✅     |
| resetPassword        | ✅           | 📧    |
| banUser              | ✅           | ✅     |
| unbanUser            | ✅           | ✅     |
| createUserToken      | ✅           | ✅     |
| changeGroup          | ❌           | ❌     |
| addSecondFactor      | ❌           | ❌     |
| retrieveSecondFactor | ❌           | ❌     |
| updateSecondFactor   | ❌           | ❌     |
| deleteSecondFactor   | ❌           | ❌     |
| listSecondFactors    | ❌           | ❌     |

| License Actions      | Implemented | Tests |
|----------------------|-------------|-------|
| createLicense        | ✅           | ✅     |
| retrieveLicense      | ✅           | ✅     |
| updateLicense        | ✅           | ✅     |
| deleteLicense        | ✅           | ✅     |
| listLicenses         | ✅           | ✅     |
| validateLicenseByID  | ✅           | ✅     |
| validateLicenseByKey | ✅           | ✅     |
| suspendLicense       | ✅           | ✅     |
| reinstateLicense     | ✅           | ✅     |
| renewLicense         | ✅           | ✅     |
| revokeLicense        | ✅           | ✅     |
| checkOutLicense      | ❌           | ❌     |
| checkInLicense       | ✅           | ✅     |
| incrementUsage       | ❌           | ❌     |
| decrementUsage       | ❌           | ❌     |
| resetUsage           | ❌           | ❌     |
| createLicenseToken   | ✅           | ✅     |
| attachUsers          | 🐛          | 🐛    |
| detachUsers          | 🐛          | 🐛    |
| listUsers            | 🐛          | 🐛    |
| attachEntitlements   | ✅           | ✅     |
| detachEntitlements   | ✅           | ✅     |
| listEntitlements     | ✅           | ✅     |
| changeLicensePolicy  | ✅           | ✅     |
| changeOwner          | ❌           | ❌     |
| changeGroup          | ❌           | ❌     |

| Machine Actions   | Implemented | Tests |
|-------------------|-------------|-------|
| activateMachine   | ✅           | ✅     |
| retrieveMachine   | ✅           | ✅     |
| updateMachine     | ✅           | ✅     |
| deactivateMachine | ✅           | ✅     |
| listAllMachines   | ✅           | ✅     |
| checkOutMachine   | ❌           | ❌     |
| pingHeartbeat     | ✅           | ✅     |
| resetHeartbeat    | ✅           | ✅     |
| changeOwner       | 🐛          | 🐛    |
| changeGroup       | ❌           | ❌     |

| Misc Actions   | Implemented | Tests |
|----------------|-------------|-------|
| whoAmI         | ✅           | ✅     |
| forgotPassword | ✅           | 📧    |

## Not supported

🐛 = bug in generated OpenAPI code
license attachUsers is missing from OpenAPI .yml file
license detachUsers is missing from OpenAPI .yml file
license listUsers is missing from OpenAPI .yml file
machine changeOwner is missing from OpenAPI .yml file

❌ = not planned to be supported

📧 = requires reading email

* Environments: not yet supported
* Components: not yet specified in OpenAPI spec file, not planned to be supported
* Processes: not planned to be supported
* Distribution: not planned to be supported


## modifications from OpenAPI generated code

OpenAPI defines some parameters as `Object? metadata`, but these have been modified to be `Map<String, String>? metadata`.

OpenAPI defines some parameters as `Object? page`, but these have been modified to be `Map<String, int>? page`.


## Separation of client / server

Keygen authenticates API requests using tokens.

There are the following kinds of tokens:
* Admin
* Product
* User
* License
* Machine

Admin and Product tokens should not be included in any client-facing code, as they offer full access to all of your
account's resources.

You can authenticate as one of your users or use a license token to perform client-side machine activations.

Admin and Product tokens should only be used server-side. 

User, License, and Machine tokens may be used client-side.















