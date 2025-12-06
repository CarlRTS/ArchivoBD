import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    // Validar campos
    if (_nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos');
      return;
    }

    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Las contraseñas no coinciden');
      return;
    }

    // Validar longitud de contraseña
    if (_passwordController.text.length < 6) {
      _showErrorDialog('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
      );

      if (mounted) {
        // Verificar si el usuario fue creado
        if (response.user != null) {
          String message = 'Registro exitoso. ';
          
          // Verificar si requiere confirmación de email
          if (response.session == null) {
            message += 'Por favor, verifica tu correo electrónico antes de iniciar sesión.';
          } else {
            message += 'Tu cuenta ha sido creada correctamente.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          
          // Regresar a la pantalla de login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          _showErrorDialog('No se pudo crear el usuario. Por favor, intenta nuevamente.');
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Error al registrar: ';
        if (e.toString().contains('Invalid API key') || 
            e.toString().contains('TU_ANON_KEY_AQUI')) {
          errorMessage += 'Configuración incorrecta de Supabase. Por favor, agrega tu anon key en lib/config/supabase_config.dart';
        } else {
          errorMessage += e.toString().replaceAll('Exception: ', '');
        }
        _showErrorDialog(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    bool showVisibilityToggle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF1B4D3E),
            fontSize: 16,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF1B4D3E),
                width: 1,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              color: Color(0xFF1B4D3E),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 8),
              suffixIcon: showVisibilityToggle
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF1B4D3E),
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4D3E), // Dark green background
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFFE5E5E5), // Light gray header
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ArchivoBD',
                    style: TextStyle(
                      color: Color(0xFF1B4D3E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 200,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF1B4D3E),
                          width: 1,
                        ),
                      ),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(
                          color: Color(0xFF1B4D3E),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 8),
                      ),
                      style: TextStyle(
                        color: Color(0xFF1B4D3E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Section - Register Form
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Registro',
                                      style: TextStyle(
                                        color: Color(0xFF1B4D3E),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    // Nombre Field
                                    _buildTextField(
                                      controller: _nombreController,
                                      label: 'Nombre',
                                    ),
                                    const SizedBox(height: 30),
                                    // Apellido Field
                                    _buildTextField(
                                      controller: _apellidoController,
                                      label: 'Apellido',
                                    ),
                                    const SizedBox(height: 30),
                                    // Email Field
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Correo.',
                                    ),
                                    const SizedBox(height: 30),
                                    // Password Field
                                    _buildTextField(
                                      controller: _passwordController,
                                      label: 'Contraseña',
                                      obscureText: _obscurePassword,
                                      showVisibilityToggle: true,
                                      onToggleVisibility: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                    // Confirm Password Field
                                    _buildTextField(
                                      controller: _confirmPasswordController,
                                      label: 'Confirmar Contraseña',
                                      obscureText: _obscureConfirmPassword,
                                      showVisibilityToggle: true,
                                      onToggleVisibility: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 40),
                                    // Register Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleRegister,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF5E6D3), // Light beige
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          disabledBackgroundColor: const Color(0xFFD4C4B0),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                    Color(0xFF1B4D3E),
                                                  ),
                                                ),
                                              )
                                            : const Text(
                                                'REGISTRAR',
                                                style: TextStyle(
                                                  color: Color(0xFF1B4D3E),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    // Login Link
                                    Row(
                                      children: [
                                        const Text(
                                          '¿Ya tienes cuenta?',
                                          style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Inicia sesión.',
                                            style: TextStyle(
                                              color: Color(0xFF1B4D3E),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            // Right Section - Information
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image Container
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/images/archivist.jpg',
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 300,
                                            color: Colors.white.withOpacity(0.2),
                                            child: const Center(
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.white,
                                                size: 80,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  // Description Text
                                  const Text(
                                    'El Archivo Histórico Arquidiocesano de Caracas no solo preserva el legado documental de la iglesia y de sus pastores, sino que contribuye activamente a la construcción de la memoria histórica de la nación, reafirmando el papel de la iglesia como custodia de la identidad, la espiritualidad y la cultura venezolana.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1.6,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Logo and Name
                                  Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.radio_button_checked,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Archivo Histórico\nArquidiocesano de Caracas',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

