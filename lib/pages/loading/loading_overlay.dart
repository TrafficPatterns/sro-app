import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget? child;
  const LoadingOverlay({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () {},
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              child ?? const SizedBox(),
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(
                    dismissible: false,
                    color: Color.fromARGB(133, 141, 139, 139)),
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
