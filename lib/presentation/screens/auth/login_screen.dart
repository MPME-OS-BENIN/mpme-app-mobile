import 'package:flutter/material.dart';
import 'package:mpme_app_mobile/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:mpme_app_mobile/presentation/navigation/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.tertiaryBg,
        title: Text(
          'MPME OS',
          style: TextStyle(color: AppColors.primaryAlt,
          fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.question_mark,
            color: AppColors.primaryAlt,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.volume_up,
              color: AppColors.primaryAlt,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 360,
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFDBFFF0),
                        Color(0xFFFFF2E6),
                        Color(0xFFFFEFE0),
                      ],
                      stops: [
                        0.0,
                        0.60,
                        1.0,
                      ],
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final imageWidth = constraints.maxWidth > 454
                          ? 430.0
                          : constraints.maxWidth - 24;

                      return Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Image.asset(
                            'assets/img/Hero_Visual_Section.png',
                            width: imageWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    height: 360,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      color: AppColors.white,
                    ),
                    
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text('Connexion',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              
                            ),),
                            Text('Entrez votre numero pour\n commencer'),
                            SizedBox(height: 30,),
                            Text('Numero de téléphone', 
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(color: Color(0xFFBDCABE),
                                  width: 2.0
                                  ),
                                  
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(color: Color(0xFFBDCABE),
                                  width: 2.0
                                  ),
                                  
                                ),
                                prefixText: '+229 ',
                                hintText: '0190045678',
                              ),
                            ),
                            SizedBox(height: 10,),
                            Opacity(opacity: 0.8,
                            child:Text('Un code OTP vous sera envoye par sms',
                            style:TextStyle(fontStyle: FontStyle.italic,
                            color: AppColors.black),
                            ),
                            ),
                            SizedBox(height: 30,),
                            ElevatedButton(
                              onPressed: (){
                                Navigator.pushReplacementNamed(context, AppRoutes.codeOTP);

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryAlt,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Recevoir le code',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward,
                                  color: AppColors.white,
                                  size: 20,
                            
                                  ),
                                ],
                              )

                            ),
                            
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
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
                            color: AppColors.white,
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
              ),
              SizedBox(height: 32),

            ],
          ),
        ),
      ),
        
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.tertiaryBg,
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
                    color: AppColors.black,
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      'Aide audio',
                      style: TextStyle(
                        color: AppColors.black,
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
                      color: AppColors.black,
                    ),
                    Text(
                      'Retour',
                      style: TextStyle(
                        color: AppColors.black,
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
