import 'package:flutter/material.dart';
import 'package:new_app/provider/firestore_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  
//đăng ký tài khoản
  void register() async {
    setState(() => isLoading = true);
    try {
      await FirestoreProvider().registerWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/image1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: h * 0.3,
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 50.0,
                    width: 0.8 * w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/search.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        //chưa làm
                        const Text('Sign up with Goole'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 0.8 * w,
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Name User',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Icon(Icons.tag_faces_sharp),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 0.8 * w,
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Icon(Icons.email),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 0.8 * w,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      obscuringCharacter: '*',
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Passworld',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Icon(Icons.key),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.1,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                          onTap: register,
                          child: Container(
                            height: 50,
                            width: 0.8 * w,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Color.fromARGB(255, 58, 152, 228),
                            ),
                            child: const Center(
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                  // Container(
                  //   height: 50,
                  //   width: 0.8 * w,
                  //   decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(30),
                  //     ),
                  //     color: Color.fromARGB(255, 58, 152, 228),
                  //   ),
                  //   child: const Center(
                  //     child: Text(
                  //       'Sign up',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 15,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
