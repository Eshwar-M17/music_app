import 'package:c_lient/core/utils/utils.dart';
import 'package:c_lient/core/widgets/loader.dart';
import 'package:c_lient/features/auth/view/pages/sign_up_page.dart';
import 'package:c_lient/features/auth/view/widgets/custom_button.dart';
import 'package:c_lient/core/widgets/custom_text_field.dart';
import 'package:c_lient/features/auth/view/widgets/page_navigator_text.dart';
import 'package:c_lient/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(
      authViewModelProvider.select((val) {
        return val?.isLoading == true;
      }),
    );

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, "sucessfull");
          print(data.toString());
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Loader()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign In.",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          SizedBox(height: 15),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                            isObscure: true,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            buttonText: "Sign In",
                            onTap: () async {
                              print("clicked sign in");
                              if (formKey.currentState!.validate()) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .signIn(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          const PageNavigatorText(
                            lable1: "Don't have an account? ",
                            lable2: "Sign Up",
                            pageWidget: SignUpPage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
