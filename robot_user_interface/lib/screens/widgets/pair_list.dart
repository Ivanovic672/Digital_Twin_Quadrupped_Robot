import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:robot_user_interface/app_styles.dart';

class PairList extends StatefulWidget {
  const PairList({super.key});

  @override
  State<PairList> createState() => _PairListState();
}

class _PairListState extends State<PairList> {
  BluetoothDevice? selectedDevice;
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];

  @override
  void initState() {
    super.initState();
    getBondedDevices().then((d) => setState(() => devices = d));
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
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.95,
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 20),
          Text("Selecciona el dispositivo a enlazar",
              style: AppStyles.textStyleH1(
                  textColor: AppStyles.textColors['primary'])),
          SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                itemCount: devices.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                      onTap: () {
                        connect(devices[index]);
                      },
                      child: Card(
                        elevation: 2,
                        surfaceTintColor: AppStyles.generalColors['primary'],
                        shadowColor: AppStyles.generalColors['secondary'],
                        color: AppStyles.generalColors['tertiary'],
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppStyles.smallRadius),
                        ),
                        child: ListTile(
                          title: Text(
                            devices[index].name ?? devices[index].address,
                            style: AppStyles.textStyleH2(
                                textColor: AppStyles.textColors['primary']),
                          ),
                          trailing: Icon(
                            Icons.subdirectory_arrow_left,
                            color: AppStyles.generalColors['secondary'],
                          ),
                          leading: Icon(
                            Icons.bluetooth_connected,
                            color: AppStyles.generalColors['secondary'],
                          ),
                        ),
                      ));
                }),
          ),
        ]),
      ),
    );
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      final BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      if (connection.isConnected) {
        // Cerrar el showDialog antes de navegar
        Navigator.of(context).pop();
        // Cerrar el modal antes de navegar
        Navigator.of(context).pop();

        // Navegar y pasar la conexión
        Navigator.of(context).pushNamed(
          '/simulation_screen',
          arguments: connection,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con el dispositivo')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<List<BluetoothDevice>> getBondedDevices() async {
    final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

    // Asegura que Bluetooth esté encendido
    if (!(await bluetooth.isEnabled ?? false)) {
      await bluetooth.requestEnable();
    }

    // Obtener lista de dispositivos emparejados
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    return devices;
  }
}
