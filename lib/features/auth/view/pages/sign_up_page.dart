import 'package:c_lient/core/widgets/loader.dart';

import 'package:c_lient/features/auth/view/pages/login_page.dart';
import 'package:c_lient/features/auth/view/widgets/custom_button.dart';
import 'package:c_lient/core/widgets/custom_text_field.dart';
import 'package:c_lient/features/auth/view/widgets/page_navigator_text.dart';
import 'package:c_lient/features/auth/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:c_lient/core/utils/utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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
        data: (user) {
          showSnackBar(context, "account sucessfully created ,login now");

          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => LoginPage()));
        },
        error: (failure, trace) {
          showSnackBar(context, failure.toString());
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
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign Up.",
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          CustomTextField(
                            hintText: "Name",
                            controller: _nameController,
                          ),
                          SizedBox(height: 15),
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
                            buttonText: "Sign Up",
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                await ref
                                    .read(authViewModelProvider.notifier)
                                    .signUp(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          PageNavigatorText(
                            lable1: "Already have an account? ",
                            lable2: "Sign In",
                            pageWidget: LoginPage(),
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
