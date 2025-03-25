part of affogato.site;

class MailAPI {
  static const String apiName = 'mail_api';
  static const String apiHost = 'apis.obsivision.com';

  static final mailSubscribePost = MailSubscribePostEndpoint();
  static final mailSubscribeEarlyAccess = MailSubscribeEarlyAccessEndpoint();
}

class MailSubscribePostEndpoint {
  Future<http.Response> post({
    required ({
      String postId,
    }) queryParameters,
    required ({
      String emailAddress,
    }) bodyParameters,
  }) async {
    return await http.post(
      Uri.https(
        'apis.obsivision.com',
        'mail/subscribe/post',
        {
          'postId': queryParameters.postId,
        },
      ),
      body: jsonEncode({
        'emailAddress': bodyParameters.emailAddress,
      }),
    );
  }
}

class MailSubscribeEarlyAccessEndpoint {
  Future<http.Response> post({
    required String auth,
    required ({
      String productId,
    }) queryParameters,
  }) async {
    return await http.post(
      headers: {'Authorization': 'Bearer $auth'},
      Uri.https(
        'apis.obsivision.com',
        'mail/subscribe/early-access',
        {
          'productId': queryParameters.productId,
        },
      ),
      body: jsonEncode({}),
    );
  }
}
