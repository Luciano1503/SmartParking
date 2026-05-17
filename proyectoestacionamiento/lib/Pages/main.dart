import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyectoestacionamiento/Pages/mapa.dart';
import 'package:flutter/services.dart';
import 'registro.dart';
import '../Core/api_config.dart';
import '../Core/app_localizations.dart';
import '../Core/app_preferences.dart';
import '../Styles/main_styles.dart';
import '../Widgets/main_widgets.dart';
import '../Widgets/preferences_controls.dart';
import '../Services/servicio_autenticacion.dart';
import '../Services/sesion_usuario.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppPreferences.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartParking Solutions',
        theme: AppStyles.lightTheme,
        darkTheme: AppStyles.darkTheme,
        themeMode: AppPreferences.instance.themeMode,
        locale: AppPreferences.instance.locale,
        supportedLocales: const [Locale('es'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) =>
            AppPreferencesScope(child: child ?? const SizedBox.shrink()),
        home: const LoginPage(),
      ),
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
  static const MethodChannel _navigationChannel = MethodChannel(
    'smartparking/navigation',
  );
  final ServicioAutenticacion _authService = const ServicioAutenticacion();
  bool _obscurePassword = true;

  bool _isLoading = false;

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

    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _slideUp =
        Tween<Offset>(
          begin: AppStyles.slideBeginOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
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

  Future<void> _loginUsuario() async {
    // Si ya está cargando, ignora pulsaciones adicionales
    if (_isLoading) return;

    final correo = _correoController.text.trim();
    final contrasenia = _passwordController.text.trim();

    if (correo.isEmpty || contrasenia.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('login.empty_credentials'))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final data = await _authService.login(correo, contrasenia);

    if (data != null) {
      SesionUsuario.usuario = data;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MapaPage()),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('login.invalid_credentials'))),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  Future<void> _openCompanyPortal() async {
    var opened = false;

    try {
      opened =
          await _navigationChannel.invokeMethod<bool>(
            'openUrl',
            ApiConfig.companyPortalUrl,
          ) ??
          false;
    } on PlatformException {
      opened = false;
    }

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('login.company_error'))),
      );
    }
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
            child: GlowCircle(size: 280, color: AppStyles.glowCyanStrong),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: GlowCircle(size: 200, color: AppStyles.glowBlueSoft),
          ),
          Positioned(
            top: 200,
            left: 40,
            child: GlowCircle(size: 80, color: AppStyles.glowCyanLight),
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
                        isLoading: _isLoading,
                        onTogglePassword: _togglePasswordVisibility,
                        onLoginPressed: _loginUsuario,
                        onRegisterPressed: _goToRegister,
                        onCompanyPortalPressed: _openCompanyPortal,
                      ),
                    ],
                  ),
                ),
              ),
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
