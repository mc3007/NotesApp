import 'package:flutter/material.dart';
import 'package:pages/Authentication/logIn.dart';
import 'package:pages/home.dart';
import 'package:pages/services/authenticate.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  var formKey=GlobalKey<FormState>();

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  String emailError='Enter your Email';
  String emailInvalidError='Enter a valid email';
  String passwordError='Enter Password';

  void clearText(){
    email.clear();
  }
  bool _obscureText= true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key:formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    // ignore: missing_return
                    validator: (String value) {
                      if(value.isEmpty){
                        return emailError;
                      }else if(value!=null){
                        if(!value.contains("@")){
                          return emailInvalidError;
                        }
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your Email',
                        suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: clearText),
                        errorStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: password,
                    // ignore: missing_return
                    validator: (String value) {
                      if(value.isEmpty){
                        return passwordError;
                      }
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                        suffixIcon: IconButton(
                            icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                            onPressed: (){
                              setState(() =>_obscureText=!_obscureText);
                            }),
                        errorStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () async{
                    bool condition=await signUp(email.text, password.text);
                    if(formKey.currentState.validate()) {
                      if(condition){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return HomePage();
                            }));
                      }
                    }
                  },
                  child: Text("Sign Up"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Already have an Account ? "),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LogIn();
                              }));
                        },
                        child: Text("Log In",
                          style:
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
