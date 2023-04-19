import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tkchatv2/common/utils/colors.dart';
import 'package:tkchatv2/common/widgets/custom_button.dart';
import 'package:tkchatv2/features/auth/auth.dart';
import 'package:tkchatv2/features/landing/screens/landing_screen.dart';
import 'package:tkchatv2/features/select_contacts/screens/select_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'TKChat',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: const Text(
                      'Create Group',
                    ),
                    onTap: () {})
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabBarController,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Chat"),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Status"),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Calls"),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).pushNamed(SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ExitButton extends StatelessWidget {
  const ExitButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: "Sign Out",
      onPressed: () async {
        final authRepository = AuthRepository(
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
        );
        await authRepository.signOut(context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(LandingScreen.routeName, (route) => false);
      },
    );
  }
}
