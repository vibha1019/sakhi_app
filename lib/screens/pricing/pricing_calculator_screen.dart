import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ── PUT YOUR API KEY HERE ──────────────────────
const String apiKey = 'i will put it later';
// ──────────────────────────────────────────────

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────

class AppColors {
  static const ink = Color(0xFF1A1A2E);
  static const inkLight = Color(0xFF2D2D44);
  static const accent = Color(0xFF4F46E5);
  static const accentSoft = Color(0xFFEEF2FF);
  static const accentMid = Color(0xFFE0E7FF);
  static const success = Color(0xFF059669);
  static const successSoft = Color(0xFFECFDF5);
  static const warn = Color(0xFFD97706);
  static const warnSoft = Color(0xFFFFFBEB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF8F7FF);
  static const border = Color(0xFFE8E8F0);
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFF9CA3AF);
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class AiPricingSuggestion {
  final double minimum;
  final double recommended;
  final double premium;
  final String reasoning;
  final List<String> factors;

  const AiPricingSuggestion({
    required this.minimum,
    required this.recommended,
    required this.premium,
    required this.reasoning,
    required this.factors,
  });

  factory AiPricingSuggestion.fromJson(Map<String, dynamic> json) {
    return AiPricingSuggestion(
      minimum: (json['minimum'] as num).toDouble(),
      recommended: (json['recommended'] as num).toDouble(),
      premium: (json['premium'] as num).toDouble(),
      reasoning: json['reasoning'] as String,
      factors: List<String>.from(json['factors'] as List),
    );
  }
}

// ─────────────────────────────────────────────
// AI SERVICE
// ─────────────────────────────────────────────

class AiPricingService {
  static const _endpoint = 'https://api.openai.com/v1/chat/completions';
  static const _model = 'gpt-4o';

  static Future<AiPricingSuggestion> getSuggestion({
    required String productType,
    required String location,
    required String qualityTier,
    required double materialCost,
    required double laborCost,
    required double totalCost,
  }) async {
    final prompt = '''
You are a pricing expert for small businesses and artisans in India.

Given the following details, suggest a fair price range in Indian Rupees (₹).

Product/Service: $productType
Location: $location
Quality tier: $qualityTier
Material cost: ₹${materialCost.toStringAsFixed(2)}
Labor cost: ₹${laborCost.toStringAsFixed(2)}
Total calculated cost (materials + labor + overhead): ₹${totalCost.toStringAsFixed(2)}

Respond ONLY with a valid JSON object — no markdown, no explanation outside JSON.

Format:
{
  "minimum": <number — lowest viable price, must cover all costs>,
  "recommended": <number — fair market price for this quality tier and location>,
  "premium": <number — price for a premium/luxury positioning>,
  "reasoning": "<2-3 sentences explaining why these prices are appropriate>",
  "factors": ["<factor 1>", "<factor 2>", "<factor 3>"]
}

All prices in ₹. Be realistic for the Indian market and the specified location.
''';

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 512,
        'messages': [
          {'role': 'system', 'content': 'You are a pricing expert. Always respond with valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
        'response_format': {'type': 'json_object'},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final content = (body['choices'] as List).first['message']['content'] as String;
    final clean = content.replaceAll(RegExp(r'```json|```'), '').trim();
    final json = jsonDecode(clean) as Map<String, dynamic>;
    return AiPricingSuggestion.fromJson(json);
  }
}

// ─────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────

class PricingCalculatorScreen extends StatefulWidget {
  const PricingCalculatorScreen({super.key});

  @override
  State<PricingCalculatorScreen> createState() => _PricingCalculatorScreenState();
}

class _PricingCalculatorScreenState extends State<PricingCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Step tracking
  int _currentStep = 0;

  // Controllers
  final _materialCostController = TextEditingController();
  final _laborHoursController = TextEditingController();
  final _hourlyRateController = TextEditingController(text: '50');
  final _overheadPercentController = TextEditingController(text: '20');
  final _profitMarginController = TextEditingController(text: '20');
  final _productTypeController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedQuality = 'Standard';
  static const _qualityOptions = ['Budget', 'Standard', 'Premium', 'Luxury'];

  Map<String, double>? _breakdown;
  AiPricingSuggestion? _aiSuggestion;
  bool _isAiLoading = false;
  String? _aiError;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _materialCostController.dispose();
    _laborHoursController.dispose();
    _hourlyRateController.dispose();
    _overheadPercentController.dispose();
    _profitMarginController.dispose();
    _productTypeController.dispose();
    _locationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    _fadeController.reverse().then((_) {
      setState(() => _currentStep = step);
      _fadeController.forward();
    });
  }

