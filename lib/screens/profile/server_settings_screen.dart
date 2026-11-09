import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/custom_button.dart';

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key});

  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  late TextEditingController _hostController;
  bool _isTesting = false;
  String? _testResult;
  bool? _testSuccess;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: ApiConfig.currentHost);
  }

  @override
  void dispose() {
    _hostController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = null;
    });

    final targetHost = _hostController.text.trim();
    final testUrl = 'http://$targetHost:${ApiConfig.port}/api/health';

    try {
      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _testSuccess = true;
          _testResult =
              'Connection Successful!\n'
              'Backend: ${data["app"]}\n'
              'Location: ${data["location"]}\n'
              'Timestamp: ${data["timestamp"]}';
        });
      } else {
        setState(() {
          _testSuccess = false;
          _testResult =
              'Server replied with status ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _testSuccess = false;
        _testResult =
            'Failed to connect to $testUrl.\n'
            'Please verify:\n'
            '1. Express backend is running on laptop (npm run dev)\n'
            '2. Phone and laptop are on the same Wi-Fi\n'
            '3. Windows Firewall allows inbound port 3000\n'
            'Error: ${e.toString()}';
      });
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _saveConfig() async {
    final host = _hostController.text.trim();
    await ApiConfig.updateHost(host);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved backend endpoint: ${ApiConfig.baseUrl}'),
        backgroundColor: AppColors.darkGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Backend Server Connection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Laptop IPv4 Host Address',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'On your laptop, run ipconfig in PowerShell to check Wi-Fi IPv4 address.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _hostController,
                    decoration: InputDecoration(
                      hintText: '192.168.0.109',
                      prefixIcon: const Icon(Icons.computer_rounded, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _hostController.text = '192.168.0.109';
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Wi-Fi Default (192.168.0.109)',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          _hostController.text = '10.0.2.2';
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Emulator (10.0.2.2)',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Active Base URL: http://${_hostController.text.trim()}:3000/api',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isTesting ? null : _testConnection,
                    icon: _isTesting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.network_check_rounded, size: 18),
                    label: const Text('Test Health API'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Save Endpoint',
                    height: 48,
                    onPressed: _saveConfig,
                  ),
                ),
              ],
            ),

            if (_testResult != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _testSuccess == true
                      ? AppColors.lightGreen
                      : AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _testSuccess == true
                        ? AppColors.primaryGreen
                        : AppColors.danger.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _testSuccess == true
                          ? Icons.check_circle_rounded
                          : Icons.error_outline_rounded,
                      color: _testSuccess == true
                          ? AppColors.darkGreen
                          : AppColors.danger,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _testResult!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _testSuccess == true
                              ? AppColors.darkGreen
                              : AppColors.danger,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Demonstration Guide Steps
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Physical Phone Demonstration Steps',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1. Connect laptop and Android phone to the same Wi-Fi network.',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '2. Open PowerShell on laptop and execute: ipconfig',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '3. Note your IPv4 Address (e.g. 192.168.0.109).',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '4. Start backend in terminal: cd parksyl_backend; npm run dev',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '5. Tap "Test Health API" above to verify direct connectivity!',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
