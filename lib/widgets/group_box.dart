import 'package:chattify/theme/color.dart';
import 'package:flutter/material.dart';

class GroupBox extends StatelessWidget {
  GroupBox({Key? key, this.bgColor = primary, this.onTap}) : super(key: key);

  final Color bgColor;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 15),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 4,
              offset: const Offset(3, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                    child: Text("Title Group",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
                //Notification,
              ],
            ),

            GestureDetector(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/images/profile.jpg",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              children: const <Widget>[
                                Expanded(
                                    child: Text("Person",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700))),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 10,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 3),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: const <Widget>[
                                Expanded(
                                    child: Text("Last Message",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 13))),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            )
            //Container(
            //    child: ChatItem(
            //  gruopData,
            //  profileSize: 35,
            //  isNotified: false,
            //))
          ],
        ),
      ),
    );
  }
}
