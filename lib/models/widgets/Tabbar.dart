import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tabitem extends StatelessWidget {
  final String titile;
  final int count;

  const Tabitem({
    super.key,
    required this.titile,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(titile,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),
        ),
        count > 0
        ? Container(
          margin:  const EdgeInsetsDirectional.only(start: 5),
         padding: const EdgeInsets.all(3),
         decoration: BoxDecoration(
          color: Colors.grey.shade200,
         shape: BoxShape.circle,
         ),
         child: Center(
          child: Text(
            count > 9 ? "9+" : count.toString(),
         style: const TextStyle(
          color: Colors.black54, 
          fontSize: 10
         ),
         ),
         ),
        )
        : const SizedBox(width: 0, height: 0,)
        ],
      ),
    );
  }
}