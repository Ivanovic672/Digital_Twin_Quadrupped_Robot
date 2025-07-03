import 'dart:typed_data';

import 'package:aron_gradient_line/aron_gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:flutter_widgetz/flutter_widgetz.dart';
import 'package:robot_user_interface/main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:robot_user_interface/screens/widgets/directional_pad.dart';
import 'package:robot_user_interface/screens/widgets/table_widgets.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  BluetoothConnection? connection;
  List<double> dataIMU = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  String buffer = '';
  bool isSimulationStarted = false;
  bool isExitPressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Recibir la conexión pasada por Navigator
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is BluetoothConnection) {
      connection = args;
      listenToConnection(connection!);
    }
  }

  void listenToConnection(BluetoothConnection conn) {
    conn.input?.listen((data) {
      buffer += String.fromCharCodes(data);

      // Process complete line
      if (buffer.contains("\n")) {
        final lines = buffer.split("\n");
        final line = lines.first.trim();
        buffer = lines.length > 1 ? lines[1] : "";

        try {
          // Split line into characters between commas
          List<String> receivedMessage =
              line.split(",").map((e) => e.trim()).toList();

          // If simulation has  started
          if ((receivedMessage.length > 1 && receivedMessage[0] == "S")) {
            setState(() {
              isSimulationStarted = true;
              dataIMU = receivedMessage
                  .sublist(1)
                  .map((e) => double.parse(e.trim()))
                  .toList();
            });
          }

          // List<int> parsed =
          //     line.split(",").map((e) => int.parse(e.trim())).toList();
          // List<double> parsed =
          //     line.split(",").map((e) => double.parse(e.trim())).toList();

          // if (parsed.length == 6) {
          //    setState(() => numbers = parsed);
          //  }
          // if (parsed.length == 6) {
          //   setState(() => dataIMU = parsed);
          // }
        } catch (e) {
          print("Error de parseo: $e");
        }
      }
    }).onDone(() {
      print("Conexión finalizada");
    });
  }

  void sendData(String data) {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(Uint8List.fromList(data.codeUnits));
      connection!.output.allSent;
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Text(
            'SIMULACIÓN',
            textAlign: TextAlign.center,
            style: AppStyles.textStyleH1(
                textColor: AppStyles.textColors['primary']),
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
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Table(
                // border: TableBorder.all(
                //     color: AppStyles.generalColors['details']!, width: 1.2),
                columnWidths: const {
                  0: FlexColumnWidth(1.3),
                  1: FlexColumnWidth(2.1),
                  2: FlexColumnWidth(2.1),
                  3: FlexColumnWidth(2.1),
                },
                children: [
                  // Cabecera
                  TableRow(
                    // decoration: BoxDecoration(
                    //     color: AppStyles.generalColors['details']!),
                    children: const [
                      SizedBox(), // Celda vacía para alineación
                      TableHeaderCell(text: 'Eje X (Roll)'),
                      TableHeaderCell(text: 'Eje Y (Pitch)'),
                      TableHeaderCell(text: 'Eje Z (Yaw)'),
                    ],
                  ),

                  // Fila 1
                  TableRow(
                    children: [
                      RowLabelCell(text: 'Pos (°)'),
                      TableDataCell(
                        value: dataIMU[0],
                        thresholds: [20.0, 35.0],
                      ), // Pos X
                      TableDataCell(
                        value: dataIMU[1],
                        thresholds: [30.0, 45.0],
                      ), // Pos Y
                      TableDataCell(value: dataIMU[2]), // Pos Z
                    ],
                  ),

                  // Fila 2
                  TableRow(
                    children: [
                      RowLabelCell(text: 'Speed (°/s)'),
                      TableDataCell(
                        value: dataIMU[3],
                        thresholds: [30.0, 50.0],
                      ), // Speed X
                      TableDataCell(
                        value: dataIMU[4],
                        thresholds: [40.0, 60.0],
                      ), // Speed Y
                      TableDataCell(
                        value: dataIMU[5],
                        thresholds: [90.0],
                      ), // Speed Z
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      'Lecturas del sensor IMU\n(véase el modelo adjunto para interpretar el sistema de referencia móvil)',
                      style: AppStyles.textStyleH3(
                          textColor: AppStyles.textColors['primary']),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Image.asset(
                      "assets/Pavlov_Mini_Simscape_Edit.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              AronGradientLine(
                height: 5,
                colors: [
                  AppStyles.generalColors['primary']!,
                  AppStyles.generalColors['details']!,
                ],
              ),
              SizedBox(height: 20.0),
              (isSimulationStarted)
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              //width: MediaQuery.of(context).size.width * 0.5,
                              height: 30,
                              child: Text('Pad de Control',
                                  textAlign: TextAlign.start,
                                  style: AppStyles.textStyleH1(
                                      textColor:
                                          AppStyles.textColors['primary'])),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 30,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: DefaultTextStyle(
                                  textAlign: TextAlign.end,
                                  style: AppStyles.textStyleH2(
                                      textColor:
                                          AppStyles.textColors['primary']),
                                  child: AnimatedTextKit(
                                    repeatForever: true,
                                    animatedTexts: [
                                      FadeAnimatedText('Simulación en vivo'),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        // DirectionalPad.chevron(
                        //   backgroundColor: AppStyles.generalColors['primary'],
                        //   borderColor: AppStyles.generalColors['details'],
                        //   buttonColor: AppStyles.generalColors['secondary'],
                        //   size: 160,
                        // ),
                        CustomDirectionalPad(
                          onPressed: (direction) {
                            print('Dirección pulsada: $direction');
                            switch (direction) {
                              case DPadDirection.up:
                                sendData("U\n");
                                break;
                              case DPadDirection.down:
                                sendData("D\n");
                                break;
                              case DPadDirection.left:
                                sendData("L\n");
                                break;
                              case DPadDirection.right:
                                sendData("R\n");
                                break;
                            }
                          },
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 100.0,
                      child: DefaultTextStyle(
                        style: AppStyles.textStyleH1(
                            textColor: AppStyles.textColors['primary']),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            FadeAnimatedText(
                                'Esperando a que comience la simulación...'),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
        if (isExitPressed)
          Container(
            color: Colors.black87,
            child: Dialog(
              elevation: 10.0,
              shadowColor: AppStyles.generalColors['primary'],
              backgroundColor: AppStyles.generalColors['primary'],
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(AppStyles.containerRadius['medium']!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        "¿Estás seguro de que deseas salir y terminar la simulación?",
                        style: AppStyles.textStyleH2(
                          textColor: AppStyles.textColors['primary'],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppStyles.generalColors['tertiary'],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Sí",
                            style: AppStyles.textStyleH3(
                              textColor: AppStyles.textColors['primary'],
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppStyles.generalColors['tertiary'],
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              isExitPressed = false;
                            });
                          },
                          child: Text(
                            "Cancelar",
                            style: AppStyles.textStyleH3(
                              textColor: AppStyles.textColors['primary'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'butn2',
        backgroundColor: AppStyles.generalColors['cancel'],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.bigRadius)),
        icon: Icon(
          Icons.arrow_circle_left_outlined,
          color: AppStyles.textColors['secondary'],
        ),
        label: Text(
          'Salir',
          style: AppStyles.textStyleH3(
              textColor: AppStyles.textColors['secondary']),
        ),
        onPressed: () {
          setState(() {
            isExitPressed = true;
          });
        },
      ),
    );
  }
}
