import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paginationPageProvider = StateProvider<int>((_) {
  return 0;
});

final List<String> _testData = List<String>.generate(106, (i) => "Item $i");

class Pagination extends ConsumerWidget {
  final int limit;
  // skip = page number x limit

  Pagination({required this.limit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int _totalItems = _testData.length; // TODO pass in the list length
    final int _pageGroupCount = (_testData.length / limit).ceil(); // number of grouped pages
    // print('page group count: $_pageGroupCount');
    final page = ref.watch(paginationPageProvider);
    // final selectedGroup = ref.watch(_selectedGroupProvider);
    final _pageGroupEnd = (page + 1) * limit;
    final _pageGroupStart = _pageGroupEnd - (limit - 1);

    // print(_pageGroupCount);
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Showing $_pageGroupStart to ${_pageGroupEnd > _totalItems ? _totalItems : _pageGroupEnd} of $_totalItems'),
            ],
          ),
          Divider(height: 22.0, thickness: 1.0, color: Colors.grey.shade300,),
          createPaginationBar(_totalItems, page, limit, ref),
        ],
      ),
    );
  }
}

Widget createPaginationBar(int totalItems, int skip, int limit, WidgetRef ref) {
  List<Widget> row =[];
  int numberOfPages = (totalItems / limit).ceil();
  int paginationPage = ref.watch(paginationPageProvider);
  // print('totalItems: $totalItems -- limit: $limit');
  // print('numPages: $numberOfPages');

  /// if 7 or less page groups, just show page indicators 👍
  if (numberOfPages <= 7) {
    for (int i = 0; i < numberOfPages; i++) {
      row.add(GestureDetector(
        onTap: () {
          print('skip: $i -- limit: $limit');
          ref.read(paginationPageProvider.state).state = i;
        },
        child: Padding(
          padding: EdgeInsets.only(right: i < numberOfPages ? 10.0 : 0),
          child: Column(
            children: [
              Text(
                (i + 1).toString().padLeft(2, '0'),
                style: TextStyle(color: Colors.black),),
              SizedBox(height: 2.0),
              i == skip ? Container(height: 2, width: 14.0, color: Colors.black) : Container(height: 2),
            ],
          ),
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row
    );
  } else {
    for (int i = 0; i < 7; i++) {
      /// show LEFT ARROW BUTTON 👍
      if (paginationPage > 0 && i == 0) {
        row.add(GestureDetector(
          onTap: () {
            print('skip: $i -- limit: $limit');
            ref.read(paginationPageProvider.state).state--;
          },
          child: Column(
            children: [
              Icon(Icons.arrow_back_ios, color: Colors.black, size: 15.0),
              SizedBox(height: 2.0),
            ],
          ),
        ));
        // if selected paginationPage == 0 => no left arrow, pos 1-4 numbers, ellipsis pos 5, final page pos 6, right arrow pos 7
        // if selected paginationPage == 1 || 2 => left arrow, pos 2-4 numbers, ellipsis pos 5, final page pos 6, right arrow pos 7
        // if selected paginationPage == numberOfPages - 1 => left arrow, page 1 pos 2, ellipsis pos 3, pos 4-7 no right arrow
        // if selected paginationPage == numberOfPages - 2 || numberOfPages - 3 => left arrow, page 1 pos 2, ellipsis pos 3, pos 4-6, right arrow
        // if selected paginationPage > 2 || < numberOfPages - 3 => pos 1 left arrow, pos 2 1, pos 3 ellipsis, pos 4 selected page, pos 5 ellipsis, pos 6 final page, pos 7 right arrow
        /// add ELLIPSIS
      } else if ((paginationPage > 0 && i == 4) ||
          ((paginationPage == numberOfPages - 1 || paginationPage == numberOfPages - 2 || paginationPage == numberOfPages - 3) && i == 2) ||
          ((paginationPage > 2 || paginationPage < numberOfPages - 3) && (i == 2) || i == 4)
      ) {
        row.add(GestureDetector(
          onTap: () {
            print('skip: $i -- limit: $limit');
            ref
                .read(paginationPageProvider.state)
                .state = i;
          },
          child: Padding(
            padding: EdgeInsets.only(right: i < numberOfPages ? 10.0 : 0),
            child: Column(
              children: [
                Text(
                  // (i + 1).toString().padLeft(2, '0'),
                  '...',
                  style: TextStyle(color: Colors.black),),
                SizedBox(height: 2.0),
                i == skip ? Container(
                    height: 2, width: 14.0, color: Colors.black) : Container(
                    height: 2),
              ],
            ),
          ),
        ));
        /// if not on last page show RIGHT ARROW BUTTON
      } else if (paginationPage != numberOfPages - 1 && i == 6) {
        row.add(GestureDetector(
          onTap: () {
            print('skip: $i -- limit: $limit');
            ref.read(paginationPageProvider.state).state++;
          },
          child: Column(
            children: [
              Icon(Icons.arrow_forward_ios, color: Colors.black, size: 15.0),
              SizedBox(height: 2.0),
            ],
          ),
        ));
        /// if last item is selected
        // } else if (i == 6) {
        //     row.add(GestureDetector(
        //       onTap: () {
        //         print('skip: $i -- limit: $limit');
        //         ref.read(paginationPageProvider.state).state = i;
        //       },
        //       child: Padding(
        //         padding: EdgeInsets.only(right: i < numberOfPages ? 10.0 : 0),
        //         child: Column(
        //           children: [
        //             Text(
        //               numberOfPages.toString(),
        //               style: TextStyle(color: Colors.black),),
        //             SizedBox(height: 2.0),
        //             i == numberOfPages ? Container(height: 2, width: 14.0, color: Colors.black) : Container(height: 2),
        //           ],
        //         ),
        //       ),
        //     ));
      } else {
        /// show the numbers if not an ellipsis or arrow
        row.add(GestureDetector(
          onTap: () {
            // print('skip: $i -- limit: $limit');
            ref.read(paginationPageProvider.state).state = i;
          },
          child: Padding(
            padding: EdgeInsets.only(right: i < numberOfPages ? 10.0 : 0),
            child: Column(
              children: [
                Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: TextStyle(color: Colors.black),),
                SizedBox(height: 2.0),
                i == skip ? Container(height: 2, width: 14.0, color: Colors.black) : Container(height: 2),
              ],
            ),
          ),
        ));
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: row);
  }
}