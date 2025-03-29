library affogato.site;

import 'dart:convert';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

part './api_clients/mail_api_client.g.dart';
part './api_clients/users_api_client.g.dart';
part './options.dart';
part './dev_secrets.dart';

final FirebaseAuthWeb auth = FirebaseAuthWeb.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: options);

  print(auth.currentUser == null);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  double offset = 0;
  final ScrollController scrollController = ScrollController();
  final VideoPlayerController playerController =
      VideoPlayerController.asset('assets/video.mov');

  @override
  void initState() {
    playerController.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          onPressed: () async {
            if (auth.currentUser == null) {
              await showDialog(
                context: context,
                builder: (ctx) => SignUpDialog(),
              );
            } else if (!auth.currentUser!.isEmailVerified) {
              // await auth.currentUser!.sendEmailVerification(null);
              print('please verify your email');
            } else {
              print('ok');
            }

            if (auth.currentUser != null) {
              final res = await MailAPI.mailSubscribeEarlyAccess.post(
                auth: (await auth.currentUser!.getIdToken(true))!,
                queryParameters: (productId: 'cortado_alpha'),
              );

              if (res.statusCode == 200) {
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (ctx) => const Material(
                      child: Center(
                        child: Text('Done!'),
                      ),
                    ),
                  );
                }
              } else {
                print(res.statusCode);
                print(res.body);
              }
            }
          },
          child: const Text('Sign up for early access'),
        ),
      ),
    );
  }

  /* @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            offset += event.scrollDelta.dy;
            print((offset * 2));
            playerController
                .seekTo(Duration(milliseconds: (offset * 10).round()));
          }
        },
        child: RawGestureDetector(
          gestures: {
            VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
              (VerticalDragGestureRecognizer instance) {
                instance.onUpdate = (DragUpdateDetails details) {
                  offset += (details.delta.dy);
                };
              },
            ),
          },
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: VideoPlayer(playerController),
            ),
          ),
        ),
      ),
    );
  } */
}

class SignUpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextButton(
            onPressed: () async {
              try {
                final cred =
                    await auth.createUserWithEmailAndPassword(email, 'abc123!');
                //   await cred.user!.sendEmailVerification(null);
                await UsersAPI.usersAccountCreate.post(queryParameters: (
                  authorization: (await cred.user!.getIdToken(false))!
                ));
              } on FirebaseException catch (e, st) {
                print(e.message);
                print(st);
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Sign Up'),
          ),
          TextButton(
            onPressed: () async {
              await auth.signInWithEmailAndPassword(email, 'abc123!');
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
