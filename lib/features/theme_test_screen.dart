import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/auth_button.dart';

class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            const Text('Plain text with no style'),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                errorText:
                    'Email not verified, please verify your email first.',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, child: const Text('Login')),
            const SizedBox(height: 16),
            OutlinedButton(

              onPressed: () {},
              child: const Text('Continue with Google'),
            ),
            AuthButton(text: 'Login', onPressed: () {}),
            AuthButton(text: 'Login', onPressed: () {}, isLoading: true),
            AuthButton(text: 'Login', onPressed: null),
          ],
        ),
      ),
    );
  }
}
