import 'dart:async';

import 'package:flutter/material.dart';

import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:keyboard_utils/keyboard_listener.dart';

void main() => runApp(MyApp());

// Sample Bloc
class KeyboardBloc {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  StreamController<double> _streamController = StreamController<double>();
  Stream<double> get stream => _streamController.stream;

  KeyboardUtils get keyboardUtils => _keyboardUtils;

  void start() {
    _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
      _streamController.sink.add(_keyboardUtils.keyboardHeight);
    }, willShowKeyboard: (double keyboardHeight) {
      _streamController.sink.add(keyboardHeight);
    }));
  }

  void dispose() {
    _keyboardUtils.dispose();
    _streamController.close();
  }
}

// App
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KeyboardBloc _bloc = KeyboardBloc();

  @override
  void initState() {
    super.initState();

    _bloc.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Utils Sample'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(),
              TextField(
                keyboardType: TextInputType.number,
              ),
              TextField(),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<double>(
                  stream: _bloc.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    return Text(
                        'is keyboard open: ${_bloc.keyboardUtils.isKeyboardOpen}\n'
                        'Height: ${_bloc.keyboardUtils.keyboardHeight}');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();

    super.dispose();
  }
}
