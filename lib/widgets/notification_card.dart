import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

notifcationCard(
    BuildContext context, String heading, String subheading, Icon icon,
    {double? index = 0, double? maxNum = 0}) {

  return Container(
    margin: EdgeInsets.only(
      left: 5,
      right: 5,
      top: 60 + index! * 20.0,
      bottom: 0,
    ),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 5,
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(child: icon),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      heading,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(subheading),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context)?.dismiss();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
