import 'package:chat_app/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/index.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  title: 'Messenger',
                ),
                _Form(),
                Labels(
                  questionString: '¿No tienes una cuenta?',
                  redirectString: 'Crea una cuenta ahora!',
                  route: 'register',
                ),
                Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomInputField(
            textEditingController: emailEditingController,
            prefixIcon: Icons.mail_lock_sharp,
            hintText: 'Email',
            textInputType: TextInputType.emailAddress,
          ),
          CustomInputField(
            textEditingController: passwordEditingController,
            prefixIcon: Icons.lock,
            hintText: 'Password',
            obscuredText: true,
          ),
          CustomElevatedButton(
            labelText: 'Ingresar',
            onPress: authService.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    final loginRes = await authService.login(
                      emailEditingController.text.trim(),
                      passwordEditingController.text.trim(),
                    );

                    if (loginRes) {
                      //TODO: navegar a otra pantalla
                      Navigator.pushReplacementNamed(context, 'users');
                      return;
                    }

                    // motrar alertas
                    showCustomAlert(
                      context,
                      'Incorrect credentials',
                      'Verify data',
                    );
                  },
          )
        ],
      ),
    );
  }
}
