import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }

          setState(() {
            _isLoading = state is AuthLoading;
          });
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Icon
                      Icon(
                        Icons.people,
                        size: AppSize.iconXLarge,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: AppSize.md),

                      // Title
                      Text(
                        l10n.login, // 'Đăng nhập' or 'Login'
                        style: AppTextStyles.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSize.sm),
                      Text(
                        l10n.signInContinue ?? 'Sign in to continue',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSize.sm),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        labelText: l10n.email,
                        hintText: l10n.enterYourEmail ?? 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: Validators.email,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: AppSize.md),

                      // Password Field
                      PasswordTextField(
                        controller: _passwordController,
                        labelText: l10n.password,
                        hintText:
                            l10n.enterYourPassword ?? 'Enter your password',
                        textInputAction: TextInputAction.done,
                        validator: (value) => Validators.required(
                          value,
                          fieldName: l10n.password,
                        ),
                      ),
                      const SizedBox(height: AppSize.sm),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  // TODO: Navigate to forgot password
                                },
                          child: Text(l10n.forgotPassword),
                        ),
                      ),
                      const SizedBox(height: AppSize.lg),

                      // Login Button
                      CustomButton(
                        text: l10n.login,
                        onPressed: _isLoading ? null : _handleLogin,
                        isLoading: _isLoading,
                        icon: Icons.login,
                      ),
                      const SizedBox(height: AppSize.lg),

                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSize.md,
                            ),
                            child: Text(
                              l10n.or ?? 'OR',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppSize.lg),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.dontHaveAccount ?? "Don't have an account? ",
                            style: AppTextStyles.bodyMedium,
                          ),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => context.push(AppRoutes.register),
                            child: Text(l10n.register),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
