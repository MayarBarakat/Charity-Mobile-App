import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      //TODO add LOGIN SCREEN
      navigateAndFinish(context, null);
    }
  });
}

String token = '';