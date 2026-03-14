import 'package:app_twins/services/mongo/mongo_service.dart';
import 'package:flutter/material.dart';
// Importe aqui o arquivo onde está o seu MongoService
// import 'package:seu_projeto/services/mongo_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Método de Login integrado ao MongoService
  Future<void> _realizarLogin() async {
    final String email = _emailController.text.trim();
    final String senha = _passwordController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _showSnackBar("Por favor, preencha todos os campos.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Chama o método que você já criou no MongoService
       bool sucesso = await MongoService.verificarLogin(email, senha);
      
      // Simulação para teste (Remova o Future.delayed e use a linha acima)
     // await Future.delayed(const Duration(seconds: 2));
     // bool sucesso = true;  Simulação de sucesso

      if (sucesso) {
        if (!mounted) return;
        // Navega para a próxima tela (Cadastro da Criança - Passo 2 de 4)
        // Navigator.pushReplacementNamed(context, '/cadastro_passo2');
        _showSnackBar("Login realizado com sucesso!", isError: false);
      } else {
        _showSnackBar("Email ou senha incorretos.");
      }
    } catch (e) {
      _showSnackBar("Erro ao conectar ao servidor.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF66C2B2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo baseada no Passo 1
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFFE4E1), width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      "Brinca+",
                      style: TextStyle(
                        color: Color(0xFF66C2B2),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Bem-vindo(a) de volta!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Acesse sua conta para gerenciar as\natividades dos seus filhos.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 50),
              
              // Campo Email
              _buildInputLabel("E-mail"),
              _buildTextField(
                controller: _emailController,
                hint: "Digite seu e-mail",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              
              // Campo Senha
              _buildInputLabel("Senha"),
              _buildTextField(
                controller: _passwordController,
                hint: "Digite sua senha",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Botão Entrar com o Gradiente da Imagem
              GestureDetector(
                onTap: _isLoading ? null : _realizarLogin,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFB5B5), // Rosa
                        Color(0xFFB5D8EB), // Azul
                        Color(0xFFA8E6CF), // Verde
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ainda não tem conta? "),
                  GestureDetector(
                    onTap: () {
                      // Navegar para tela de registro
                    },
                    child: const Text(
                      "Cadastre-se",
                      style: TextStyle(
                        color: Color(0xFF66C2B2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF8FBFB),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFA8E6CF), width: 1.5),
        ),
      ),
    );
  }
}