import '../cupertino_native.dart';

/// Shows a native iOS alert.
///
/// Returns a [CNAlertResult] containing the index of the tapped action and the
/// values of any text fields, or `null` if the alert was dismissed without tapping
/// an action (e.g. if the platform does not support it).
Future<CNAlertResult?> showCNAlert({
  String? title,
  String? message,
  List<CNAlertAction> actions = const [],
  List<CNAlertTextField> textFields = const [],
}) {
  return CupertinoNativePlatform.instance.showAlert(
    title: title,
    message: message,
    actions: actions,
    textFields: textFields,
  );
}
