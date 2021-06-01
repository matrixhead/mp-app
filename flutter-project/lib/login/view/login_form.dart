import 'package:flutter/material.dart';
import 'package:mpapp/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _UserNameInput(),
          const Padding(padding: EdgeInsets.all(20)),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(20)),
          _LoginButton(_formKey)
        ],
      ),
    );
  }
}

class _UserNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          border: UnderlineInputBorder(), hintText: 'Enter Username ...'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Username';
        }
        return null;
      },
      onChanged: (username) =>
          context.read<LoginBloc>().add(LoginUsernameChanged(username)),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Enter Password ...',
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Password';
        }
        return null;
      },
      onChanged: (password) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(password)),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton(
    this._formKey,
  );

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {context.read<LoginBloc>().add(const LoginSubmitted())}
                },
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: StadiumBorder(),
                    minimumSize: Size(double.infinity, 60),
                    primary: Colors.black),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
      },
    );
  }
}
