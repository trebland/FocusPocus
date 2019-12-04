import 'package:flutter_test/flutter_test.dart';
import 'package:focus_pocus_mobile/HTTP_Calls.dart';

void main()
{
  group('Register Account', () {
    test('Register Account Post-Call works', () async {
      final registerTest = new MyRegisterAccount_Test();

      final String accountName = "FellaDyma";
      final String emailName = "Dyboasr@DyborMenasce.com";
      final String password = "123";

      RegisterAccountPost mPost = await registerTest.fetchPost(accountName, emailName, password);

      expect(mPost.username, accountName);
    });
    test('Register Account Post-Call fails', () async {
      final registerTest = new MyRegisterAccount_Test();

      RegisterAccountPost mPost = await registerTest.fetchPost("", "", "");

      expect(mPost, null);
    });
  });

  group('Login Account', () {
    test('Login Account Post-Call works', () async {
      final loginTest = new MyLogin_Test();

      final String accountName = "HarryJake";
      final String password = "123";

      LoginPost mPost = await loginTest.fetchPost(accountName, password);

      expect(mPost.username, accountName);
    });
    test('Login Account Post-Call fails', () async {
      final loginTest = new MyLogin_Test();

      LoginPost mPost = await loginTest.fetchPost("", "");

      expect(mPost, null);
    });
  });
}
