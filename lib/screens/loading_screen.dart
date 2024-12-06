//açılış ekranının yeri
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(235, 249, 138, 147),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo ve yükleme göstergesi bölümü
          Container(
            width: double.infinity,
            child: Column(
              children: [
                // Logo bölümü
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    'assets/images/logo2.webp',
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(
                  child: DotLottieLoader.fromAsset(
                    "assets/motions/kalp.lottie",
                    frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                      if (dotlottie != null) {
                        return SizedBox(
                          width: 300, // Genişliği belirleyin
                          height: 250, // Yüksekliği belirleyin
                          child:
                              Lottie.memory(dotlottie.animations.values.single),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),

                // // Yükleniyor yazısı
                // const Text(
                //   'Yükleniyor...',
                //   style: TextStyle(
                //       fontSize: 22,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.white),
                // ),

                // Giriş yazısı
                InkWell(
                  onTap: () => context.go("/home"),
                  child: const Text(
                    'Giriş',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
