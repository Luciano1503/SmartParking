import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Styles/formularioStyles.dart';
import '../Widgets/formularioWidgets.dart';
import '../Services/servicio_autenticacion.dart';

class FormularioPage extends StatefulWidget {
  final String correo;

  const FormularioPage({super.key, required this.correo});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  DateTime? _selectedDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    _placaController.dispose();
    _modeloController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(colorScheme: FormularioStyles.datePickerColorScheme),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final servicio = ServicioAutenticacion();
      final exito = await servicio.completarFormulario(
        widget.correo,
        _nombreController.text,
        _apellidoController.text,
        _telefonoController.text,
        _dniController.text,
        DateFormat("yyyy-MM-dd").format(_selectedDate!),
        _placaController.text,
        _modeloController.text,
        _passwordController.text,
      );

      if (exito) {
        ScaffoldMessenger.of(context)
            .showSnackBar(FormularioStyles.successSnackBar());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrar usuario")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FormBackground(),
          Positioned(
            top: -60,
            right: -80,
            child: GlowCircle(size: 240, color: FormularioStyles.glowCyan),
          ),
          Positioned(
            bottom: 0,
            left: -60,
            child: GlowCircle(size: 200, color: FormularioStyles.glowBlue),
          ),
          SafeArea(
            child: Column(
              children: [
                const CustomTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: FormularioStyles.scrollPadding,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const FormBrandHeader(),
                          const SizedBox(height: 24),
                          const FormPageTitle(),
                          const SizedBox(height: 28),

                          // Datos personales
                          const SectionHeader(
                            icon: Icons.person_rounded,
                            label: "Datos personales",
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nombreController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Nombres",
                              Icons.person_outline_rounded,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Ingrese sus nombres"
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _apellidoController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Apellidos",
                              Icons.badge_outlined,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Ingrese sus apellidos"
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _dniController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "DNI",
                              Icons.credit_card_rounded,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: (value) =>
                                value == null || value.length != 8
                                    ? "Ingrese un DNI válido"
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _telefonoController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Teléfono",
                              Icons.phone_rounded,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            validator: (value) =>
                                value == null || value.length != 9
                                    ? "Ingrese un teléfono válido de 9 dígitos"
                                    : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              _selectedDate == null
                                  ? "Fecha de nacimiento"
                                  : DateFormat("dd/MM/yyyy")
                                      .format(_selectedDate!),
                              Icons.calendar_today_rounded,
                            ),
                            onTap: _pickDate,
                            validator: (_) => _selectedDate == null
                                ? "Seleccione su fecha de nacimiento"
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // Datos del vehículo
                          const SectionHeader(
                            icon: Icons.directions_car_rounded,
                            label: "Datos del vehículo",
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _placaController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Placa del auto",
                              Icons.pin_outlined,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Ingrese la placa"
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _modeloController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Modelo del auto",
                              Icons.car_repair_rounded,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Ingrese el modelo"
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // Credenciales
                          const SectionHeader(
                            icon: Icons.lock_rounded,
                            label: "Credenciales",
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Contraseña",
                              Icons.lock_outline_rounded,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "Ingrese una contraseña"
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              "Repetir contraseña",
                              Icons.lock_person_outlined,
                            ),
                            validator: (value) =>
                                value != _passwordController.text
                                    ? "Las contraseñas no coinciden"
                                    : null,
                          ),

                          const SizedBox(height: 32),
                          GradientButton(
                            label: "Registrarse",
                            icon: Icons.how_to_reg_rounded,
                            onPressed: _registrarUsuario,
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
