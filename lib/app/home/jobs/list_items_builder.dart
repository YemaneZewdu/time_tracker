import 'package:flutter/material.dart';
import 'empty_content.dart';

// type definition with a generic type T
// defined as a function returning a widget
typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

// handles the loading, data, no data and error states
class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  // data state
  Widget _buildList(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 0.5),
      // + 2 is for tricking the list view to draw a divider before the
      // first item and after the last item in the list
      itemCount: items.length + 2,
      itemBuilder: (context, index) {
        // when the fake placeholder items are clicked
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        // we need to do index -1 because we added a container at index 0
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
