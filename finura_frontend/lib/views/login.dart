import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.green[100], // Fixed invalid shade
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                const Text(
                  'Finura',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'increase your financial aura',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  //textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadiusDirectional.only(
                        topStart: Radius.circular(8.0),
                        topEnd: Radius.circular(50.0),
                        bottomStart: Radius.circular(50.0),
                        bottomEnd: Radius.circular(8.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 70),

                          TextField(
                            controller: accountController,
                            decoration: const InputDecoration(
                              labelText: 'Account name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: pinController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter PIN',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('Forget PIN?'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Register Now'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement login logic
                              },
                              child: const Text('Login'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
