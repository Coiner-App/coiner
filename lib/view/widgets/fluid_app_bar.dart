import 'package:flutter/material.dart';

class FluidAppBar extends StatelessWidget {
  const FluidAppBar({super.key, required this.title, required this.body});
  final Widget title;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: false,
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            title: title,
            //backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 114.0,
            expandedHeight: 114.0,
          ),
        ];
      },
      body: body,
    );
  }
}