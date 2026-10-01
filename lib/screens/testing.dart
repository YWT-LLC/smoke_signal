/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../widgets/export.dart';
import 'package:ywt_private/ywt_private.dart' as ywt;

import 'dart:convert';
import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<TestingScreen> {
  // Define build data //

  late final WebSocketChannel _channel;
  final List<Map<String, dynamic>> _messages = <Map<String, dynamic>>[];

  final TextEditingController msgControl = TextEditingController();

  // Define custom functions //

  void _sendMessage(String msg) {
    if (msg.isEmpty) return;

    final Map<String, String> payload = <String, String>{
      'sender': 'TestUser',
      'content': msg,
    };

    _channel.sink.add(jsonEncode(payload));
    msgControl.clear();
  }

  // Init //

  @override
  void initState() {
    super.initState();

    _channel = WebSocketChannel.connect(Uri.parse('ws://${ywt.myIP}:8080/ws'));
    _channel.stream.listen(
      (dynamic data) {
        final Map<String, dynamic> decoded = jsonDecode(data as String) as Map<String, dynamic>;
        setState(() {
          _messages.add(decoded);
        });
      },
      onError: (dynamic error) => ezLog('WebSocket error: ${error.toString()}'),
      onDone: () => ezLog('WebSocket connection closed.'),
    );
  }

  // Return the build //

  @override
  Widget build(BuildContext context) => Consumer<EzCP>(builder: (_, EzCP config, __) {
        final TextStyle? dimLabel = config.labelStyle?.copyWith(color: config.colors.outline);

        return SmokeSignalScaffold(
          config,
          alignment: Alignment.bottomCenter,
          body: EzCol(children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (_, int index) {
                  final Map<String, dynamic> msg = _messages[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        msg['content'] ?? '',
                        style: config.bodyStyle,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        '${msg['sender']} • ${msg['id']}',
                        style: dimLabel,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  );
                },
              ),
            ),
            config.margin,
            EzRow(config, children: <Widget>[
              Expanded(
                child: EzTextField(
                  constraints: ezTextFieldConstraints(context),
                  controller: msgControl,
                  hintText: 'Type a message...',
                  validator: (_) => null,
                  onFieldSubmitted: (String msg) => _sendMessage(msg),
                ),
              ),
              config.rowMargin,
              EzIconButton(
                config,
                icon: EzIcon(config, Icons.send),
                tooltip: 'Send message',
                onPressed: () => _sendMessage(msgControl.text),
              ),
            ]),
            const EzKeyboardSpacer(0),
          ]),
          drawerHeader: LoginHeader(config),
        );
      });

  @override
  void dispose() {
    _channel.sink.close();
    msgControl.dispose();
    super.dispose();
  }
}
