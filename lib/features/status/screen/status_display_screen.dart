// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tkchatv2/common/widgets/loader.dart';

import 'package:tkchatv2/models/status_model.dart';
import 'package:story_view/story_view.dart';

class StatusDisplayScreen extends StatefulWidget {
  static const String routeName = "/status-display-screen";
  final Status status;
  const StatusDisplayScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusDisplayScreen> createState() => _StatusDisplayScreenState();
}

class _StatusDisplayScreenState extends State<StatusDisplayScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
          url: widget.status.photoUrl[i],
          controller: storyController,
        ),
      );
    }
  }

  @override
  void initState() {
    initStoryPageItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                }
              },
            ),
    );
  }
}
