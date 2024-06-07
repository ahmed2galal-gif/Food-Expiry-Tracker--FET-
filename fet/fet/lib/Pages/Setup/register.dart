import 'package:firebase_auth/firebase_auth.dart';

import '../../app.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Map<String, dynamic> user = {};
  final List<FocusNode> nodes = List.generate(4, (index) => FocusNode());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future get register async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        startLoading(context);
        var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: user["email"], password: user["password"]);

        endLoading(context);

        if (result.user != null) {
          startLoading(context);
          user.remove("password");

          user["id"] = result.user!.uid;
          user["createdAt"] = DateTime.now().toUtcMilliseconds;

          await FirebaseFirestore.instance
              .collection("users")
              .doc(result.user!.uid)
              .set(user);

          currentUser = await UserModel.fromId(result.user!.uid);

          endLoading(context);

          if (currentUser != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
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
    var name = TextFormField(
      focusNode: nodes[0],
      onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(nodes[1]),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (text) {
        if (text?.isEmpty ?? false) {
          return "Please enter you full name.";
        }

        user["fullName"] = text!;
      },
      decoration: InputDecoration(
        hintText: "Full Name",
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        fillColor: accentColor.withOpacity(0.3),
        filled: true,
        prefixIcon: const Icon(FontAwesomeIcons.person, size: 20),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );

    var emailAddress = TextFormField(
      focusNode: nodes[1],
      onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(nodes[2]),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (text) {
        if ((text?.isEmpty ?? false) ||
            !(text?.contains("@") ?? false) ||
            !(text?.contains(".") ?? false)) {
          return "Please enter a valid email";
        }

        user["email"] = text!;
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
      focusNode: nodes[2],
      onFieldSubmitted: (text) => FocusScope.of(context).requestFocus(nodes[3]),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.next,
      obscureText: true,
      validator: (text) {
        if ((text?.isEmpty ?? false) || (text?.length ?? 0) < 8) {
          return "Password should be more than 8 characters";
        }

        user["password"] = text!;
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

    var passwordConfirmWidget = TextFormField(
      focusNode: nodes[3],
      onFieldSubmitted: (text) => FocusManager.instance.primaryFocus?.unfocus(),
      onTapOutside: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      textInputAction: TextInputAction.done,
      obscureText: true,
      validator: (text) {
        if ((text?.isEmpty ?? false) || text != user["password"]) {
          return "Passwords doesn't match";
        }
      },
      decoration: InputDecoration(
        hintText: "Confirm password",
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
      onPressed: () => register,
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );

    var textButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        "Have an account?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.6),
        ),
      ),
    );

    var logo = Align(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/logo.png",
        width: MediaQuery.of(context).size.width / 3,
      ),
    );

    var title = Text(
      "Create Account",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: MediaQuery.of(context).size.width / 15,
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
                const SizedBox(height: 60),
                title,
                const SizedBox(height: 40),
                name,
                const SizedBox(height: 20),
                emailAddress,
                const SizedBox(height: 20),
                passwordWidget,
                const SizedBox(height: 20),
                passwordConfirmWidget,
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
