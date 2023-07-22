import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tkchatv2/common/widgets/error.dart';
import 'package:tkchatv2/features/auth/auth.dart';
import 'package:tkchatv2/features/chat/screen/mobile_chat_screen.dart';
import 'package:tkchatv2/features/group/screens/create_group_screen.dart';
import 'package:tkchatv2/features/landing/screens/landing_screen.dart';
import 'package:tkchatv2/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:tkchatv2/features/status/screen/confirm_status.dart';
import 'package:tkchatv2/features/status/screen/status_display_screen.dart';
import 'package:tkchatv2/models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments["name"];
      final uid = arguments["uid"];
      final groupChat = arguments["groupChat"];
      final profilePic = arguments["profilePic"];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          isGroupChat: groupChat,
          profilePic: profilePic,
          uid: uid,
        ),
      );
    case LandingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );
    case StatusDisplayScreen.routeName:
      final status = settings.arguments as Status;
      return MaterialPageRoute(
        builder: (context) => StatusDisplayScreen(status: status),
      );
    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
