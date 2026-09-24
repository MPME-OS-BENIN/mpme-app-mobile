import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpme_app_mobile/core/theme/app_colors.dart';

class CodeOTP extends StatefulWidget {
  const CodeOTP({super.key});

  @override
  State<CodeOTP> createState() => _CodeOTPState();
}

class _CodeOTPState extends State<CodeOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tertiaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.tertiaryBg,
        title: Text(
          'MPME OS',
          style: TextStyle(
            color: AppColors.primaryAlt,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.question_mark, color: AppColors.primaryAlt),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.volume_up, color: AppColors.primaryAlt),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryAlt,
                      child: Icon(
                        Icons.lock,
                        size: 50,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Verification du code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                        fontSize: 23,
                      ),
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Veuillez saisir le code à 4 chiffres envoye au',
                      ),
                    ),
                    Text(
                      '+229 .. .. .. .. 78',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCF2E7),
                        border: Border.all(color: Color(0xFFBDCABE), width: 1),
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
                          SizedBox(width: 25),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ecouter les instructions',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF954A00),
                                  ),
                                ),
                                SizedBox(height: 4),

                                Opacity(
                                  opacity: 0.6,
                                  child: Text(
                                    'Appuyer ici pour de l\'aide audio ',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),

                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          height: 70,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            cursorColor: Color(0xFFBDCABE),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 60),

                        SizedBox(
                          width: 60,
                          height: 70,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            cursorColor: Color(0xFFBDCABE),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 60),

                        SizedBox(
                          width: 60,
                          height: 70,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            cursorColor: Color(0xFFBDCABE),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 60),

                        SizedBox(
                          width: 60,
                          height: 70,
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            cursorColor: Color(0xFFBDCABE),
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFBDCABE),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Text('Renvoyer le code dans'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '00:57',
                          style: TextStyle(color: Color(0xFF954A00)),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD6D3CE),
                          minimumSize: Size(double.infinity, 56),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23),
                          ),
                        ),
                        child: Text(
                          'Vérifier le code',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCF2E7),
                        border: Border.all(color: Color(0xFFBDCABE), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(12),

                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/img/Border.png'),
                              fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            
                            
                          ),

                          SizedBox(width: 30 ,),

                          Expanded(child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Securite MPME OS',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Opacity(opacity: 0.5,
                              child: Text('Ce code nous permet de confirmer votre identite professionelle en toute secuite',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          )
                          ),
                         
                        ],
                      ),

                    )
                  ],
                ),
              ),
            ),
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
