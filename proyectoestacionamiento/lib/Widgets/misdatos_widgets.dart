import 'package:flutter/material.dart';
import '../Core/app_localizations.dart';
import '../Styles/misdatos_styles.dart';

// Banner superior de perfil
class PerfilBanner extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String correo;

  const PerfilBanner({
    super.key,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MisDatosStyles.bannerDecoration,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Row(
        children: [
          _AvatarCircle(
            initials:
                "${nombre.isNotEmpty ? nombre[0] : ''}${apellido.isNotEmpty ? apellido[0] : ''}",
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$nombre $apellido", style: MisDatosStyles.profileNameStyle),
              const SizedBox(height: 3),
              Text(correo, style: MisDatosStyles.profileSubStyle),
              const SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.tr('profile.active_user'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Card de información personal
class InfoPersonalCard extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String dni;
  final String telefono;
  final String fechaNacimiento;

  const InfoPersonalCard({
    super.key,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.telefono,
    required this.fechaNacimiento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MisDatosStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.person_outline_rounded,
            title: context.tr('profile.personal_info'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DataField(label: context.tr('profile.name'), value: nombre),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DataField(label: context.tr('profile.surname'), value: apellido),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DataField(label: "DNI", value: dni),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DataField(label: context.tr('profile.phone'), value: telefono),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DataField(
                        label: context.tr('profile.birth_date'),
                        value: fechaNacimiento,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DataField(
                        label: context.tr('profile.status'),
                        value: context.tr('profile.verified'),
                        valueColor: MisDatosStyles.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card de vehículo
class VehiculoCard extends StatelessWidget {
  final String placa;
  final String modelo;

  const VehiculoCard({super.key, required this.placa, required this.modelo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MisDatosStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            icon: Icons.directions_car_outlined,
            title: context.tr('profile.vehicle'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: MisDatosStyles.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    color: MisDatosStyles.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(placa, style: MisDatosStyles.fieldValueStyle),
                    const SizedBox(height: 3),
                    Text(
                      modelo,
                      style: TextStyle(
                        color: MisDatosStyles.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: MisDatosStyles.iconBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        context.tr('profile.registered'),
                        style: TextStyle(
                          color: MisDatosStyles.primaryBlue,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Botón principal (sólido azul)
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: MisDatosStyles.primaryBlue,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 9),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón secundario (outline suave)
class SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: MisDatosStyles.cardBg,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: MisDatosStyles.borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: MisDatosStyles.textMuted, size: 17),
            const SizedBox(width: 9),
            Text(
              label,
              style: TextStyle(
                color: MisDatosStyles.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _AvatarCircle extends StatelessWidget {
  final String initials;
  const _AvatarCircle({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CardHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MisDatosStyles.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: MisDatosStyles.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: MisDatosStyles.primaryBlue, size: 14),
          ),
          const SizedBox(width: 8),
          Text(title.toUpperCase(), style: MisDatosStyles.sectionTitleStyle),
        ],
      ),
    );
  }
}

class _DataField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DataField({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MisDatosStyles.fieldLabelStyle),
        const SizedBox(height: 3),
        Text(
          value,
          style: MisDatosStyles.fieldValueStyle.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
