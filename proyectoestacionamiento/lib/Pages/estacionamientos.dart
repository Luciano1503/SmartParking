import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Core/app_localizations.dart';
import '../Styles/estacionamientos_styles.dart';
import '../Widgets/estacionamientos_widgets.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: EstacionamientosStyles.pageBackground,
      appBar: AppBar(
        backgroundColor: EstacionamientosStyles.appBarBackground,
        surfaceTintColor: EstacionamientosStyles.appBarBackground,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: EstacionamientosStyles.appBarBackground,
                systemNavigationBarColor: const Color(0xFF07111F),
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: EstacionamientosStyles.appBarBackground,
                systemNavigationBarColor: EstacionamientosStyles.pageBackground,
              ),
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
                  return Center(child: Text(context.tr('parking_list.empty')));
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
