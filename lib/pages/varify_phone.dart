import 'dart:ui';

import 'package:costumer/helpers/create_me.dart';
import 'package:costumer/helpers/replace_numbers.dart';
import 'package:costumer/pages/check_page.dart';
import 'package:costumer/pages/models/swep_languages.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:provider/provider.dart';

import '../controllers/Vehicle_tybe_controller.dart';
import '../helpers/error_snack.dart';
import '../helpers/gradiant_text.dart';

import 'models/db.dart';

class Varify extends StatefulWidget {
  const Varify({Key? key}) : super(key: key);

  @override
  State<Varify> createState() => _SignUpState();
}

class _SignUpState extends State<Varify> {
  bool account = false;
  bool isPhoneFiled=false;
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  bool val = true;
   bool _onEditing = true;
  @override
  Widget build(BuildContext context) {
    if (!val) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(fit: StackFit.expand,
          children: [
                Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height+30,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            ),
         
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !isPhoneFiled,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: MediaQuery.of(context).size.height / 16,
                    child: 
                    TextField(
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.white,
                      style:  TextStyle(color: Colors.white),
                      controller: phone,
                      decoration: InputDecoration(
                        label: Row(
                          mainAxisAlignment: context.watch<VehicleTypeController>().la
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                         
                          ],
                        ),
                        prefix: CountryCodePicker(
                          textStyle:  TextStyle(color: Colors.white),
                          onChanged: print,
                          initialSelection: '+966',
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1.0,color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0),
                        ),
                      ),
                    ),
                               
                  ),
                ),
                

                Visibility(
                  visible: isPhoneFiled,
                  
                  child: VerificationCode(
                    cursorColor: Colors.white,
                    fullBorder: true,
            textStyle: TextStyle(fontSize: 20.0, color: Colors.white),
            keyboardType: TextInputType.number,
            underlineColor:  Theme.of(context)
                                                .colorScheme
                                                .secondary, // If this is null it will use primaryColor: Colors.red from Theme
            length: 4,
            // cursorColor: Colors.blue, // If this is null it will default to the ambient
            // clearAll is NOT required, you can delete it
            // takes any widget, so you can implement your design
            clearAll: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.redo,color: Colors.white,)
            ),
            onCompleted: (String value) {
              setState(() {
              });
            },
            onEditing: (bool value) {
              setState(() {
                _onEditing = value;
              });
              if (!_onEditing) FocusScope.of(context).unfocus();
            },
          ),),
                
                _getActionButtons()
              ],
            ),
          languageWidget(context, Colors.white),

          // const Center(child: Text('dfa'),)
          ],
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top:18.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        height: MediaQuery.of(context).size.height / 16,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: RaisedButton(
                color: Colors.white,
                onPressed: () async {
                if(isPhoneFiled){
                  setState(() {
                      val = !val;
                    });
                    int check = await checkMe(
                        context, replaceArabicNumber(phone.text), account);

                    if (check == 0) {
                      setState(() {
                        val = !val;
                      });
                    }

                }else{
                    if (phone.text.length < 9) {
                    errono('Enter a valid phone number please !',
                        "أدخل رقم هاتف  صالح رجاء", context);
                  } else {
                    setState(() {
                      isPhoneFiled=!isPhoneFiled;
                    });
                  }
                }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                  child: Text(
                    context.watch<VehicleTypeController>().la == false
                        ? "Confirm"
                        : "تأكيد",
   
                    style:  TextStyle(color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                        fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
