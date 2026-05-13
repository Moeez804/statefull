import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ================= HOME SCREEN =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String countryName = '';
  String currencyCode = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCountryData();
  }

  Future<void> loadCountryData() async {
    try {
      final data = await ApiService.getCountryData();

      setState(() {
        countryName = data['country_name'];
        currencyCode = data['currency'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        countryName = 'Pakistan';
        currencyCode = 'PKR';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo.shade700,
                  Colors.indigo.shade400,
                  Colors.blue.shade300,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : double.infinity,
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.currency_exchange,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 20),
        const Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Real-time exchange rates',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 60),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.currency_exchange,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Currency Converter',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Real-time exchange rates',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Your Location Info',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 20),
        _buildInfoCard(
          icon: Icons.location_on,
          title: 'Country',
          value: countryName,
          color: Colors.indigo,
        ),
        const SizedBox(height: 15),
        _buildInfoCard(
          icon: Icons.attach_money,
          title: 'Currency',
          value: currencyCode,
          color: Colors.green,
        ),
        const SizedBox(height: 30),
        _buildGradientButton(
          text: 'Open Converter',
          icon: Icons.swap_horiz,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CurrencyScreen(currencyCode: currencyCode),
              ),
            );
          },
          color: Colors.indigo,
        ),
        const SizedBox(height: 15),
        _buildGradientButton(
          text: 'AI Assistant',
          icon: Icons.chat_bubble_outline,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatScreen(),
              ),
            );
          },
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CURRENCY SCREEN =================

class CurrencyScreen extends StatefulWidget {
  final String currencyCode;

  const CurrencyScreen({super.key, required this.currencyCode});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController amountController = TextEditingController();
  double result = 0;
  bool isLoading = false;
  double exchangeRate = 0;

  @override
  void initState() {
    super.initState();
    loadExchangeRate();
  }

