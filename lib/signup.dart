

import 'package:canton_design_system/canton_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'SignVerifivationMethods.dart';
import 'Widget/bezierContainer.dart';
import 'loginPage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key ?key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {int isPassword = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: isPassword==0?nom: isPassword==1?email:motDePasse,
              obscureText: isPassword==2,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)),
          isPassword==0?
          (this.afficherMessageErreurDansLeNom
              ? Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        "Nom non valide!",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ))
            ],
          )
              : Container()):
          isPassword==1?
          (this.afficherMessageErreurDansLeEmail
              ? Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        emailMsgErr,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ))
            ],
          )
              : Container())
              :
          (this.afficherMessageErreurDansLeMotDePasse
              ? Row(
            children: [
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        "Mot de passe non valide!",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ))
            ],
          )
              : Container())
        ],
      ),
    );
  }

  final email = TextEditingController(text: "");
  final motDePasse = TextEditingController(text: "");
  final nom = TextEditingController(text: "");
  String emailMsgErr="";

  bool afficherMessageErreurDansLeEmail=false;
  bool afficherMessageErreurDansLeMotDePasse=false;
  bool afficherMessageErreurDansLeNom = false;

  @override
  void initState() {
    super.initState();
    this.email.addListener(emailInputTextListener);
    this.motDePasse.addListener(motDePasseInputTextListener);
    this.nom.addListener(nomInputTextListener);
  }
  @override
  void dispose() {
    super.dispose();
    this.email.removeListener(emailInputTextListener);
    this.motDePasse.removeListener(motDePasseInputTextListener);
    this.nom.removeListener(nomInputTextListener);
  }
  void emailInputTextListener() {
    if (this.afficherMessageErreurDansLeEmail) {
      setState(() {
        this.afficherMessageErreurDansLeEmail = false;
      });
    }
  }
  void motDePasseInputTextListener() {
    if (this.afficherMessageErreurDansLeMotDePasse) {
      setState(() {
        this.afficherMessageErreurDansLeMotDePasse = false;
      });
    }
  }
  void nomInputTextListener() {
    if (this.afficherMessageErreurDansLeNom) {
      setState(() {
        this.afficherMessageErreurDansLeNom = false;
      });
    }
  }
  createUser(String email, String password) async {
    await Firebase.initializeApp();
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
    }).catchError((e) {
      setState(() {
        emailMsgErr=e.toString();
        this.afficherMessageErreurDansLeEmail = true;
      });
    });
  }
  Widget _submitButton() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue,Colors.blueAccent])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () {
        bool youCanTryToLogin = true;
        setState(() {
          email.text = email.text.trim();
          nom.text = nom.text.trim();
          this.email.selection = TextSelection.fromPosition(
              TextPosition(offset: this.email.text.length));
          this.nom.selection = TextSelection.fromPosition(
              TextPosition(offset: this.nom.text.length));
        });
        if (!SignVerificationMethods.isNameValid(nom.text)) {
          youCanTryToLogin = false;
          setState(() {
            this.afficherMessageErreurDansLeNom = true;
          });
        }
        if (!SignVerificationMethods.isEmailValid(email.text)) {
          youCanTryToLogin = false;
          emailMsgErr="email nom valid!";
          setState(() {
            this.afficherMessageErreurDansLeEmail = true;
          });
        }
        if (!SignVerificationMethods.isPasswordValid(motDePasse.text)) {
          youCanTryToLogin = false;
          setState(() {
            this.afficherMessageErreurDansLeMotDePasse = true;
          });
        }
        if (youCanTryToLogin) {
          createUser(email.text, motDePasse.text);
        }
      },
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'kh',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.blue
          ),
          children: [
            TextSpan(
              text: 'al',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'il',
              style: TextStyle(color: Colors.blue, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email", isPassword:  1),
        _entryField("Password", isPassword: 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
