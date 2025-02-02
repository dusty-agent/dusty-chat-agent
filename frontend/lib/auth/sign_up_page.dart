import 'package:flutter/material.dart';
import 'package:dusty_chat_agent/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isAgreed = false; // ✅ 개인정보 동의 체크 여부
  bool _isNotRobot = false; // ✅ 로봇이 아님 체크 여부
  bool _isSigningUp = false; // ✅ 로딩 상태

  /// 🚀 **로봇이 아님 체크 팝업**
  void _showRecaptchaPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로봇이 아닙니다 확인"),
          content: Text("체크박스를 눌러 로봇이 아님을 증명하세요."),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => _isNotRobot = true);
                Navigator.pop(context);
              },
              child: Text("✅ 확인"),
            ),
          ],
        );
      },
    );
  }

  /// 🚀 **회원가입 요청**
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isAgreed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("개인정보 수집에 동의해주세요.")));
      return;
    }
    if (!_isNotRobot) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("로봇이 아님을 인증하세요.")));
      return;
    }

    setState(() => _isSigningUp = true);

    try {
      bool success = await AuthService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("회원가입 성공! 로그인해주세요.")));
        Navigator.pushReplacementNamed(context, '/login'); // 로그인 페이지로 이동
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("회원가입 실패! 다시 시도하세요.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("오류 발생: $e")));
    }

    setState(() => _isSigningUp = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🚀 **이메일 입력 필드**
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "이메일"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "이메일을 입력하세요.";
                  if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value)) {
                    return "유효한 이메일 주소를 입력하세요.";
                  }
                  return null;
                },
              ),

              /// 🚀 **비밀번호 입력 필드**
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "비밀번호"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "비밀번호를 입력하세요.";
                  if (value.length < 8) return "비밀번호는 최소 8자 이상이어야 합니다.";
                  if (!RegExp(
                          r"^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).{8,}$")
                      .hasMatch(value)) {
                    return "비밀번호는 대문자, 숫자, 특수문자를 포함해야 합니다.";
                  }
                  return null;
                },
              ),

              /// 🚀 **비밀번호 확인 필드**
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: "비밀번호 확인"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "비밀번호 확인을 입력하세요.";
                  if (value != _passwordController.text)
                    return "비밀번호가 일치하지 않습니다.";
                  return null;
                },
              ),

              /// 🚀 **개인정보 수집 동의 체크박스**
              CheckboxListTile(
                title: Text("개인정보 수집에 동의합니다."),
                value: _isAgreed,
                onChanged: (value) =>
                    setState(() => _isAgreed = value ?? false),
              ),

              /// 🚀 **로봇이 아닙니다 체크**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("로봇이 아닙니다", style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.check_circle,
                        color: _isNotRobot ? Colors.green : Colors.grey),
                    onPressed: _showRecaptchaPopup,
                  ),
                ],
              ),

              /// 🚀 **회원가입 버튼**
              ElevatedButton(
                onPressed: _isSigningUp ? null : _signUp,
                child:
                    _isSigningUp ? CircularProgressIndicator() : Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
