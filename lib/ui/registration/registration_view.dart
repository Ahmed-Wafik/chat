import 'package:chat_with_friends/ui/registration/registration.dart';
import 'package:chat_with_friends/utils/validation.dart';
import 'package:flutter/material.dart';

class LogInView extends LogInPageState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //         colors: <Color>[Colors.blue, Colors.blue[700]],
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter)),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    formType == FormType.signUp
                        ? GestureDetector(
                            onTap: chooseImagePicker,
                            child: image == null
                                ? Container(
                                    width: 160,
                                    height: 160,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 60,
                                    ),
                                    // color: Color(0xFF778899),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        border: Border.all(
                                            color: Colors.purple, width: 2)),
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    // color: Color(0xFF778899),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(image),
                                            fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            color: Colors.purple, width: 2)),
                                  ),
                          )
                        : Container(),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          formType == FormType.signUp
                              ? TextFormField(
                                  validator: (value) =>
                                      ValidateInput.validateUsername(value),
                                  onSaved: (v) => userName = v,
                                  autofocus: false,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  focusNode: usernameNode,
                                  onFieldSubmitted: (term) => onFocusNodeChange(
                                      context, usernameNode, emailNode),
                                  decoration: InputDecoration(
                                      hintText: 'user name',
                                      icon: Icon(Icons.person)),
                                )
                              : Container(),
                          verticalBox(),
                          TextFormField(
                            validator: (value) =>
                                ValidateInput.validateEmail(value),
                            onSaved: (v) => email = v,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            focusNode: emailNode,
                            onFieldSubmitted: (term) => onFocusNodeChange(
                                context, emailNode, passwordNode),
                            decoration: InputDecoration(
                                hintText: 'e-mail', icon: Icon(Icons.email)),
                          ),
                          verticalBox(),
                          TextFormField(
                            autofocus: false,
                            obscureText: true,
                            controller: passwordController,
                            onSaved: (v) => password = v,
                            validator: (value) =>
                                ValidateInput.validatePassword(value),
                            textInputAction: formType == FormType.signUp
                                ? TextInputAction.next
                                : TextInputAction.done,
                            keyboardType: TextInputType.text,
                            focusNode: passwordNode,
                            onFieldSubmitted: (term) => onFocusNodeChange(
                                context, passwordNode, conformPassNode),
                            decoration: InputDecoration(
                                hintText: 'password',
                                icon: Icon(Icons.vpn_key)),
                          ),
                          verticalBox(),
                          formType == FormType.signUp
                              ? TextFormField(
                                  autofocus: false,
                                  obscureText: true,
                                  
                                  focusNode: conformPassNode,
                                  validator: (value) =>
                                      ValidateInput.validateConformPass(
                                          value, passwordController.text),
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'conform Password',
                                      icon: Icon(Icons.vpn_key)),
                                )
                              : Container(),
                          verticalBox(height: 20),
                          formType == FormType.signUp
                              ? buildRaisedButton('Sign Up')
                              : buildRaisedButton('Log In')
                        ],
                      ),
                    ),
                    verticalBox(height: 30),
                    formType == FormType.signUp
                        ? buildRow(context, 'Already have account?', 'LogIn',
                            moveTologIn)
                        : buildRow(
                            context, 'new user?', 'Sign Up', moveToSignUp),
                    verticalBox(),
                    SizedBox(
                        width: 35,
                        height: 35,
                        child:
                            loading ? CircularProgressIndicator() : Container())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  RaisedButton buildRaisedButton(String text) {
    return RaisedButton(
      onPressed: !loading ? submit : null,
      child: Text(text),
      color: Colors.purple,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      shape: StadiumBorder(),
    );
  }

  Row buildRow(
      BuildContext context, String fisrt, String second, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          fisrt,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
        SizedBox(
          width: 8,
        ),
        InkWell(
          child: Text(
            second,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(decoration: TextDecoration.underline),
          ),
          onTap: onTap,
        )
      ],
    );
  }

  SizedBox verticalBox({double height = 10}) => SizedBox(
        height: height,
      );
}
