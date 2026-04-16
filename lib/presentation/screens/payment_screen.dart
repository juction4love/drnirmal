import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final Function(String transactionId) onSuccess;

  const PaymentScreen({super.key, required this.amount, required this.onSuccess});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Khalti'; // Optimized for Nepal [cite: 2026-03-30]
  bool _isProcessing = false;

  Future<void> _handlePayment() async {
    setState(() => _isProcessing = true);
    
    // Simulate real SDK bridge delay (e.g., waiting for Khalti OTP or eSewa Login)
    await Future.delayed(const Duration(seconds: 2));

    // Specific Nepal-style transaction IDs [cite]
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String txnPrefix = _selectedMethod == 'Khalti' ? 'KLT' : 'ESW';
    final String mockTransactionId = "${txnPrefix}_$timestamp";

    if (mounted) {
      widget.onSuccess(mockTransactionId);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Digital Payment (Nepal)"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildAmountSummary(),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft, 
              child: Text("Select Local Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
            ),
            const SizedBox(height: 16),
            
            // Nepal-Specific Methods [cite]
            _buildBrandTile("Khalti", "Khalti Wallet / MBanking", Colors.deepPurple, Icons.account_balance_wallet),
            _buildBrandTile("eSewa", "eSewa Digital Wallet", Colors.green, Icons.wallet_membership),
            _buildBrandTile("IME_Pay", "IME Pay (Mobile Wallet)", Colors.red, Icons.payments_outlined),
            
            const Spacer(),
            _isProcessing 
              ? const CircularProgressIndicator(color: Color(0xFF003D80))
              : ElevatedButton(
                  onPressed: _handlePayment,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: _getMethodColor(_selectedMethod),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  child: Text("Secure Paywith $_selectedMethod", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
            const SizedBox(height: 12),
            const Text("Your payment is secured by standard local encryption.", style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF003D80), Color(0xFF001F40)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const Text("TOTAL CONSULTATION FEE", style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 11)),
          const SizedBox(height: 8),
          Text("NPR ${widget.amount}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildBrandTile(String id, String label, Color color, IconData icon) {
    bool isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? color : Colors.grey.shade200, width: isSelected ? 2.5 : 1),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? color.withValues(alpha: 0.05) : Colors.white,
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'Khalti': return Colors.deepPurple;
      case 'eSewa': return Colors.green;
      case 'IME_Pay': return Colors.red;
      default: return const Color(0xFF003D80);
    }
  }
}
