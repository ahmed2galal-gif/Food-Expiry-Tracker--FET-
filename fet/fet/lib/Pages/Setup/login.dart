import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';

import '../../app.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email, password;
  final FocusNode emailNode = FocusNode(), passwordNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future get login async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        startLoading(context);
        var result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: password!);

        endLoading(context);

        if (result.user != null) {
          startLoading(context);

          currentUser = await UserModel.fromId(result.user!.uid);
          endLoading(context);

          if (currentUser != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Home()),
              (routes) => false,
            );
          }
        }
      } catch (e) {
        print(e);
        endLoading(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var emailAddress = TextFormField(
      focusNode: emailNode,
      onFieldSubmitted: (text) =>
          FocusScope.of(context).requestFocus(passwordNode),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (text) {
        if ((text?.isEmpty ?? false) ||
            !(text?.contains("@") ?? false) ||
            !(text?.contains(".") ?? false)) {
          return "Please enter a valid email";
        }

        email = text!;
      },
      decoration: InputDecoration(
        hintText: "Email Address",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        fillColor: accentColor.withOpacity(0.3),
        filled: true,
        prefixIcon: const Icon(FontAwesomeIcons.envelope, size: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

    var passwordWidget = TextFormField(
      focusNode: passwordNode,
      onFieldSubmitted: (text) => FocusManager.instance.primaryFocus?.unfocus(),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.done,
      obscureText: true,
      validator: (text) {
        if ((text?.isEmpty ?? false) || (text?.length ?? 0) < 8) {
          return "Password should be more than 8 characters";
        }

        password = text!;
      },
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        fillColor: accentColor.withOpacity(0.3),
        filled: true,
        prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

    var button = MaterialButton(
      color: primaryColor,
      onPressed: () => login,
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );

    var textButton = TextButton(
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Register())),
      child: Text(
        "Create Account",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black.withOpacity(0.6),
        ),
      ),
    );

    var logo = Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/logo.png",
        width: MediaQuery.of(context).size.width / 2,
      ),
    );

    var title = Text(
      "Welcome Back",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: MediaQuery.of(context).size.width / 12,
      ),
    );

    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                logo,
                const SizedBox(height: 80),
                title,
                const SizedBox(height: 40),
                emailAddress,
                const SizedBox(height: 20),
                passwordWidget,
                const SizedBox(height: 60),
                button,
                textButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
