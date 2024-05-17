import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingWidget {
  static void show({required String message}) {
    EasyLoading.show(status: message);
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static void showSuccess({required String message}) {
    EasyLoading.showSuccess(message);
  }

  static void showError({required String message}) {
    EasyLoading.showError(message);
  }

  static void showInfo({required String message}) {
    EasyLoading.showInfo(message);
  }

  static void showProgress({required double progress, required String message}) {
    EasyLoading.showProgress(progress, status: message);
  }
}
