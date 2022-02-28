import 'package:flutter/material.dart';
import 'package:wesafe/widgets/showImage.dart';
import 'package:wesafe/widgets/showTitle.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: title.contains("กรุณา")
            ? Icon(
                Icons.warning,
                size: 40,
                color: Colors.red,
              )
            : ShowImage(),
        title: ShowTitle(
          title: title,
          index: 0,
        ),
        subtitle: ShowTitle(title: message, index: 1),
      ),
      children: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    ),
  );
}
