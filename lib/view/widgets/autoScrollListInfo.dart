import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/view/screen/message.dart';

class AutoScrollList extends StatefulWidget {
  final RxList anniversaryListData;

  AutoScrollList(this.anniversaryListData);

  @override
  _AutoScrollListState createState() => _AutoScrollListState();
}

class _AutoScrollListState extends State<AutoScrollList> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < widget.anniversaryListData.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Color> colorList = <Color>[
    lightSecondaryPrimaryColor,
    lightRedColor,
    lightBlue,
    lightButtonColor,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      child: Container(
        height: 130.h,
        width: double.infinity,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.anniversaryListData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(
                  MessageScreen(
                    widget.anniversaryListData[index]['name'].toString(),
                    widget.anniversaryListData[index]['chat_id'].toString(),
                    widget.anniversaryListData[index]['id'].toString(),
                    '',
                    [],
                    '',
                    '',
                    '',
                    'anniversary',
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(11.r)),
                      color: colorList[index % colorList.length],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11.r)),
                      child: Image.asset(
                        widget.anniversaryListData[index]['event_type']
                                    .toString()
                                    .toLowerCase() ==
                                "birthday"
                            ? 'assets/images/png/birthday_creative_image.png'
                            : "assets/images/png/Happy_Anniversary.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 7.h,
                    left: 50.w,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.anniversaryListData[index]['event_type'].toString().toLowerCase() == "birthday" ? "🎉 Happy Birthday" : "🎉 Happy Anniversary"} ${widget.anniversaryListData[index]['name']}!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${widget.anniversaryListData[index]['role_name']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: CircleAvatar(
                            radius: 30.r,
                            backgroundImage: NetworkImage(
                              '${widget.anniversaryListData[index]['image']}',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
