import 'dart:convert';

List<AppVersion> appVersionFromJson(String str) =>
    List<AppVersion>.from(json.decode(str).map((x) => AppVersion.fromJson(x)));

class AppVersion {
  AppVersion({
    required this.androidVersion,
    required this.iosVersion
  });

  String androidVersion;
  String iosVersion;


  factory AppVersion.fromJson(List<dynamic> json) {
    late String androidVersion;
    late String iosVersion;

    for (var element in json) {
      if (element is Map<String, dynamic> && element['name']=='sl-ios') {
        iosVersion = element['version'];
      }
      if (element is Map<String, dynamic> && element['name']=='sl-android') {
        androidVersion = element['version'];
      }

    }

    return AppVersion(
      iosVersion: iosVersion,
      androidVersion: androidVersion
    );
  }


}
