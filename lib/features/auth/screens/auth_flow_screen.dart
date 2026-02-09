import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';
import 'phone_number_screen.dart';

/// Entry point for the auth flow with ViewModel provider
class AuthFlowScreen extends StatelessWidget {
  const AuthFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthorizationViewModel(),
      child: const PhoneNumberScreen(),
    );
  }
}