  void _calculateAndNext() {
    final materialCost = double.tryParse(_materialCostController.text) ?? 0;
    final laborHours = double.tryParse(_laborHoursController.text) ?? 0;
    final hourlyRate = double.tryParse(_hourlyRateController.text) ?? 50;
    final overheadPercent = double.tryParse(_overheadPercentController.text) ?? 20;
    final profitMargin = double.tryParse(_profitMarginController.text) ?? 20;

    final laborCost = laborHours * hourlyRate;
    final directCosts = materialCost + laborCost;
    final overheadAmount = directCosts * (overheadPercent / 100);
    final totalCosts = directCosts + overheadAmount;
    final profitAmount = totalCosts * (profitMargin / 100);
    final finalPrice = totalCosts + profitAmount;

    setState(() {
      _breakdown = {
        'materialCost': materialCost,
        'laborCost': laborCost,
        'directCosts': directCosts,
        'overheadAmount': overheadAmount,
        'totalCosts': totalCosts,
        'profitAmount': profitAmount,
        'finalPrice': finalPrice,
      };
    });
    _goToStep(1);
  }

  Future<void> _getAiSuggestion() async {
    if (_productTypeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a product or service type'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final materialCost = double.tryParse(_materialCostController.text) ?? 0;
    final laborHours = double.tryParse(_laborHoursController.text) ?? 0;
    final hourlyRate = double.tryParse(_hourlyRateController.text) ?? 50;
    final overheadPercent = double.tryParse(_overheadPercentController.text) ?? 20;
    final laborCost = laborHours * hourlyRate;
    final directCosts = materialCost + laborCost;
    final totalCost = directCosts * (1 + overheadPercent / 100);

    setState(() {
      _isAiLoading = true;
      _aiError = null;
      _aiSuggestion = null;
    });

    try {
      final suggestion = await AiPricingService.getSuggestion(
        productType: _productTypeController.text.trim(),
        location: _locationController.text.trim().isEmpty ? 'India' : _locationController.text.trim(),
        qualityTier: _selectedQuality,
        materialCost: materialCost,
        laborCost: laborCost,
        totalCost: totalCost,
      );
      setState(() => _aiSuggestion = suggestion);
      _goToStep(2);
    } catch (e) {
      setState(() => _aiError = e.toString());
    } finally {
      setState(() => _isAiLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceAlt,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _buildCurrentStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final titles = ['Cost calculator', 'Your price', 'AI market insights'];
    final subtitles = [
      'Enter your costs below',
      'Here\'s what you should charge',
      'See how the market prices your work',
    ];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          if (_currentStep > 0)
            GestureDetector(
              onTap: () => _goToStep(_currentStep - 1),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.textPrimary),
              ),
            )
          else
            const SizedBox(width: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titles[_currentStep], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.3)),
                Text(subtitles[_currentStep], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: List.generate(3, (i) {
          final active = i <= _currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 3,
                decoration: BoxDecoration(
                  color: active ? AppColors.accent : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep0();
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      default:
        return _buildStep0();
    }
  }

  // ── STEP 0: Cost Inputs ──────────────────────────

  Widget _buildStep0() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionLabel('What are your costs?'),
          const SizedBox(height: 12),
          _buildInputCard([
            _InputRow(controller: _materialCostController, label: 'Material cost', prefix: '₹', hint: '0', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          _buildSectionLabel('Your time'),
          const SizedBox(height: 12),
          _buildInputCard([
            _InputRow(controller: _laborHoursController, label: 'Hours worked', hint: '0', suffix: 'hrs', keyboardType: TextInputType.number),
            _InputRow(controller: _hourlyRateController, label: 'Your hourly rate', prefix: '₹', hint: '50', suffix: '/hr', keyboardType: TextInputType.number),
          ]),
          const SizedBox(height: 16),
          _buildSectionLabel('Business costs'),
          const SizedBox(height: 12),
          _buildInputCard([
            _InputRow(controller: _overheadPercentController, label: 'Overhead', hint: '20', suffix: '%', keyboardType: TextInputType.number, helpText: 'Rent, electricity, tools — usually 15–25%'),
            _InputRow(controller: _profitMarginController, label: 'Profit margin', hint: '20', suffix: '%', keyboardType: TextInputType.number, helpText: 'Your take-home after all costs — aim for 20–40%'),
          ]),
          const SizedBox(height: 28),
          _PrimaryButton(
            label: 'Calculate my price',
            onPressed: _calculateAndNext,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── STEP 1: Results ──────────────────────────────

  Widget _buildStep1() {
    final b = _breakdown!;
    final price = b['finalPrice']!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero price
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Charge this amount', style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 0.3)),
                const SizedBox(height: 8),
                Text(
                  '₹${price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -2),
                ),
                const SizedBox(height: 4),
                Text(
                  'includes your profit of ₹${b['profitAmount']!.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Breakdown
          _buildSectionLabel('Where does the money go?'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: [
                _BreakdownRow(label: 'Materials', amount: b['materialCost']!, color: const Color(0xFF3B82F6)),
                _BreakdownRow(label: 'Your labor', amount: b['laborCost']!, color: const Color(0xFF8B5CF6)),
                _BreakdownRow(label: 'Overhead', amount: b['overheadAmount']!, color: const Color(0xFFEC4899)),
                const _DividerRow(),
                _BreakdownRow(label: 'Total costs', amount: b['totalCosts']!, isBold: true, color: AppColors.textSecondary),
                _BreakdownRow(label: 'Your profit', amount: b['profitAmount']!, isBold: true, color: AppColors.success),
                const _DividerRow(),
                _BreakdownRow(label: 'Final price', amount: b['finalPrice']!, isBold: true, isLarge: true, color: AppColors.accent),
              ],
            ),
          ),
          const SizedBox(height: 28),

          _buildSectionLabel('Want to check the market rate?'),
          const SizedBox(height: 12),

          // AI inputs
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.accentMid, borderRadius: BorderRadius.circular(6)),
                      child: const Text('AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent)),
                    ),
                    const SizedBox(width: 8),
                    const Text('AI market comparison', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 16),
                _PlainTextField(controller: _productTypeController, label: 'What are you selling?', hint: 'e.g. handmade bag, pottery, tailoring'),
                const SizedBox(height: 12),
                _PlainTextField(controller: _locationController, label: 'Your city or region', hint: 'e.g. Mumbai, Jaipur, rural Karnataka'),
                const SizedBox(height: 16),
                const Text('Quality tier', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                _QualitySelector(
                  selected: _selectedQuality,
                  options: _qualityOptions,
                  onChanged: (v) => setState(() => _selectedQuality = v),
                ),
              ],
            ),
          ),

          if (_aiError != null) ...[
            const SizedBox(height: 12),
            _ErrorBanner(message: 'Could not get AI suggestions. Check your API key and connection.'),
          ],

          const SizedBox(height: 16),
          _PrimaryButton(
            label: _isAiLoading ? 'Getting AI insights…' : 'Get AI market insights',
            onPressed: _isAiLoading ? null : _getAiSuggestion,
            loading: _isAiLoading,
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── STEP 2: AI Results ───────────────────────────

  Widget _buildStep2() {
    final s = _aiSuggestion!;
    final myPrice = _breakdown?['finalPrice'];

    String comparisonText = '';
    Color comparisonColor = AppColors.success;
    if (myPrice != null) {
      if (myPrice < s.minimum) {
        comparisonText = 'Your calculated price is below the market minimum — consider charging more.';
        comparisonColor = AppColors.warn;
      } else if (myPrice > s.premium) {
        comparisonText = 'Your price is above the premium tier — make sure the quality justifies it.';
        comparisonColor = AppColors.accent;
      } else {
        comparisonText = 'Your price is within the healthy market range.';
        comparisonColor = AppColors.success;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Context chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.accentMid)),
            child: Text(
              '${_productTypeController.text}  ·  ${_locationController.text.isEmpty ? 'India' : _locationController.text}  ·  $_selectedQuality quality',
              style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Three tiers
          _buildSectionLabel('Market price range'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _TierCard(label: 'Minimum', amount: s.minimum, accentColor: const Color(0xFFD97706), bgColor: const Color(0xFFFFFBEB))),
              const SizedBox(width: 10),
              Expanded(
                child: _TierCard(
                  label: 'Recommended',
                  amount: s.recommended,
                  accentColor: AppColors.success,
                  bgColor: AppColors.successSoft,
                  highlighted: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _TierCard(label: 'Premium', amount: s.premium, accentColor: AppColors.accent, bgColor: AppColors.accentSoft)),
            ],
          ),
          const SizedBox(height: 20),

          // Your price vs market
          if (myPrice != null) ...[
            _buildCard(
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: comparisonColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your calculated price: ₹${myPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(comparisonText, style: TextStyle(fontSize: 12, color: comparisonColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Reasoning
          _buildSectionLabel('Why these prices'),
          const SizedBox(height: 12),
          _buildCard(
            child: Text(s.reasoning, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.55)),
          ),
          const SizedBox(height: 16),

          // Factors
          _buildSectionLabel('Factors considered'),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              children: s.factors.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_rounded, size: 16, color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4))),
                  ],
                ),
              )).toList(),
            ),
          ),

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => _goToStep(0),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Start a new calculation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Shared helpers ───────────────────────────────

  Widget _buildSectionLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 0.2));
  }

  Widget _buildInputCard(List<_InputRow> rows) {
    return _buildCard(
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              e.value,
              if (!isLast) const Divider(height: 24, color: AppColors.border),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// INPUT ROW
// ─────────────────────────────────────────────

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? prefix;
  final String? suffix;
  final String? helpText;
  final TextInputType keyboardType;

  const _InputRow({
    required this.controller,
    required this.label,
    required this.hint,
    this.prefix,
    this.suffix,
    this.helpText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                  if (helpText != null) ...[
                    const SizedBox(height: 2),
                    Text(helpText!, style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 110,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  prefixText: prefix,
                  suffixText: suffix,
                  prefixStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  suffixStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  hintText: hint,
                  hintStyle: const TextStyle(color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.surfaceAlt,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.8)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.8)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PLAIN TEXT FIELD
// ─────────────────────────────────────────────

class _PlainTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const _PlainTextField({required this.controller, required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            filled: true,
            fillColor: AppColors.surfaceAlt,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.8)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border, width: 0.8)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// QUALITY SELECTOR
// ─────────────────────────────────────────────

class _QualitySelector extends StatelessWidget {
  final String selected;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _QualitySelector({required this.selected, required this.options, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((tier) {
        final isSelected = selected == tier;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: tier != options.last ? 6 : 0),
            child: GestureDetector(
              onTap: () => onChanged(tier),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: isSelected ? 1.5 : 0.8),
                ),
                child: Text(
                  tier,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
// BREAKDOWN ROW
// ─────────────────────────────────────────────

class _BreakdownRow extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isBold;
  final bool isLarge;

  const _BreakdownRow({
    required this.label,
    required this.amount,
    required this.color,
    this.isBold = false,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(width: 3, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: TextStyle(fontSize: isLarge ? 15 : 14, fontWeight: isBold ? FontWeight.w600 : FontWeight.w400, color: AppColors.textPrimary)),
          ),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: isLarge ? 17 : 14, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}

class _DividerRow extends StatelessWidget {
  const _DividerRow();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 16, color: AppColors.border);
  }
}

// ─────────────────────────────────────────────
// TIER CARD
// ─────────────────────────────────────────────

class _TierCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color accentColor;
  final Color bgColor;
  final bool highlighted;

  const _TierCard({
    required this.label,
    required this.amount,
    required this.accentColor,
    required this.bgColor,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withOpacity(highlighted ? 0.5 : 0.2), width: highlighted ? 1.5 : 0.8),
      ),
      child: Column(
        children: [
          if (highlighted) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(6)),
              child: const Text('Best', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 6),
          ],
          Text(label, style: TextStyle(fontSize: 11, color: accentColor, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: TextStyle(fontSize: highlighted ? 19 : 16, fontWeight: FontWeight.w800, color: accentColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRIMARY BUTTON
// ─────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const _PrimaryButton({required this.label, required this.onPressed, this.loading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1)),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ERROR BANNER
// ─────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFECACA))),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE11D48), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13, color: Color(0xFFBE123C)))),
        ],
      ),
    );
  }
}