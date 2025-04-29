import 'package:get/get.dart';
import 'package:sro/pages/account_details/account_details_binding.dart';
import 'package:sro/pages/account_details/account_details_page.dart';
import 'package:sro/pages/account_details/add.dart';
import 'package:sro/pages/change_password/change_password_binding.dart';
import 'package:sro/pages/change_password/change_password_page.dart';
import 'package:sro/pages/create_event/create_event.dart';
import 'package:sro/pages/dashboard/dashboard_binding.dart';
import 'package:sro/pages/dashboard/dashboard_page.dart';
import 'package:sro/pages/directions/directions_binding.dart';
import 'package:sro/pages/directions/directions_page.dart';
import 'package:sro/pages/edit_profile/edit_profile_binding.dart';
import 'package:sro/pages/event_chat/event_chat.dart';
import 'package:sro/pages/event_chat/event_chat_binding.dart';
import 'package:sro/pages/event_chat/event_details.dart';
import 'package:sro/pages/login/forgot_password.dart';
import 'package:sro/pages/login/login_binding.dart';
import 'package:sro/pages/login/login_page.dart';
import 'package:sro/pages/map/map_choose_location.dart';
import 'package:sro/pages/notifications_settings/notifications_settings_binding.dart';
import 'package:sro/pages/notifications_settings/notifications_settings_page.dart';
import 'package:sro/pages/register/add_students.dart';
import 'package:sro/pages/register/invite_coparent.dart';
import 'package:sro/pages/register/register_binding.dart';
import 'package:sro/pages/register/register_page.dart';
import 'package:sro/pages/school/school_binding.dart';
import 'package:sro/pages/school/search_school.dart';
import 'package:sro/pages/welcome/welcome_page.dart';
import 'package:sro/splash_screen.dart';

import '../pages/edit_profile/edit_profile_page.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPassword(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.school,
      page: () => const SearchSchool(),
      binding: SchoolBinding(),
    ),
    GetPage(
      name: AppRoutes.registerAddStudents,
      page: () => const AddStudent(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.inviteCo,
      page: () => const InviteCoparent(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
    ),
    GetPage(
      name: AppRoutes.eventChat,
      page: () => const EventChat(),
      binding: EventChatBinding(),
    ),
    GetPage(
      name: AppRoutes.addEvents,
      page: () => const CreateEvent(),
      binding: EventChatBinding(),
    ),
    GetPage(
      name: AppRoutes.eventDetails,
      page: () => const EventDetails(),
      binding: EventChatBinding(),
    ),
    GetPage(
      name: AppRoutes.mapChooser,
      page: () => const MapChooser(),
    ),
    GetPage(
      name: AppRoutes.accountDetails,
      page: () => const AccountDetailsPage(),
      binding: AccountDetailsdBinding(),
    ),
    GetPage(
        name: AppRoutes.editProfile,
        page: () => const EditProfilePage(),
        binding: EditProfileBinding()),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      binding: ChangePassworddBinding(),
    ),
    GetPage(
      name: AppRoutes.notificationsSettings,
      page: () => const NotificationsSettingsPage(),
      binding: NotificationsSettingsdBinding(),
    ),
    GetPage(
      name: AppRoutes.addStudentSettings,
      page: () => const AddStudentSettings(),
      binding: SchoolBinding(),
    ),
    GetPage(
      name: AppRoutes.directios,
      page: () => const DirectionsPage(),
      binding: DirectionsBinding(),
    ),
  ];
}
