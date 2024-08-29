
/// Class containing account information to be used by the various APIs.
///
/// Create an instance of this class, and use it like this:
///
///     KeygenClient client = KeygenClient('<accountId>');
///
///     KeygenLicensesApi licensesApi = KeygenLicensesApi(client);
///
///     KeygenLicense? license = await licensesApi.createLicense(
///         productToken: productToken,
///         policyId: policyId,
///         userId: userId
///     );
class KeygenClient {

  /// The Keygen account id
  /// Embedding account, product and policy IDs directly into your product i.e. client-side code is perfectly safe.
  ///
  /// https://keygen.sh/docs/api/security/#security-public-tokens
  final String accountId;

  KeygenClient(this.accountId);
}
