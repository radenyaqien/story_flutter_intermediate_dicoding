import 'package:flutter/material.dart';
import 'package:storyflutter/ui/addstory/form_add_story.dart';


class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({super.key, required this.navigateBack, required this.changeAddress});
  final Function() navigateBack;
  final Function(double lat, double lon) changeAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              navigateBack();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(
          "Add your Story",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormAddStory(changeAddress: changeAddress,),
        ),
      ),
    );
  }
}
