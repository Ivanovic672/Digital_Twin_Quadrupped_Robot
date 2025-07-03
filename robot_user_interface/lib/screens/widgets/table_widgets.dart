import 'package:flutter/material.dart';
import 'package:robot_user_interface/app_styles.dart';
import 'package:robot_user_interface/screens/widgets/custom_circular_indicator.dart';

// Celda de cabecera
class TableHeaderCell extends StatelessWidget {
  final String text;
  const TableHeaderCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppStyles.generalColors['primary'],
        border:
            Border.all(color: AppStyles.generalColors['details']!, width: 1.1),
      ),
      child: Text(text,
          style: AppStyles.textStyleH4(
              textColor: AppStyles.textColors['primary'])),
    );
  }
}

// Celda de contenido
class TableDataCell extends StatelessWidget {
  final double value;
  final List<double>? thresholds;
  const TableDataCell({super.key, required this.value, this.thresholds});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        border:
            Border.all(color: AppStyles.generalColors['details']!, width: 1),
      ),
      alignment: Alignment.center,
      child: SemiCircularIndicator(
        value: value, // Valor entre -1.0 (izquierda) y 1.0 (derecha)
        radius: MediaQuery.of(context).size.height * 0.055,
        strokeWidth: 8,
        thresholds: thresholds,
      ),
    );
  }
}

// Etiqueta de fila (columna izquierda)
class RowLabelCell extends StatelessWidget {
  final String text;
  const RowLabelCell({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        color: AppStyles.generalColors['primary'],
        border:
            Border.all(color: AppStyles.generalColors['details']!, width: 1.1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: AppStyles.textStyleH4(
          textColor: AppStyles.textColors['primary'],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
