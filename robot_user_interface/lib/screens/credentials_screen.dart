import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/.env';

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({super.key});

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Text(
            'ROBOT CUADRÚPEDO - CONTROL',
            textAlign: TextAlign.center,
            style: AppStyles.textStyleH1(
                textColor: AppStyles.textColors['primary']),
          ),
        ),
        backgroundColor: AppStyles.generalColors['primary'],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: AronGradientLine(
            colors: [
              AppStyles.generalColors['primary']!,
              AppStyles.generalColors['secondary']!,
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: AppStyles.customBoxDecoration(
                      backgroundColor: AppStyles.generalColors['primary']!,
                      radius: Radius.circular(20),
                      shadows: false,
                      shadowDownDirection: true,
                    ),
                    child: Text('¡Bienvenido de nuevo!',
                        textAlign: TextAlign.left,
                        style: AppStyles.textStyleH3(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  Center(
                    child: SizedBox(
                      height: 300,
                      child: Image.asset(
                        "assets/Robot_1.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AronGradientLine(
                    height: 5,
                    colors: [
                      AppStyles.generalColors['primary']!,
                      AppStyles.generalColors['details']!,
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Text('Introduce tus credenciales para acceder',
                        textAlign: TextAlign.right,
                        style: AppStyles.textStyleH4(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  TextFormField(
                    controller: usernameController,
                    cursorColor: AppStyles.generalColors['primary'],
                    textInputAction: TextInputAction.next,
                    style: AppStyles.textStyleH3(
                      textColor: AppStyles.textColors['primary'],
                    ),
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: AppStyles.textStyleH3(
                        textColor: AppStyles.textColors['primary'],
                      ),
                      floatingLabelStyle: AppStyles.textStyleH3(
                        textColor: AppStyles.textColors['primary'],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppStyles.generalColors['details']!,
                            width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppStyles.generalColors['primary']!,
                            width: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    cursorColor: AppStyles.generalColors['primary'],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: AppStyles.textStyleH3(
                        textColor: AppStyles.textColors['primary'],
                      ),
                      floatingLabelStyle: AppStyles.textStyleH3(
                        textColor: AppStyles.textColors['primary'],
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppStyles.generalColors['details']!,
                            width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppStyles.generalColors['primary']!,
                            width: 1.2),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyles.generalColors['primary'],
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      if (usernameController.text.trim() == username &&
                          passwordController.text.trim() == password) {
                        Fluttertoast.showToast(msg: 'Credenciales correctos');
                        Navigator.of(context).pushNamed('/pairing_screen');
                      } else {
                        Fluttertoast.showToast(msg: 'Credenciales incorrectos');
                      }
                    },
                    icon: Icon(
                      Icons.lock_open,
                      size: 32,
                      color: AppStyles.generalColors['secondary'],
                    ),
                    label: Text(
                      'Entrar',
                      style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary']),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
