import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo/view/curved_box.dart';
import 'package:todo/view_model/service.dart';

import 'constant.dart';

class AllView extends StatelessWidget {
  const AllView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          contorller.navigateToAddPage(context);
        },
        child: const Icon(
          FontAwesomeIcons.notesMedical,
          color: AppColors.white,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => contorller.fetchTodo(),
        child: AnimationLimiter(
          child: GetBuilder<Services>(builder: (context) {
            return Visibility(
              visible: contorller.items.isNotEmpty,
              replacement: const Center(
                child: Text('No To Do'),
              ),
              child: MasonryGridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: contorller.items.length,
                  itemBuilder: (context, index) {
                    final item = contorller.items[index];
                    final id = item['_id'];
                    return AnimationConfiguration.staggeredGrid(
                        position: index,
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: CurvedBox(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        contorller.delete(id, context);
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.deleteLeft),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  item['description'],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                DateFooter(
                                  date: 'Jan 21',
                                  onChanged: () {
                                    contorller.navigateToEditePage(
                                        context, item);
                                  },
                                )
                              ],
                            ),
                          ),
                        ));
                  }),
            );
          }),
        ),
      ),
    );
  }
}

final contorller = Get.put(Services());

class DateFooter extends StatelessWidget {
  const DateFooter({Key? key, required this.date, required this.onChanged})
      : super(
          key: key,
        );
  final String date;
  final Function onChanged;
  final TextStyle style = const TextStyle(color: AppColors.lightGrey);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: style,
        ),
        TextButton(onPressed: () => onChanged(), child: const Text('Edite'))
      ],
    );
  }
}
