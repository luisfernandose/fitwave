import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailCont = TextEditingController(text: '');
  var passwordCont = TextEditingController(text: '');
  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
  bool rememberPassword = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 100.0, 25.0, 20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/FitWaveLogo.png',
                          height: 100, width: 100),
                      const SizedBox(width: 10),
                      const Text(
                        'Sign In To Continue',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: emailCont,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          // Validar el email con RegExp
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: passwordCont,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: Colors.black,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              TextEditingController _emailController =
                                  TextEditingController();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Change Password'),
                                    content: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cerrar el AlertDialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Obtener el valor del campo de texto del correo electrónico
                                          String enteredEmail =
                                              _emailController.text;
                                          print(
                                              'Correo Electrónico Ingresado: $enteredEmail');

                                          // try {
                                          //   await FirebaseAuth.instance
                                          //       .sendPasswordResetEmail(
                                          //           email: emailCont.value.text
                                          //               .trim())
                                          //       .then((value) {
                                          //     toast(
                                          //         'Check your email to change password',
                                          //         bgColor: Colors.red.shade200,
                                          //         textColor: Colors.red);
                                          //     Navigator.of(context).pop();
                                          //   });
                                          // } on FirebaseAuthException catch (e) {
                                          //   print(e.code);
                                          //   print(e.message);
                                          // }
                                        },
                                        child: const Text('Send'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // Color de fondo
                            backgroundColor: Colors.blue, // Color del texto
                          ),
                          onPressed: () async {
                            // if (formKey.currentState!.validate()) {
                            //   saveForm();
                            //   user = _auth.currentUser;
                            //   print('useeerrr:');
                            //   print(user);
                            //   final SharedPreferences sharedPreferences =
                            //       await SharedPreferences.getInstance();
                            //   sharedPreferences.setString(
                            //       'email', emailCont.text);
                            //   sharedPreferences.setString('uid', user!.uid);
                            //   // },
                            // } else if (!rememberPassword) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text(
                            //             'Please agree to the processing of personal data')),
                            //   );
                            // }
                          },
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // SignUpScreen().launch(context);
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
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
