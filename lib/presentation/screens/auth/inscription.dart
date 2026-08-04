import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpme_app_mobile/core/constants/app_colors.dart';
import 'package:flutter/gestures.dart';
//import 'package:url_launcher/url_launcher.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _Inscription();
}

class _Inscription extends State<Inscription> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'MPME OS',
          style: TextStyle(
            color: AppColors.accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.question_mark, color: AppColors.accentColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.volume_up, color: AppColors.accentColor),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Opacity(
                          opacity: 0.8,
                          child: Text(
                            'Etape 1 sur 2',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        backgroundColor: Color(0xFF8DF8B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          'Profile Entrepreneur',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /*Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              width: 1000,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)
              ),
        
                          
              
        
              
            )*/
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(0.0),
                        height: 4,
                        decoration: BoxDecoration(color: Colors.green),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(0.0),
                        height: 4,
                        decoration: BoxDecoration(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    //color: Colors.green,
                    image: DecorationImage(
                      image: AssetImage('assets/img/illustration.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Inscription',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppColors.textColor,
                  ),
                ),

                SizedBox(height: 15),
                Opacity(
                  opacity: 0.8,
                  child: Text(
                    'Remplissez ces informations pour \ncommencer a gerer votre activite \n professionelle en tout simplicite',
                  ),
                ),

                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nom de famille',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-ZÀ-ÿ\s'-]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: "Ex: KOUANDETE",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Text('Prenom(s)',
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),),

                      SizedBox(height: 15,),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-ZÀ-ÿ\s'-]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: "Ex: Jean-Baptiste",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15,),

                      Text('Secteur d\'activite',
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),),

                      SizedBox(height: 15,),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-ZÀ-ÿ\s'-]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: "Choisissez votre secteur",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15,),

                      Text('Ville de résidence',
                      style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),),

                      SizedBox(height: 15,),

                      TextFormField(
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r"[a-zA-ZÀ-ÿ\s'-]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: "Ex: Cotonou",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFFBDCABE),
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),

                      
                    ],
                  ),
                ),

                SizedBox(height: 20),


               // Padding(
                //padding: const EdgeInsets.symmetric(horizontal: 18),
               // child: 
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFDDC6),
                      border: Border.all(color: Color(0xFFFF8E31), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFF954A00),
                          child: Icon(
                            Icons.record_voice_over,
                            color: AppColors.secondaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Besoin d\'aide ?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ecoutez les instructions pour vous connecter',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              //),

              SizedBox(height: 20),

              SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          minimumSize: Size(double.infinity, 56),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                          'Créer mon compte',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.secondaryColor,
                            ),
                          ],
                        )
                      ),
                    ),
                    SizedBox(height: 20),

                    Opacity(
                      opacity: 0.6,
                      child: Center(
                        child: Text.rich(TextSpan(
                          text:"En créant un compte, vous acceptez  ",
                          style: TextStyle(fontSize: 12, color: AppColors.textColor),
                          children:[
                            TextSpan(
                              text:"nos conditions d'utilisation",
                              style: TextStyle(color: AppColors.accentColor, fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              ),
                              recognizer:TapGestureRecognizer()..onTap=(){
                                debugPrint("Conditions d'utilisation");
                              }
                              
                            )
                          ]
                        ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),


      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.record_voice_over,
                    color: AppColors.textColor,
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      'Aide audio',
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8E31),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 22,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.textColor,
                    ),
                    Text(
                      'Retour',
                      style: TextStyle(
                        color: AppColors.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
