import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyflutter/data/model/story.dart';
import 'package:storyflutter/data/preference/preference_helper.dart';
import 'package:storyflutter/data/remote/api_service.dart';
import 'package:storyflutter/ui/detail/detail_story_provider.dart';

import '../../utils/data_state.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final Function() navigateBack;

  const DetailScreen({super.key, required this.id, required this.navigateBack});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailStoryProvider>(
      create: (_) => DetailStoryProvider(
          apiService: ApiService(),
          preferenceHelper: PreferenceHelper(),
          id: widget.id),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            widget.navigateBack();
          }),
          title: Text(
            "Detail Story",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Consumer<DetailStoryProvider>(builder: (context, provider, _) {
          if (provider.state == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == DataState.hasData) {
            return DetailContent(story: provider.story);
          } else {
            return Center(
              child: Material(
                child: Text(provider.message),
              ),
            );
          }
        }),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  const DetailContent({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Image.network(story.photoUrl)),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
              child: Text(story.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
              child: Text(
                "Description",
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                story.description,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
