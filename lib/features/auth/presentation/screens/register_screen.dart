import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../bloc/auth_bloc.dart';

/// Register screen
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }

          setState(() {
            _isLoading = state is AuthLoading;
          });
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSize.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSize.lg),

                    // Title
                    Text(
                      l10n.createAccount,
                      style: AppTextStyles.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSize.md),
                    Text(
                      l10n.signUpContinue,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSize.xxxl),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: l10n.email,
                      hintText: l10n.enterYourEmail,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: AppSize.lg),

                    // Username Field
                    CustomTextField(
                      controller: _usernameController,
                      // There is no 'username' or 'chooseUsername' key in app_en.arb.
                      // Use literal fallback strings.
                      labelText: l10n.username,
                      hintText: l10n.chooseUsername,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: Validators.username,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: AppSize.lg),

                    // Password Field
                    PasswordTextField(
                      controller: _passwordController,
                      labelText: l10n.password,
                      hintText: l10n.createPassword,
                      textInputAction: TextInputAction.next,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppSize.lg),

                    // Confirm Password Field
                    PasswordTextField(
                      controller: _confirmPasswordController,
                      labelText: l10n.confirmPassword,
                      hintText: l10n.confirmYourPassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) => Validators.confirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Register Button
                    CustomButton(
                      text: l10n.signUp,
                      onPressed: _isLoading ? null : _handleRegister,
                      isLoading: _isLoading,
                      icon: Icons.person_add,
                    ),
                    const SizedBox(height: AppSize.lg),

                    // Terms and Privacy
                    Text(
                      l10n.termsAndPrivacyNote,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSize.lg),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
                          style: AppTextStyles.bodyMedium,
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : () => context.pop(),
                          child: Text(l10n.signIn),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
