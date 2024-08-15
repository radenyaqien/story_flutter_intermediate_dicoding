import 'package:flutter/material.dart';
import 'package:storyflutter/data/model/story.dart';

class StoryItem extends StatelessWidget {
  final Story story;
  final Function(String) onTapped;

  const StoryItem({super.key, required this.story, required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTapped(story.id);
        },
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        story.photoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      textAlign: TextAlign.justify,
                      story.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ))
            ]));
  }
}
