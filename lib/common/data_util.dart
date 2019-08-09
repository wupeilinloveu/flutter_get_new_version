import 'package:flustars/flustars.dart';
import 'package:flutter_get_new_version/common/constants.dart';

class DataUtil {
  static saveCurrentTimeMillis(int timeStart) async {
    await SpUtil.getInstance();
    SpUtil.putInt(Constants.timeStart, timeStart);
  }
}
