import 'package:flutter/material.dart';
import 'package:pages/Authentication/Sign_up.dart';
import 'package:pages/home.dart';
import 'package:pages/services/authenticate.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

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
        title: Text('Sign In'),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0,bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: null,
                        child: Text("*Forgot Password*",
                          style: TextStyle(fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () async{
                    bool condition=await signIn(email.text,password.text);
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
                  child: Text("Log in"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an Account ? "),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return SignUp();
                              }));
                        },
                        child: Text("Sign Up",
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
