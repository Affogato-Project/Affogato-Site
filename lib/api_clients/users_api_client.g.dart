part of affogato.site;

class UsersAPI {
  static const String apiName = 'users_api';
  static const String apiHost = 'apis.obsivision.com';

  static final usersAccountCreate = UsersAccountCreateEndpoint();
}

class UsersAccountCreateEndpoint {
  Future<http.Response> post({
    required ({
      String authorization,
    }) queryParameters,
  }) async {
    return await http.post(
      headers: {
        'Authorization': 'Bearer ${queryParameters.authorization}',
      },
      Uri.https(
        'apis.obsivision.com',
        'users/account/create',
      ),
    );
  }
}
