import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/routing/app_routes_constants.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:chat_bot_demo/utils/custom_icons.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:chat_bot_demo/widgets/primary_button.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String username = '';
  String pass = '';
  String repeatPass = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listenWhen: (prev, curr) {
      return prev.status.isSubmissionInProgress &&
          (curr.status.isSubmissionSuccess || curr.status.isSubmissionFailure);
    }, listener: (context, state) {
      if (state.status.isSubmissionFailure) {
        CustomSnackBar.show(
          context,
          state.error!,
          isError: true,
        );
      } else if (state.status.isSubmissionSuccess) {
        Navigator.pushNamed(context, kAuthenticate);
      }
    }, builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
            leadingWidth: 10 + Constants.kHorScreenPadding,
            leading: Row(
              children: [
                const SizedBox(
                  width: Constants.kHorScreenPadding,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    CustomIcons.carretLeft,
                  ),
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.kHorScreenPadding,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Image.asset(
                    CustomIcons.signUpImage,
                    height: 145,
                  ),
                  const SizedBox(height: 50),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // USERNAME
                        SizedBox(
                          height: 80,
                          child: TextFormField(
                            cursorColor: CustomColors.lightGray,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                defaultFormFieldStyle(label: 'Enter email'),
                            validator: (String? val) {
                              return val == null ||
                                      val.isEmpty ||
                                      !EmailValidator.validate(val)
                                  ? 'Please enter a valid email'
                                  : null;
                            },
                            onChanged: (String val) {
                              setState(() {
                                username = val;
                              });
                            },
                          ),
                        ),

                        // PASSWORD
                        SizedBox(
                          height: 80,
                          child: TextFormField(
                            cursorColor: CustomColors.lightGray,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                defaultFormFieldStyle(label: 'Enter password'),
                            validator: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'Please enter a password';
                              }

                              if (val.length < 8) {
                                return 'Password must be at least 8 chars long';
                              }

                              return null;
                            },
                            onChanged: (String val) {
                              setState(() {
                                pass = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CONFIRM PASSWORD
                  SizedBox(
                    height: 80,
                    child: TextFormField(
                      cursorColor: CustomColors.lightGray,
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          defaultFormFieldStyle(label: 'Confirm password'),
                      validator: (String? val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter a password';
                        }

                        if (val.length < 8) {
                          return 'Password must be at least 8 chars long';
                        }

                        if (val != pass) {
                          return 'Passwords must be the same';
                        }

                        return null;
                      },
                      onChanged: (String val) {
                        setState(() {
                          repeatPass = val;
                        });
                      },
                    ),
                  ),

                  // SIGN UP BUTTON
                  PrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        getIt.get<AuthenticationBloc>().add(
                              AuthenticationSignedUp(
                                username: username,
                                password: pass,
                              ),
                            );
                      }
                    },
                    leadingIcon: state.status.isSubmissionInProgress
                        ? const CupertinoActivityIndicator()
                        : null,
                    text: state.status.isSubmissionInProgress ? '' : 'Sign Up',
                    backgroundColor: state.status.isSubmissionInProgress
                        ? CustomColors.gray
                        : CustomColors.green,
                  ),
                  const SizedBox(height: 16),

                  // SIGN IN BUTTON
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: EasyRichText(
                      "Already have an account? *Sign In*",
                      defaultStyle: const TextStyle(
                        color: CustomColors.gray,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      patternList: [
                        EasyRichTextPattern(
                          // matches anything that is between *
                          // (e.g. This is *matched* but this is not)
                          targetString: '(\\*)(.*?)(\\*)',
                          matchBuilder: (
                            BuildContext context,
                            RegExpMatch? match,
                          ) {
                            return TextSpan(
                              text: match?[0]?.replaceAll('*', ''),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: CustomColors.salmon,
                                decoration: TextDecoration.underline,
                                decorationColor: CustomColors.salmon,
                                decorationThickness: 0.5,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
