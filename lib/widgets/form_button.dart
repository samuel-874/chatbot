import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';
import 'package:sammychatbot/widgets/notification_card.dart';

class CustomFormButton extends ConsumerStatefulWidget {
  final GlobalKey<FormState>? globalKey;
  final String? label;
  final Function? onSuccess;

  const CustomFormButton(
      {super.key,
      required this.globalKey,
      required this.label,
      required this.onSuccess});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _FormButtonState();
  }
}

class _FormButtonState extends ConsumerState<CustomFormButton> {
  @override
  build(BuildContext context) {
    final bool loading = ref.watch(formLoadStateProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              if (widget.globalKey!.currentState!.validate() && !loading) {
                widget.onSuccess!();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: loading
                  ? const Color.fromARGB(255, 153, 181, 216)
                  : const Color.fromARGB(255, 11, 100, 209),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
            ),
            child: Text(
              loading ? "Loading..." : widget.label!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            )),
      ),
    );
  }
}
