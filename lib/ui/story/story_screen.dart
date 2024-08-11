import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/ui/addstory/add_story_screen.dart';
import 'package:storyflutter/ui/detail/detail_screen.dart';
import 'package:storyflutter/ui/story/provider/story_list_provider.dart';
import 'package:storyflutter/ui/story/story_item.dart';
import 'package:storyflutter/utils/data_state.dart';

class StoryScreen extends StatelessWidget {
  static String routeKey = "storyscreen";

  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Story List",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddStoryScreen()),
            );
          }),
      body: Consumer<StoryListProvider>(builder: (build, provider, _) {
        if (provider.state == DataState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.state == DataState.hasData) {
          return ListView.builder(
              itemCount: provider.result.length,
              itemBuilder: (context, index) {
                final storyItem = provider.result[index];
                return StoryItem(
                    story: storyItem,
                    onTapped: (id) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(id: id)),
                      );
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
