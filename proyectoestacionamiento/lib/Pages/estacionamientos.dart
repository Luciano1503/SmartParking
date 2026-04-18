import 'package:flutter/material.dart';
import '../Styles/estacionamientosStyles.dart';
import '../Widgets/estacionamientosWidgets.dart';

class EstacionamientosPage extends StatelessWidget {
  const EstacionamientosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final empresas = [
      {
        "nombre": "Universidad UTP",
        "logo": "assets/images/utp.png",
        "descripcion": "Estacionamiento techado con vigilancia 24/7.",
        "actividad": "Institución educativa",
        "direccion": "Av. Salaverry 1234, Lima",
        "tag": "Educación",
        "spots": "120 espacios",
      },
      {
        "nombre": "Mall Aventura",
        "logo": "assets/images/mall.png",
        "descripcion": "Amplio estacionamiento con zonas diferenciadas.",
        "actividad": "Centro comercial",
        "direccion": "Av. Los Próceres 567, Lima",
        "tag": "Comercial",
        "spots": "350 espacios",
      },
      {
        "nombre": "Real Plaza",
        "logo": "assets/images/realplaza.png",
        "descripcion": "Estacionamiento subterráneo con acceso directo.",
        "actividad": "Centro comercial",
        "direccion": "Av. Aviación 890, Lima",
        "tag": "Comercial",
        "spots": "280 espacios",
      },
      {
        "nombre": "Plaza Norte",
        "logo": "assets/images/plazanorte.png",
        "descripcion": "Gran capacidad y monitoreo con cámaras.",
        "actividad": "Centro comercial",
        "direccion": "Panamericana Norte Km 10, Lima",
        "tag": "Comercial",
        "spots": "500 espacios",
      },
    ];

    return Scaffold(
      backgroundColor: EstacionamientosStyles.pageBackground,
      appBar: AppBar(
        backgroundColor: EstacionamientosStyles.appBarBackground,
        elevation: 0,
        // ❌ Se eliminó el leading con la flecha
        title: const PageTitle(),
        actions: [
          AffiliatesBadge(total: empresas.length),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SubHeader(),
          Expanded(
            child: GridView.builder(
              padding: EstacionamientosStyles.gridPadding,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
              itemCount: empresas.length,
              itemBuilder: (context, index) {
                final empresa = empresas[index];
                return ParkingCard(
                  empresa: empresa,
                  onTap: () => _showDetailSheet(context, empresa),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailSheet(
    BuildContext context,
    Map<String, String> empresa,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailSheet(empresa: empresa),
    );
  }
}
