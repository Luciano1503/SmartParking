import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Core/app_localizations.dart';
import '../Styles/formulario_styles.dart';
import '../Widgets/formulario_widgets.dart';
import '../Widgets/preferences_controls.dart';
import '../Services/servicio_autenticacion.dart';
import '../Services/sesion_usuario.dart';
import 'package:proyectoestacionamiento/Pages/mapa.dart';

class FormularioPage extends StatefulWidget {
  final String correo;

  const FormularioPage({super.key, required this.correo});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final ServicioAutenticacion _authService = const ServicioAutenticacion();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final List<TextEditingController> _placaControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _placaFocusNodes = List.generate(6, (_) => FocusNode());

  DateTime? _selectedDate;
  final bool _obscurePassword = true;
  final bool _obscureConfirmPassword = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    _modeloController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    for (final c in _placaControllers) {
      c.dispose();
    }
    for (final f in _placaFocusNodes) {
      f.dispose();
    }

    super.dispose();
  }

  void _onPlacaChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _placaFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _placaFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: FormularioStyles.datePickerColorScheme(context),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _registrarUsuario() async {
    if (_isLoading) return;

    bool placaIncompleta = _placaControllers.any((c) => c.text.trim().isEmpty);
    if (placaIncompleta) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('form.plate_incomplete'))),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String placaFormateada =
          "${_placaControllers[0].text}${_placaControllers[1].text}${_placaControllers[2].text}-${_placaControllers[3].text}${_placaControllers[4].text}${_placaControllers[5].text}"
              .toUpperCase();

      final exito = await _authService.completarFormulario(
        widget.correo,
        _nombreController.text,
        _apellidoController.text,
        _telefonoController.text,
        _dniController.text,
        DateFormat("yyyy-MM-dd").format(_selectedDate!),
        placaFormateada,
        _modeloController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (exito) {
        final data = await _authService.login(
          widget.correo,
          _passwordController.text,
        );

        if (!mounted) return;

        if (data != null) {
          SesionUsuario.usuario = data;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MapaPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('form.success_manual'))),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('form.register_error'))),
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

                          SectionHeader(
                            icon: Icons.person_rounded,
                            label: context.tr('form.personal_data'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nombreController,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.names'),
                              Icons.person_outline_rounded,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? context.tr('form.enter_names')
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _apellidoController,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.surnames'),
                              Icons.badge_outlined,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? context.tr('form.enter_surnames')
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _dniController,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              "DNI",
                              Icons.credit_card_rounded,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: (value) =>
                                value == null || value.length != 8
                                ? context.tr('form.valid_dni')
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _telefonoController,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.phone'),
                              Icons.phone_rounded,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            validator: (value) =>
                                value == null || value.length != 9
                                ? context.tr('form.valid_phone')
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              _selectedDate == null
                                  ? context.tr('form.birth_date')
                                  : DateFormat(
                                      "dd/MM/yyyy",
                                    ).format(_selectedDate!),
                              Icons.calendar_today_rounded,
                            ),
                            onTap: _pickDate,
                            validator: (_) => _selectedDate == null
                                ? context.tr('form.select_date')
                                : null,
                          ),

                          const SizedBox(height: 24),

                          SectionHeader(
                            icon: Icons.directions_car_rounded,
                            label: context.tr('form.vehicle_data'),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            context.tr('form.plate'),
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white70
                                  : const Color(0xFF4A6A85),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          PlacaInputGroup(
                            controllers: _placaControllers,
                            focusNodes: _placaFocusNodes,
                            onChanged: _onPlacaChanged,
                          ),

                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _modeloController,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.model'),
                              Icons.car_repair_rounded,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? context.tr('form.enter_model')
                                : null,
                          ),

                          const SizedBox(height: 24),

                          SectionHeader(
                            icon: Icons.lock_rounded,
                            label: context.tr('form.credentials'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.password'),
                              Icons.lock_outline_rounded,
                            ),
                            validator: (value) =>
                                value == null || value.length < 8
                                ? context.tr('form.min_chars')
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: FormularioStyles.fieldTextStyle(context),
                            decoration: FormularioStyles.inputDecoration(
                              context,
                              context.tr('form.repeat_password'),
                              Icons.lock_person_outlined,
                            ),
                            validator: (value) =>
                                value != _passwordController.text
                                ? context.tr('form.passwords_mismatch')
                                : null,
                          ),

                          const SizedBox(height: 32),
                          GradientButton(
                            label: context.tr('form.register'),
                            icon: Icons.how_to_reg_rounded,
                            isLoading: _isLoading,
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
          const Positioned(
            top: 10,
            right: 12,
            child: SafeArea(child: PreferencesControls(compact: true)),
          ),
        ],
      ),
    );
  }
}
