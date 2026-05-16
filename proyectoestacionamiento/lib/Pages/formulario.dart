import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Styles/formularioStyles.dart';
import '../Widgets/formularioWidgets.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 🔥 1. Controladores y Nodos de Foco para las 6 cajitas de la Placa
  final List<TextEditingController> _placaControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _placaFocusNodes = List.generate(6, (_) => FocusNode());

  DateTime? _selectedDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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

    for (final c in _placaControllers) { c.dispose(); }
    for (final f in _placaFocusNodes) { f.dispose(); }
    
    super.dispose();
  }

  // 🔥 2. Lógica para saltar de cajita en cajita automáticamente
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
          data: Theme.of(context).copyWith(colorScheme: FormularioStyles.datePickerColorScheme),
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

    // Validación manual de la placa
    bool placaIncompleta = _placaControllers.any((c) => c.text.trim().isEmpty);
    if (placaIncompleta) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa los 6 caracteres de la placa")),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 🔥 3. Construimos la placa en formato ABC-123
      String placaFormateada = "${_placaControllers[0].text}${_placaControllers[1].text}${_placaControllers[2].text}-${_placaControllers[3].text}${_placaControllers[4].text}${_placaControllers[5].text}".toUpperCase();

      final servicio = ServicioAutenticacion();
      final exito = await servicio.completarFormulario(
        widget.correo,
        _nombreController.text,
        _apellidoController.text,
        _telefonoController.text,
        _dniController.text,
        DateFormat("yyyy-MM-dd").format(_selectedDate!),
        placaFormateada, // Mandamos la placa ya estructurada
        _modeloController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (exito) {
        // 🔥 AUTO-LOGIN
        final data = await servicio.login(widget.correo, _passwordController.text);
        
        if (!mounted) return;
        
        if (data != null) {
          SesionUsuario.usuario = data;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MapaPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          setState(() { _isLoading = false; });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registro exitoso. Inicia sesión manualmente.")),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        setState(() { _isLoading = false; });
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
                          const SectionHeader(icon: Icons.person_rounded, label: "Datos personales"),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nombreController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Nombres", Icons.person_outline_rounded),
                            validator: (value) => value == null || value.isEmpty ? "Ingrese sus nombres" : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _apellidoController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Apellidos", Icons.badge_outlined),
                            validator: (value) => value == null || value.isEmpty ? "Ingrese sus apellidos" : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _dniController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("DNI", Icons.credit_card_rounded),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            validator: (value) => value == null || value.length != 8 ? "Ingrese un DNI válido" : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _telefonoController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Teléfono", Icons.phone_rounded),
                            keyboardType: TextInputType.number,
                            maxLength: 9,
                            validator: (value) => value == null || value.length != 9 ? "Ingrese un teléfono válido" : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration(
                              _selectedDate == null ? "Fecha de nacimiento" : DateFormat("dd/MM/yyyy").format(_selectedDate!),
                              Icons.calendar_today_rounded,
                            ),
                            onTap: _pickDate,
                            validator: (_) => _selectedDate == null ? "Seleccione su fecha" : null,
                          ),

                          const SizedBox(height: 24),

                          // Datos del vehículo
                          const SectionHeader(icon: Icons.directions_car_rounded, label: "Datos del vehículo"),
                          const SizedBox(height: 16),
                          
                          // 🔥 4. Nuestro nuevo Widget de Placa estilo OTP
                          const Text("Placa del auto", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 8),
                          PlacaInputGroup(
                            controllers: _placaControllers,
                            focusNodes: _placaFocusNodes,
                            onChanged: _onPlacaChanged,
                          ),
                          
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _modeloController,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Modelo del auto", Icons.car_repair_rounded),
                            validator: (value) => value == null || value.isEmpty ? "Ingrese el modelo" : null,
                          ),

                          const SizedBox(height: 24),

                          // Credenciales
                          const SectionHeader(icon: Icons.lock_rounded, label: "Credenciales"),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Contraseña", Icons.lock_outline_rounded),
                            validator: (value) => value == null || value.length < 8 ? "Mínimo 8 caracteres" : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            style: FormularioStyles.inputTextStyle,
                            decoration: FormularioStyles.inputDecoration("Repetir contraseña", Icons.lock_person_outlined),
                            validator: (value) => value != _passwordController.text ? "Las contraseñas no coinciden" : null,
                          ),

                          const SizedBox(height: 32),
                          GradientButton(
                            label: "Registrarse",
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
        ],
      ),
    );
  }
}