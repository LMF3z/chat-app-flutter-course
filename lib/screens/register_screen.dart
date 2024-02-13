import 'package:flutter/material.dart';

import 'package:chat_app/widgets/index.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  title: 'Registro',
                ),
                _Form(),
                Labels(
                  questionString: '¿Ya tienes una cuenta?',
                  redirectString: 'Ingresa ahora!',
                  route: 'login',
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
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          CustomInputField(
            textEditingController: nameEditingController,
            prefixIcon: Icons.perm_identity,
            hintText: 'Nombre',
          ),
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
            labelText: 'Registrar',
            onPress: () {
              print(emailEditingController.text);
              print(passwordEditingController.text);
            },
          )
        ],
      ),
    );
  }
}
