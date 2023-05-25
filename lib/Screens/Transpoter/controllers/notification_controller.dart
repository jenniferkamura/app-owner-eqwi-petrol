import 'package:get/get.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/delete_date_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/delete_notification_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/logout_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/not_availble_dates_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/notifications_list_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/models/today_route_orders_model.dart';
import 'package:owner_eqwi_petrol/Screens/Transpoter/transport_web_services/transport_web_services.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  RxInt currentPage = 1.obs;

  var loadMoreData = false.obs;
  Future<bool> loadMore(String userToken) async {
    currentPage.value = currentPage.value + 1;
    loadMoreData.value = true;
    await transporterNotificationsFun(userToken,currentPage.toString());
    loadMoreData.value = false;
    return true;
  }

  /// pickUp orders data
  initStateGetNotifications(String userToken, String page) {
    transporterNotificationsFun(userToken, page,isLoad: true);
  }
  Rx<NotificationsListModel> getNotifications =
      NotificationsListModel(totalRecordsCount: 0, result: [], pagesCount: 0)
          .obs;
  var isGetNotificationLoad = false.obs;
  transporterNotificationsFun(String userToken, page, {bool isLoad = true}) async {
    if(isLoad){
      isGetNotificationLoad(true);
    }
    getNotifications.value =
    await TransportWebServices().getNotificationsApis(userToken, page);
    isGetNotificationLoad(false);
  }
  NotificationsListModel get getNotificationFinalData => getNotifications.value;



  ///delete patient
  Rx<DeleteNotificationModel> deleteNotification =
      DeleteNotificationModel(status: '',message: '',data: false)
          .obs;
  var isNotificationDeleteLoad = false.obs;

  deleteNotificationFun(String userToken,notificationId) async {
    isNotificationDeleteLoad(true);
    deleteNotification.value =
    await TransportWebServices().deleteNotification(userToken,notificationId);
    isNotificationDeleteLoad(false);
  }
  DeleteNotificationModel get deleteNotificationFinalData => deleteNotification.value;




  Rx<LogOutModel> logOutValue =
      LogOutModel(status: '',message: '',data: false)
          .obs;
  var logOutLoad = false.obs;
  logOutFun(String userToken) async {
    logOutLoad(true);
    logOutValue.value =
    await TransportWebServices().transporterLogoutApi(userToken);
    logOutLoad(false);
  }
  LogOutModel get logOutFinalData => logOutValue.value;


  ///delete patient
  Rx<DeleteNotificationModel> deleteAllNotification =
      DeleteNotificationModel(status: '',message: '',data: false)
          .obs;
  var isNotificationDeleteAllLoad = false.obs;

  deleteAllNotificationFun(String userToken) async {
    isNotificationDeleteAllLoad(true);
    deleteAllNotification.value =
    await TransportWebServices().deleteAllNotification(userToken);
    isNotificationDeleteAllLoad(false);
  }
  DeleteNotificationModel get deleteAllNotificationFinalData => deleteAllNotification.value;
  ///dates
  Rx<NotAvailbleDatesListModel> notADates = NotAvailbleDatesListModel( pagesCount: 0, result: [], totalRecordsCount: 0).obs;
  var isDatesLoading = false.obs;
  getAddsFun(String userToken) async {
    isDatesLoading(true);
    notADates.value = await TransportWebServices().notAvailableDatesApiCall(userToken);
    isDatesLoading(false);
  }
  NotAvailbleDatesListModel get addsFinalData => notADates.value;


  ///delete dates
  Rx<DeleteNotAvailableDates> deleteDates =
      DeleteNotAvailableDates(status: '',message: '')
          .obs;
  var isDatesDeleteLoad = false.obs;

  deleteDatesFun(String userToken,dateId) async {
    isDatesDeleteLoad(true);
    deleteDates.value =
    await TransportWebServices().deleteAvailableDatesApiCall(userToken,dateId);
    isDatesDeleteLoad(false);
  }
  DeleteNotAvailableDates get deleteDatesFinalData => deleteDates.value;


  ///today route plan
  Rx<TodayOrdersModelModel> todayRoutePlanData = TodayOrdersModelModel(status: '',message: '',data: []).obs;
  var isTodayRouteLoad = false.obs;
  todayRoutePlanFun(String userToken) async {
    isTodayRouteLoad(true);

    todayRoutePlanData.value =
    await TransportWebServices().todayRoutePlanApiCall(userToken);
    isTodayRouteLoad(false);
  }
  TodayOrdersModelModel get todayRoutePlanFinalData => todayRoutePlanData.value;

}