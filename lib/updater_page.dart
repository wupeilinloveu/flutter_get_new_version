import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get_new_version/common/data_util.dart';
import 'package:flutter_get_new_version/common/strings.dart';
import 'package:flutter_get_new_version/common/text_style.dart';
import 'package:package_info/package_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_get_new_version/common/constants.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdaterPage extends StatefulWidget {
  final Widget child;

  const UpdaterPage(this.child);

  @override
  UpdatePagerState createState() => UpdatePagerState();
}

class UpdatePagerState extends State<UpdaterPage> {
  var _serviceVersionCode,
      _serviceVersionName,
      _serviceVersionPlatform,
      _serviceVersionApp;

  @override
  void initState() {
    super.initState();
    //每次打开APP获取当前时间戳
    var timeEnd = DateTime.now().millisecondsSinceEpoch;
    //获取"Later"保存的时间戳
    var timeStart = SpUtil.getInt(Constants.timeStart);
    if (timeStart == 0) {
      //第一次打开APP时执行"版本更新"的网络请求
      _getNewVersionAPP();
    } else if (timeStart != 0 && timeEnd - timeStart >= 24 * 60 * 60 * 1000) {
      //如果新旧时间戳的差大于或等于一天，执行网络请求
      _getNewVersionAPP();
    }
  }

  //执行版本更新的网络请求
  _getNewVersionAPP() async {
    String url = "/appversions/latest"; //接口的URL，替换你的URL
    try {
      Response response = await Dio().get(url);
      if (response != null) {
        setState(() {
          var data = response.data;
          _serviceVersionCode = data["versionCode"].toString(); //版本号
          _serviceVersionName = data["versionName"].toString(); //版本名称
          _serviceVersionPlatform = data["versionPlatform"].toString(); //版本平台
          _serviceVersionApp = data["versionApp"].toString(); //下载的URL
          _checkVersionCode();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //检查版本更新的版本号
  _checkVersionCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String _currentVersionCode = packageInfo.version;
    int serviceVersionCode = int.parse(_serviceVersionCode); //String -> int
    int currentVersionCode = int.parse(_currentVersionCode); //String -> int
    if (serviceVersionCode > currentVersionCode) {
      _showNewVersionAppDialog(); //弹出对话框
    }
  }

  //弹出"版本更新"对话框
  Future<void> _showNewVersionAppDialog() async {
    if (_serviceVersionPlatform == "android") {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Row(
                children: <Widget>[
                  new Image.asset("images/ic_launcher_icon.png",
                      height: 35.0, width: 35.0),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
                      child: new Text(Strings.new_version_title,
                          style: dialogButtonTextStyle))
                ],
              ),
              content: new Text(Strings.new_version_dialog_content,
                  style: dialogTextStyle),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(Strings.new_version_button_later,
                      style: dialogButtonTextStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    var timeStart = DateTime.now().millisecondsSinceEpoch;
                    DataUtil.saveCurrentTimeMillis(timeStart); //保存当前的时间戳
                  },
                ),
                new FlatButton(
                  child: new Text(Strings.new_version_button_download,
                      style: dialogButtonTextStyle),
                  onPressed: () {
                    //https://play.google.com/store/apps/details?id=项目包名
                    launch(_serviceVersionApp); //到Google Play 官网下载
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      //iOS
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: new Row(
                children: <Widget>[
                  new Image.asset("images/ic_launcher_icon.png",
                      height: 35.0, width: 35.0),
                  new Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 10.0, 0.0),
                      child: new Text(Strings.new_version_title,
                          style: dialogButtonTextStyle))
                ],
              ),
              content: new Text(
                  "New version v$_serviceVersionName is available. " +
                      Strings.new_version_dialog_content,
                  style: dialogTextStyle),
              actions: <Widget>[
                new CupertinoDialogAction(
                  child: new Text(Strings.new_version_button_later,
                      style: dialogButtonTextStyle),
                  onPressed: () {
                    Navigator.of(context).pop();
                    var timeStart = DateTime.now().millisecondsSinceEpoch;
                    DataUtil.saveCurrentTimeMillis(timeStart); //保存当前的时间戳
                  },
                ),
                new CupertinoDialogAction(
                  child: new Text(Strings.new_version_button_download,
                      style: dialogButtonTextStyle),
                  onPressed: () {
                    //_serviceVersionApp="http://itunes.apple.com/cn/lookup?id=项目包名"
                    launch(_serviceVersionApp); //到APP store 官网下载
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
