import 'package:flutter/material.dart';
import '../Styles/estacionamientosStyles.dart';
import '../Widgets/estacionamientosWidgets.dart';
import '../Services/parking_service.dart'; 
import '../Models/parking_model.dart';

class EstacionamientosPage extends StatefulWidget {
  const EstacionamientosPage({super.key});

  @override
  State<EstacionamientosPage> createState() => _EstacionamientosPageState();
}

class _EstacionamientosPageState extends State<EstacionamientosPage> {
  final ParkingService _parkingService = ParkingService();
  late Future<List<Estacionamiento>> _futureEstacionamientos;

  @override
  void initState() {
    super.initState();
    _futureEstacionamientos = _parkingService.getEstacionamientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstacionamientosStyles.pageBackground,
      appBar: AppBar(
        backgroundColor: EstacionamientosStyles.appBarBackground,
        elevation: 0,
        title: const PageTitle(),
      ),
      body: Column(
        children: [
          const SubHeader(),
          Expanded(
            child: FutureBuilder<List<Estacionamiento>>(
              future: _futureEstacionamientos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay estacionamientos afiliados.'));
                }

                final empresas = snapshot.data!;
                return GridView.builder(
                  padding: EstacionamientosStyles.gridPadding,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: empresas.length,
                  itemBuilder: (context, index) {
                    return ParkingCard(
                      empresa: empresas[index],
                      onTap: () => _showDetailSheet(context, empresas[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailSheet(BuildContext context, Estacionamiento empresa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailSheet(empresa: empresa),
    );
  }
}