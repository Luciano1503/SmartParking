import 'package:flutter/material.dart';
import 'package:proyectoestacionamiento/Pages/mapa.dart';
import 'registro.dart';
import '../Styles/mainStyles.dart';
import '../Widgets/mainWidgets.dart';
import '../Services/servicio_autenticacion.dart';
import '../Services/sesion_usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartParking Solutions',
      theme: AppStyles.appTheme,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: AppStyles.animationDuration,
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideUp = Tween<Offset>(
      begin: AppStyles.slideBeginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Nueva función de login real
  Future<void> _loginUsuario() async {
    final correo = _correoController.text.trim();
    final contrasenia = _passwordController.text.trim();

    if (correo.isEmpty || contrasenia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese correo y contraseña")),
      );
      return;
    }

    final servicio = ServicioAutenticacion();
    final data = await servicio.login(correo, contrasenia);

    if (data != null) {
      // Guardamos datos en la sesión
      SesionUsuario.usuario = data;

      // Redirigimos al mapa
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MapaPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Correo o contraseña incorrectos")),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const StyledBackground(),
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(
              size: 280,
              color: AppStyles.glowCyanStrong,
            ),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: GlowCircle(
              size: 200,
              color: AppStyles.glowBlueSoft,
            ),
          ),
          Positioned(
            top: 200,
            left: 40,
            child: GlowCircle(
              size: 80,
              color: AppStyles.glowCyanLight,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: AppStyles.pagePadding,
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogoBadge(),
                      const SizedBox(height: 20),
                      const BrandTitle(),
                      const SizedBox(height: 8),
                      const BrandSubtitle(),
                      const SizedBox(height: 36),
                      LoginCard(
                        correoController: _correoController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: _togglePasswordVisibility,
                        onLoginPressed: _loginUsuario,
                        onRegisterPressed: _goToRegister,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
