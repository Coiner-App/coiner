import 'dart:developer';

import 'package:coiner/app/ctheme.dart';
import 'package:coiner/core/utils/screen_util.dart';
import 'package:coiner/features/authentication/presentation/state_providers/authentication_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginInput extends ConsumerWidget {
  const LoginInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final emailTxt = TextEditingController();
    final passTxt = TextEditingController();
    final authState = ref.watch(authStateControllerProvider);

    // Listen for auth state
    ref.listen<AsyncValue<void>>(authStateControllerProvider, (previous, next) {
    if (!next.isLoading && next.hasError) {
      showDialog(
        context: context, 
        builder: (dialogctx) => AlertDialog(
          content: Text(next.error.toString()), 
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogctx), 
              child: const Text("OK"))]
          ));
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96.0),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: IconButton(
              onPressed: () {
                // Provider.of<PageController>(context, listen: false)
                //     .animateToPage(0,
                //         curve: Curves.easeInOut,
                //         duration: const Duration(milliseconds: 400));
                log("back pressed");
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_circle_outlined, size: 52.0, color: CTheme.primary),
            Text(
              "Login",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Card(
              color: Colors.white.withAlpha(10),
              shape: RoundedRectangleBorder(
                  //side: const BorderSide(color: CColors.secondary, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 0.0,
              margin: const EdgeInsets.symmetric(
                  /*horizontal: 24.0,*/ vertical: 48.0),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  //'Did you know that: Coiner was originally called "Clash Of Coins" in development',
                  'Beaware of scams, we would never ask for your password for rewards.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: ScreenUtil.isPortrait(context)
                    ? const EdgeInsets.only(bottom: 24.0)
                    : const EdgeInsets.only(bottom: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: emailTxt,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Email address",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                color: Colors.white70),
                            filled: true,
                            fillColor: theme.buttonTheme.colorScheme?.surfaceContainer,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextField(
                        controller: passTxt,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                color: Colors.white70),
                            filled: true,
                            fillColor: theme.buttonTheme.colorScheme?.surfaceContainer,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 20.0)),
                      ),
                    ),
                    Container(width: 32.0, height: 2, color: theme.buttonTheme.colorScheme?.surfaceContainer),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextButton(
                        onPressed: authState.isLoading ? null : () async => 
                        await ref.read(authStateControllerProvider.notifier).login(emailTxt.text, passTxt.text),
                        style: TextButton.styleFrom(
                          foregroundColor: CTheme.primary,
                          backgroundColor: CTheme.primary.withAlpha(33), //0.2 opacity
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                              side: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: authState.isLoading
                        ? const CircularProgressIndicator()
                        : const Text("LOGIN",
                            style:
                                TextStyle(fontSize: 14, color: CTheme.primary)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: InkWell(
                        child: const Text(
                          "Forgor password? 💀",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline),
                        ),
                        onTap: () => log("forgot password pressed"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}