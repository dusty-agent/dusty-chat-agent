import 'package:dusty_chat_agent/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PricingPage extends StatelessWidget {
  Future<void> upgradeToPremium() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Firestore에서 사용자 플랜 변경
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'plan': 'premium'});

    // 유료 결제 로직 (추후 Stripe, Google Play Billing 추가)
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      titleText: 'Upgrade to Premium',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Upgrade to Premium for Unlimited Access!",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: upgradeToPremium,
              child: Text("Upgrade Now"),
            ),
          ],
        ),
      ),
    );
  }
}
