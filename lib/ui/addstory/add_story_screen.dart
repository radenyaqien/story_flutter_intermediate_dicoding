import 'package:flutter/material.dart';
import 'package:storyflutter/ui/addstory/form_add_story.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              //TODO navigate back
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          "Add your Story",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FormAddStory(),
        ),
      ),
    );
  }
}
