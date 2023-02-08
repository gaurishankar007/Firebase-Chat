import 'package:intl/intl.dart';

String getTime(DateTime datetime) {
  var now = DateTime.now();
  var difference = now.difference(datetime);
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes} m ago";
  }

  if (difference.inHours < 24) {
    return "${difference.inHours} h ago";
  } else if (difference.inDays < 30) {
    return "${difference.inDays} d ago";
  } else if (difference.inDays < 365) {
    final dtFormat = DateFormat('MM-dd');
    return dtFormat.format(datetime);
  } else {
    final dtFormat = DateFormat('yyyy-MM-dd');
    var str = dtFormat.format(datetime);
    return str;
  }
}
