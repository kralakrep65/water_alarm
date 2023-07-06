import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
  static _CustomLoaderState? of(BuildContext context) =>
      context.findAncestorStateOfType<_CustomLoaderState>();
}

class _CustomLoaderState extends State<CustomLoader> {
  bool _isLoading = false;

  void showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.7,
                child:
                    const ModalBarrier(dismissible: false, color: Colors.black),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
