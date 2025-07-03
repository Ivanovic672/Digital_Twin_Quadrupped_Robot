import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/.env';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateProfile> {
  final currentPasswordController = TextEditingController();
  final newUsernameController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newUsernameController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.generalColors['scaffoldBackground'],
        borderRadius: BorderRadius.only(
            topLeft: AppStyles.containerRadius['medium']!,
            topRight: AppStyles.containerRadius['medium']!),
      ),
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.6 +
          MediaQuery.of(context).viewInsets.bottom,
      width: MediaQuery.of(context).size.width * 0.95,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 30.0),
            Text(
              'Modifica tus credenciales',
              style: AppStyles.textStyleH1(
                  textColor: AppStyles.textColors['primary']),
            ),
            SizedBox(height: 30.0),
            TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                cursorColor: AppStyles.generalColors['primary'],
                textInputAction: TextInputAction.next,
                style: AppStyles.textStyleH3(
                  textColor: AppStyles.textColors['primary'],
                ),
                decoration: InputDecoration(
                  labelText: 'Contraseña actual',
                  labelStyle: AppStyles.textStyleH3(
                    textColor: AppStyles.textColors['primary'],
                  ),
                  floatingLabelStyle: AppStyles.textStyleH3(
                    textColor: AppStyles.textColors['primary'],
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppStyles.generalColors['details']!, width: 2.0),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppStyles.generalColors['primary']!, width: 1.2),
                  ),
                ),
                validator: (value) {
                  if (value != null) {
                    if (value.trim() != password) {
                      return 'Contraseña actual incorrecta';
                    }
                  }
                  return null;
                }),
            SizedBox(height: 30.0),
            AronGradientLine(
              height: 5,
              colors: [
                AppStyles.generalColors['primary']!,
                AppStyles.generalColors['details']!,
              ],
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: newUsernameController,
              cursorColor: AppStyles.generalColors['primary'],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nuevo nombre de usuario',
                labelStyle: AppStyles.textStyleH3(
                  textColor: AppStyles.textColors['primary'],
                ),
                floatingLabelStyle: AppStyles.textStyleH3(
                  textColor: AppStyles.textColors['primary'],
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppStyles.generalColors['details']!, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppStyles.generalColors['primary']!, width: 1.2),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              cursorColor: AppStyles.generalColors['primary'],
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                labelStyle: AppStyles.textStyleH3(
                  textColor: AppStyles.textColors['primary'],
                ),
                floatingLabelStyle: AppStyles.textStyleH3(
                  textColor: AppStyles.textColors['primary'],
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppStyles.generalColors['details']!, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppStyles.generalColors['primary']!, width: 1.2),
                ),
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyles.generalColors['primary'],
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                if (currentPasswordController.text.trim() == password) {
                  // Update Credentials <-- Should be here
                  Fluttertoast.showToast(
                      msg: 'Credenciales modificados con éxito');
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: 'Contraseña actual incorrecta');
                }
              },
              label: Text(
                'Aceptar',
                style: AppStyles.textStyleH2(
                    textColor: AppStyles.textColors['primary']),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
