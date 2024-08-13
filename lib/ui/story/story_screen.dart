import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/ui/story/provider/page_manager.dart';
import 'package:storyflutter/ui/story/provider/story_list_provider.dart';
import 'package:storyflutter/ui/story/story_item.dart';
import 'package:storyflutter/utils/data_state.dart';

import '../auth/provider/auth_provider.dart';

class StoryScreen extends StatefulWidget {
  static String routeKey = "storyscreen";
  final Function(String) onTapped;
  final Function() toFormScreen;
  final Function() onLogout;

  const StoryScreen(
      {super.key,
      required this.onTapped,
      required this.toFormScreen,
      required this.onLogout});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {

  final scrollController = ScrollController();

  @override
  void initState() {
    final apiProvider = context.read<StoryListProvider>();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (apiProvider.pageItems != null) {
          apiProvider.fetchAllStory();
        }

      }
    });

    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          context.watch<AuthProvider>().isLoadingLogout
              ? const Center(child: CircularProgressIndicator())
              : IconButton(
                  onPressed: () async {
                    final authRead = context.read<AuthProvider>();
                    final result = await authRead.logout();
                    if (result) widget.onLogout();
                  },
                  icon: const Icon(Icons.logout))
        ],
        title: Text(
          "Story List",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton:
          Consumer<StoryListProvider>(builder: (build, provider, _) {
        return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              widget.toFormScreen();
              final dataString =
                  await context.read<PageManager>().waitForResult();
              if (dataString) provider.fetchAllStory();
            });
      }),
      body: Consumer<StoryListProvider>(builder: (build, provider, _) {
        if (provider.state == DataState.loading && provider.pageItems==1) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == DataState.hasData) {
          return ListView.builder(
            controller: scrollController,
              itemCount: provider.result.length + (provider.pageItems != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == provider.result.length && provider.pageItems != null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final storyItem = provider.result[index];
                return StoryItem(
                    story: storyItem,
                    onTapped: (id) {
                      widget.onTapped(id);
                    });
              });
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
      }),
    );
  }
}