  Future<void> loadExchangeRate() async {
    setState(() {
      isLoading = true;
    });
    try {
      final rate = await ApiService.getExchangeRate(widget.currencyCode);
      setState(() {
        exchangeRate = rate;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Failed to load exchange rate');
    }
  }

  Future<void> convertCurrency() async {
    if (amountController.text.isEmpty) return;

    final amount = double.tryParse(amountController.text);
    if (amount == null) return;

    setState(() {
      result = amount * exchangeRate;
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('Currency Converter'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 800 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 40 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Exchange Rate',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isLoading ? 'Loading...' : '1 USD = ${exchangeRate.toStringAsFixed(2)} ${widget.currencyCode}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Enter Amount (USD)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.attach_money, color: Colors.indigo),
                          hintText: '0.00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            convertCurrency();
                          } else {
                            setState(() {
                              result = 0;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (result > 0)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green.shade600, Colors.green.shade400],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Converted Amount',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${result.toStringAsFixed(2)} ${widget.currencyCode}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'USD ${amountController.text}',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
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
        },
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}

// ================= AI CHAT SCREEN =================

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Hello! 👋 I'm your AI assistant. How can I help you with currency conversion today?",
      isUser: false,
    ));
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final aiResponse = await ApiService.getAIResponse(userMessage);
      setState(() {
        _messages.add(ChatMessage(text: aiResponse, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "I'm here to help! Please try asking about currency conversion, exchange rates, or how to use the app. 💱",
          isUser: false,
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text('AI Assistant'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(ChatMessage(
                  text: "Chat cleared! How can I help you with currency conversion? 💬",
                  isUser: false,
                ));
              });
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          
          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 1000 : double.infinity,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index];
                      },
                    ),
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.indigo.shade600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'AI is thinking...',
                                  style: TextStyle(color: Colors.indigo.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  _buildInputArea(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask about currency, exchange rates...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade600, Colors.indigo.shade400],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Chat Message Widget
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [Colors.indigo.shade600, Colors.indigo.shade400],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade200],
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(5),
            bottomRight: isUser ? const Radius.circular(5) : const Radius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// ================= API SERVICE =================

class ApiService {
  static const String _geminiApiKey = "AIzaSyAsy1imVnBzb2BxaHMokUkPovjF94s-0Fo";

  // FIXED: Country API without CORS issues - Using ip-api.com
  static Future<Map<String, dynamic>> getCountryData() async {
    try {
      // ip-api.com supports CORS and works with Flutter Web
      final response = await http.get(Uri.parse('https://ip-api.com/json/'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'country_name': data['country'] ?? 'Pakistan',
          'currency': _getCurrencyFromCountryCode(data['countryCode'] ?? 'PK'),
        };
      } else {
        // Fallback if API fails
        return {
          'country_name': 'Pakistan',
          'currency': 'PKR',
        };
      }
    } catch (e) {
      print('Country API error: $e');
      // Fallback values
      return {
        'country_name': 'Pakistan',
        'currency': 'PKR',
      };
    }
  }

  // Helper to get currency from country code
  static String _getCurrencyFromCountryCode(String countryCode) {
    final Map<String, String> currencies = {
      'US': 'USD', 'PK': 'PKR', 'IN': 'INR', 'GB': 'GBP', 
      'EU': 'EUR', 'CA': 'CAD', 'AU': 'AUD', 'JP': 'JPY',
      'CN': 'CNY', 'AE': 'AED', 'SA': 'SAR', 'SG': 'SGD',
      'DE': 'EUR', 'FR': 'EUR', 'IT': 'EUR', 'ES': 'EUR',
      'MX': 'MXN', 'BR': 'BRL', 'ZA': 'ZAR', 'RU': 'RUB',
      'KR': 'KRW', 'TR': 'TRY', 'CH': 'CHF', 'SE': 'SEK',
    };
    return currencies[countryCode] ?? 'USD';
  }

  // Exchange rate API - Working fine
  static Future<double> getExchangeRate(String currencyCode) async {
    final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/USD'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rate = data['rates'][currencyCode];
      if (rate == null) {
        throw Exception('Currency not supported');
      }
      return (rate as num).toDouble();
    } else {
      throw Exception('Exchange API failed');
    }
  }

  static Future<String> getAIResponse(String userMessage) async {
    // If no API key is configured, use fallback responses
    if (_geminiApiKey == "AIzaSyAsy1imVnBzb2BxaHMokUkPovjF94s-0Fo" || _geminiApiKey.isEmpty) {
      return _getFallbackResponse(userMessage);
    }

    try {
      // Using the correct model name: gemini-1.5-flash
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiApiKey'
      );
      
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': userMessage}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 800,
        },
      };
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          return _getFallbackResponse(userMessage);
        }
      } else {
        // If API fails, return fallback response
        print('Gemini API Error Status: ${response.statusCode}');
        return _getFallbackResponse(userMessage);
      }
    } catch (e) {
      print('Gemini API Error: $e');
      return _getFallbackResponse(userMessage);
    }
  }

  // Fallback responses that work without API key
  static String _getFallbackResponse(String message) {
    String lowerMsg = message.toLowerCase();
    
    if (lowerMsg.contains('hi') || lowerMsg.contains('hello')) {
      return "Hello! 👋 Welcome to Currency Converter! I'm your AI assistant.\n\nYou can:\n• Convert USD to your local currency\n• Check exchange rates\n• Learn about different currencies\n\nHow can I help you today?";
    }
    else if (lowerMsg.contains('how are you')) {
      return "I'm doing great, thanks for asking! Ready to help with your currency needs! 💱";
    }
    else if (lowerMsg.contains('currency') || lowerMsg.contains('convert')) {
      return "To convert currency:\n\n1. Tap 'Open Converter' on the home screen\n2. Enter the amount in USD\n3. The conversion happens automatically!\n\nTry it now! 💰";
    }
    else if (lowerMsg.contains('rate') || lowerMsg.contains('exchange')) {
      return "Exchange rates update regularly from a reliable API. The rates are real-time and accurate! 📊\n\nCurrent rates show how much 1 USD is worth in other currencies.";
    }
    else if (lowerMsg.contains('pkr') || lowerMsg.contains('pakistan') || lowerMsg.contains('rupee')) {
      return "🇵🇰 Pakistani Rupee (PKR) is the currency of Pakistan.\n\nYou can convert USD to PKR using the Currency Converter. The exchange rate updates automatically!";
    }
    else if (lowerMsg.contains('usd') || lowerMsg.contains('dollar')) {
      return "💵 USD (US Dollar) is the base currency in this app.\n\nEnter any amount in USD to convert to your local currency. It's that simple!";
    }
    else if (lowerMsg.contains('euro') || lowerMsg.contains('eur')) {
      return "🇪🇺 Euro (EUR) is the currency of the European Union.\n\nYou can convert USD to EUR using the Currency Converter feature!";
    }
    else if (lowerMsg.contains('thank')) {
      return "You're very welcome! 😊 Glad I could help! Is there anything else you'd like to know about currency conversion?";
    }
    else if (lowerMsg.contains('bye') || lowerMsg.contains('goodbye')) {
      return "Goodbye! 👋 Come back anytime you need currency conversion. Have a great day!";
    }
    else {
      return "I'm your currency assistant! 💱\n\nI can help you with:\n• Converting USD to your currency\n• Understanding exchange rates\n• Using the converter tool\n\nWhat would you like to know about currency conversion?";
    }
  }
}