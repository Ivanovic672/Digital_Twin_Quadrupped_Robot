import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/screens/widgets/update_profile.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Text(
            'INFORMACIÓN DE USUARIO',
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Registrado como:',
                      style: AppStyles.textStyleH5(
                          textColor: AppStyles.textColors['primary'])),
                  Text('Admin 001',
                      style: AppStyles.textStyleH5(
                          textColor: AppStyles.textColors['primary'])),
                ],
              ),
              SizedBox(height: 30),
              AronGradientLine(
                height: 5,
                colors: [
                  AppStyles.generalColors['primary']!,
                  AppStyles.generalColors['details']!,
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Apellidos, nombre:',
                        style: AppStyles.textStyleH2(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      'Esteve Gonzálvez, Iván',
                      style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary']),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  color: AppStyles.generalColors['details']),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text('Email:',
                        style: AppStyles.textStyleH2(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'ivesgon@etsid.upv.es',
                      style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary']),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  color: AppStyles.generalColors['details']),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text('Rol:',
                        style: AppStyles.textStyleH2(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'Owner',
                      style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary']),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  color: AppStyles.generalColors['details']),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text('Permisos:',
                        style: AppStyles.textStyleH2(
                            textColor: AppStyles.textColors['primary'])),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'Admin',
                      style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary']),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              AronGradientLine(
                height: 5,
                colors: [
                  AppStyles.generalColors['primary']!,
                  AppStyles.generalColors['details']!,
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                child: Card(
                  elevation: 2,
                  surfaceTintColor: AppStyles.generalColors['primary'],
                  shadowColor: AppStyles.generalColors['details'],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    child: Center(
                      child: Text('Modificar credenciales',
                          style: AppStyles.textStyleH5(
                              textColor: AppStyles.textColors['primary'])),
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      context: context,
                      builder: (_) {
                        return UpdateProfile();
                        //return UpdateProfile();
                      });
                },
              ),
              SizedBox(height: 30),
              AronGradientLine(
                height: 5,
                colors: [
                  AppStyles.generalColors['primary']!,
                  AppStyles.generalColors['details']!,
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.generalColors['primary'],
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()));
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: AppStyles.generalColors['secondary'],
                  ),
                  label: Text('Salir',
                      style: AppStyles.textStyleH1(
                          textColor: AppStyles.textColors['primary']))),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
