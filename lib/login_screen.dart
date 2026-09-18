import 'package:flutter/material.dart';

import 'app_state.dart';
import 'home_shell.dart';
import 'widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState
    extends State<LoginScreen> {
  final userController =
      TextEditingController(
    text: 'admin',
  );

  final passwordController =
      TextEditingController(
    text: '1234',
  );

  bool hidePassword = true;

  void login() {
    final user =
        AppState.instance.login(
      userController.text,
      passwordController.text,
    );

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Usuario o contraseña incorrectos.',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const HomeShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop =
        MediaQuery.of(context)
                .size
                .width >=
            900;

    return Scaffold(
      body: Row(
        children: [
          if (desktop)
            Expanded(
              child: Container(
                color:
                    const Color(
                  0xFF142A3A,
                ),
                padding:
                    const EdgeInsets
                        .all(60),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const BrandLogo(
                      size: 82,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'ERP de Producción\n2RM',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize: 42,
                        fontWeight:
                            FontWeight
                                .w900,
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Seguimiento de órdenes, '
                      'tareas, materiales y producción.',
                      style: TextStyle(
                        color: Colors
                            .white
                            .withOpacity(
                                .7),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Center(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets
                        .all(30),
                child:
                    ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 440,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      if (!desktop) ...[
                        const BrandLogo(
                          size: 68,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                      const Text(
                        'Bienvenido',
                        style:
                            TextStyle(
                          fontSize: 34,
                          fontWeight:
                              FontWeight
                                  .w900,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller:
                            userController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Usuario',
                          prefixIcon:
                              Icon(
                            Icons
                                .person_outline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller:
                            passwordController,
                        obscureText:
                            hidePassword,
                        onSubmitted: (_) =>
                            login(),
                        decoration:
                            InputDecoration(
                          labelText:
                              'Contraseña',
                          prefixIcon:
                              const Icon(
                            Icons
                                .lock_outline,
                          ),
                          suffixIcon:
                              IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  hidePassword =
                                      !hidePassword;
                                },
                              );
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons
                                      .visibility_outlined
                                  : Icons
                                      .visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,
                        child:
                            FilledButton(
                          onPressed:
                              login,
                          child:
                              const Text(
                            'Iniciar sesión',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'admin / 1234',
                          style:
                              TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
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