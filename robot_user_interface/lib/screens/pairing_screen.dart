import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/screens/widgets/pair_list.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: SizedBox(
          height: 35,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 5.0),
              Text(
                'EMPAREJAMIENTO',
                textAlign: TextAlign.center,
                style: AppStyles.textStyleH1(
                    textColor: AppStyles.textColors['primary']),
              ),
              SizedBox(width: 5.0),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.asset(
                  "assets/Bluetooth_FM_Color.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/user_screen');
              },
              child: Icon(
                Icons.person,
                size: 26.0,
                color: AppStyles.generalColors['secondary'],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(
              child: Image.asset(
                "assets/Robot_2.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            AronGradientLine(
              height: 5,
              colors: [
                AppStyles.generalColors['primary']!,
                AppStyles.generalColors['details']!,
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Text(
                  'Pulsa el botón flotante para establecer el emparejamiento Bluetooth con el módulo HC-05',
                  textAlign: TextAlign.justify,
                  style: AppStyles.textStyleH2(
                      textColor: AppStyles.textColors['primary'])),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Row(
                spacing: 20.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    size: 60,
                    color: AppStyles.generalColors['details'],
                  ),
                  Icon(
                    Icons.keyboard_double_arrow_down_rounded,
                    size: 60,
                    color: AppStyles.generalColors['details'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'butn1',
        backgroundColor: AppStyles.generalColors['primary'],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.bigRadius)),
        icon: Icon(
          Icons.bluetooth_searching_rounded,
          color: AppStyles.generalColors['secondary'],
        ),
        label: Text(
          'Nuevo emparejamiento',
          style: AppStyles.textStyleH3(
            textColor: AppStyles.textColors['primary'],
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return PairList();
            },
          );
        },
      ),
    );
  }
}
