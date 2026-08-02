import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoleplaySimulationWidget extends StatefulWidget {
  final Function(String) onSendToChat;
  final Color primaryColor;
  final String language;
  final String apiKey;

  const RoleplaySimulationWidget({
    super.key,
    required this.onSendToChat,
    this.primaryColor = const Color(0xFF6366F1),
    this.language = 'vi',
    required this.apiKey,
  });

  @override
  State<RoleplaySimulationWidget> createState() =>
      _RoleplaySimulationWidgetState();
}

class _RoleplaySimulationWidgetState extends State<RoleplaySimulationWidget> {
  final TextEditingController _careerInputController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _scenarioData;
  String? _selectedOptionId;

  static const List<Map<String, String>> _presetCareersVi = [
    {'title': 'Lập trình viên AI', 'icon': '💻'},
    {'title': 'Bác sĩ Cấp cứu', 'icon': '🩺'},
    {'title': 'Marketing Director', 'icon': '📊'},
    {'title': 'Luật sư Tranh tụng', 'icon': '⚖️'},
    {'title': 'Thiết kế UI/UX', 'icon': '🎨'},
    {'title': 'Kinh doanh / Startup', 'icon': '🚀'},
  ];

  static const List<Map<String, String>> _presetCareersEn = [
    {'title': 'AI Software Engineer', 'icon': '💻'},
    {'title': 'ER Doctor', 'icon': '🩺'},
    {'title': 'Marketing Director', 'icon': '📊'},
    {'title': 'Trial Lawyer', 'icon': '⚖️'},
    {'title': 'UI/UX Designer', 'icon': '🎨'},
    {'title': 'Startup Founder', 'icon': '🚀'},
  ];

  static const Map<String, dynamic> _fallbackScenarioVi = {
    'nganh_nghe': 'Lập trình viên AI',
    'tieu_de_tinh_huong': '🔥 Đột phá Hệ thống lúc 2h Sáng!',
    'noi_dung_tinh_huong':
        'Chỉ 30 phút trước giờ ra mắt sản phẩm cho 100.000 người dùng, hệ thống AI của bạn bị sập do quá tải và xuất hiện lỗ hổng bảo mật nghiêm trọng. Giám đốc Công ty đang liên tục gọi điện hối thúc.',
    'cau_hoi': 'Bạn sẽ xử lý tình huống áp lực này như thế nào?',
    'cac_lua_chon': [
      {
        'id': 'A',
        'noi_dung': 'Bình tĩnh kiểm tra Log, khôi phục bản sao lưu an toàn và hoãn ra mắt 15 phút để vá lỗ hổng.',
        'phan_tich_tinh_cach': 'Bạn là người cẩn trọng, kỷ luật và coi trọng quy trình an toàn chuẩn mực.',
        'danh_gia_phu_hop': 'Cách xử lý này cho thấy bạn có 90% tố chất phù hợp với ngành, vì sự điềm tĩnh và chính xác là chìa khóa của một Kỹ sư phần mềm giỏi.'
      },
      {
        'id': 'B',
        'noi_dung': 'Viết vội một đoạn script giải pháp tạm thời (hotfix) để mở hệ thống ngay lập tức rồi sửa sau.',
        'phan_tich_tinh_cach': 'Bạn là người thiên về linh hoạt, chấp nhận rủi ro và ưu tiên tiến độ công việc.',
        'danh_gia_phu_hop': 'Cách xử lý này cho thấy bạn có 75% tố chất phù hợp, giúp giải quyết việc gấp nhưng có thể để lại nợ kỹ thuật.'
      },
      {
        'id': 'C',
        'noi_dung': 'Gọi điện giải thích rõ ràng với Giám đốc và đội ngũ Marketing để đưa ra thông báo minh bạch cho khách hàng.',
        'phan_tich_tinh_cach': 'Bạn là người giao tiếp tốt, thấu cảm và coi trọng sự tin cậy trong làm việc nhóm.',
        'danh_gia_phu_hop': 'Cách xử lý này cho thấy bạn có 85% tố chất phù hợp, rất tố cho vai trò Quản lý dự án công nghệ.'
      },
      {
        'id': 'D',
        'noi_dung': 'Phân tích dữ liệu băng thông, cắt bỏ tính năng AI phụ để tập trung tài nguyên cho tính năng chính.',
        'phan_tich_tinh_cach': 'Bạn là người tư duy logic, thực dụng và giỏi tối ưu hóa tài nguyên dưới áp lực.',
        'danh_gia_phu_hop': 'Cách xử lý này cho thấy bạn có 95% tố chất phù hợp với ngành Kỹ thuật AI hiện đại.'
      }
    ]
  };

  @override
  void dispose() {
    _careerInputController.dispose();
    super.dispose();
  }

  Future<void> _generateSimulation(String careerName) async {
    if (careerName.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _scenarioData = null;
      _selectedOptionId = null;
    });

    final isEn = widget.language == 'en';
    final systemPrompt = isEn
        ? '''You are a Senior Career Counseling Expert and a Roleplay Master.
Your mission is to help high school students experience "A Day In The Job" of a specific career: {$careerName} through a realistic, high-pressure, and industry-specific crisis situation.

CRITICAL OUTPUT FORMAT:
You MUST respond ONLY with valid JSON, with NO surrounding markdown or explanations outside the JSON object. Use this exact structure:
{
  "nganh_nghe": "$careerName",
  "tieu_de_tinh_huong": "Short sensational title (e.g. 'Crisis at 2 AM!')",
  "noi_dung_tinh_huong": "Detailed context (3-4 sentences) describing the user's role and the crisis.",
  "cau_hoi": "How would you handle this situation?",
  "cac_lua_chon": [
    {
      "id": "A",
      "noi_dung": "Action description for option A",
      "phan_tich_tinh_cach": "You lean towards...",
      "danh_gia_phu_hop": "This choice shows you have [X]% aptitude suitability for the career, because..."
    },
    {
      "id": "B",
      "noi_dung": "Action description for option B",
      "phan_tich_tinh_cach": "You lean towards...",
      "danh_gia_phu_hop": "This choice shows you have [Y]% aptitude suitability for the career, because..."
    },
    {
      "id": "C",
      "noi_dung": "Action description for option C",
      "phan_tich_tinh_cach": "You lean towards...",
      "danh_gia_phu_hop": "This choice shows you have [Z]% aptitude suitability for the career, because..."
    },
    {
      "id": "D",
      "noi_dung": "Action description for option D",
      "phan_tich_tinh_cach": "You lean towards...",
      "danh_gia_phu_hop": "This choice shows you have [W]% aptitude suitability for the career, because..."
    }
  ]
}'''
        : '''Bạn là một Chuyên gia Tư vấn Hướng nghiệp cấp cao và là một Bậc thầy Tạo Tình huống (Roleplay Master). 
Nhiệm vụ của bạn là giúp học sinh cấp 3 trải nghiệm "một ngày làm nghề" của ngành nghề: {$careerName} thông qua một tình huống thực tế, có tính áp lực và đặc thù cao của ngành đó.

[QUY TẮC TẠO TÌNH HUỐNG]
1. KHÔNG miêu tả ngành nghề một cách nhàm chán.
2. Đưa thẳng người dùng vào một "Nút thắt" hoặc "Khủng hoảng nhỏ" thực tế nhất mà người làm nghề này phải đối mặt thường xuyên. 
3. Tình huống phải đủ khó để thấy được áp lực của nghề, không chỉ có màu hồng.
4. Đưa ra 4 phương án giải quyết (A, B, C, D) đại diện cho các nét tính cách/cách làm việc khác nhau (Cẩn trọng/Sáng tạo/Giao tiếp/Logic).
5. Chuẩn bị sẵn lời nhận xét (Feedback) phân tích mức độ phù hợp nghề nghiệp cho từng sự lựa chọn.

[ĐỊNH DẠNG ĐẦU RA BẮT BUỘC]
Bạn CHỈ ĐƯỢC PHÉP trả về kết quả dưới định dạng JSON hợp lệ, không kèm theo bất kỳ văn bản giải thích nào khác bên ngoài khối JSON. Sử dụng chính xác cấu trúc sau:

{
  "nganh_nghe": "$careerName",
  "tieu_de_tinh_huong": "Một tiêu đề ngắn gọn, giật gân (VD: 'Khủng hoảng lúc 2h sáng!')",
  "noi_dung_tinh_huong": "Mô tả chi tiết bối cảnh, vai trò của người dùng và vấn đề đang xảy ra (khoảng 3-4 câu).",
  "cau_hoi": "Bạn sẽ xử lý tình huống này như thế nào?",
  "cac_lua_chon": [
    {
      "id": "A",
      "noi_dung": "Mô tả hành động của phương án A",
      "phan_tich_tinh_cach": "Bạn là người thiên về...",
      "danh_gia_phu_hop": "Cách xử lý này cho thấy bạn có [X]% tố chất phù hợp với ngành, vì..."
    },
    {
      "id": "B",
      "noi_dung": "Mô tả hành động của phương án B",
      "phan_tich_tinh_cach": "Bạn là người thiên về...",
      "danh_gia_phu_hop": "Cách xử lý này cho thấy bạn có [Y]% tố chất phù hợp với ngành, vì..."
    },
    {
      "id": "C",
      "noi_dung": "Mô tả hành động của phương án C",
      "phan_tich_tinh_cach": "Bạn là người thiên về...",
      "danh_gia_phu_hop": "Cách xử lý này cho thấy bạn có [Z]% tố chất phù hợp với ngành, vì..."
    },
    {
      "id": "D",
      "noi_dung": "Mô tả hành động của phương án D",
      "phan_tich_tinh_cach": "Bạn là người thiên về...",
      "danh_gia_phu_hop": "Cách xử lý này cho thấy bạn có [W]% tố chất phù hợp với ngành, vì..."
    }
  ]
}''';

    try {
      final candidateModels = [
        'gemini-3.6-flash',
        'gemini-2.0-flash',
        'gemini-flash-latest',
      ];

      http.Response? response;
      for (final model in candidateModels) {
        final url = Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${widget.apiKey}');
        final res = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': systemPrompt}
                ]
              }
            ]
          }),
        );
        if (res.statusCode == 200) {
          response = res;
          break;
        }
      }

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String rawText =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '';

        // Extract JSON string inside code blocks if any
        if (rawText.contains('```json')) {
          rawText = rawText.split('```json').last.split('```').first;
        } else if (rawText.contains('```')) {
          rawText = rawText.split('```').last.split('```').first;
        }

        final parsed = jsonDecode(rawText.trim()) as Map<String, dynamic>;
        setState(() {
          _scenarioData = parsed;
        });
      } else {
        setState(() {
          _scenarioData = _fallbackScenarioVi;
        });
      }
    } catch (e) {
      debugPrint('Roleplay generation error: $e');
      setState(() {
        _scenarioData = _fallbackScenarioVi;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = widget.primaryColor;
    final isEn = widget.language == 'en';
    final presets = isEn ? _presetCareersEn : _presetCareersVi;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      children: [
        // Header Input Banner
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      primary.withValues(alpha: 0.3),
                      primary.withValues(alpha: 0.15)
                    ]
                  : [
                      primary.withValues(alpha: 0.06),
                      primary.withValues(alpha: 0.14)
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: primary.withValues(alpha: isDark ? 0.4 : 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.theater_comedy,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn ? 'A Day In The Job' : 'Trải Nghiệm Một Ngày Làm Nghề',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        Text(
                          isEn
                              ? 'Roleplay realistic career crises'
                              : 'Giải quyết tình huống thực tế & áp lực',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade400
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _careerInputController,
                      decoration: InputDecoration(
                        hintText: isEn
                            ? 'Enter any career (e.g. AI Engineer)...'
                            : 'Nhập tên ngành (VD: Bác sĩ, Marketing)...',
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                      onSubmitted: _generateSimulation,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                    onPressed: () =>
                        _generateSimulation(_careerInputController.text),
                    child: Text(
                      isEn ? 'Simulate' : 'Trải Nghiệm',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Presets Chips
              Text(
                isEn ? 'Quick Select:' : 'Gợi ý trải nghiệm nhanh:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey.shade300 : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presets.map((p) {
                  return ActionChip(
                    avatar: Text(p['icon']!),
                    label: Text(p['title']!),
                    backgroundColor: isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    side: BorderSide(
                        color: primary.withValues(alpha: 0.25)),
                    onPressed: () {
                      _careerInputController.text = p['title']!;
                      _generateSimulation(p['title']!);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Loading State
        if (_isLoading)
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            child: Column(
              children: [
                CircularProgressIndicator(color: primary),
                const SizedBox(height: 16),
                Text(
                  isEn
                      ? '🤖 AI is crafting a high-pressure career scenario...'
                      : '🤖 Trợ lý AI đang tạo tình huống khủng hoảng thực tế...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),

        // Scenario Display Card
        if (!_isLoading && _scenarioData != null) ...[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: primary.withValues(alpha: isDark ? 0.4 : 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag & Title
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    '🎬 ${_scenarioData!['nganh_nghe'] ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _scenarioData!['tieu_de_tinh_huong'] ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _scenarioData!['noi_dung_tinh_huong'] ?? '',
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.55,
                    color:
                        isDark ? Colors.grey.shade300 : const Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  _scenarioData!['cau_hoi'] ??
                      (isEn
                          ? 'How would you handle this situation?'
                          : 'Bạn sẽ xử lý tình huống này như thế nào?'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Option Choices
                ...(_scenarioData!['cac_lua_chon'] as List? ?? []).map((opt) {
                  final option = opt as Map<String, dynamic>;
                  final id = option['id'] as String;
                  final isSelected = _selectedOptionId == id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedOptionId = id;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withValues(alpha: isDark ? 0.25 : 0.1)
                              : (isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF8FAFC)),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? primary
                                : (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFE2E8F0)),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: isSelected ? primary : Colors.grey.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      id,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    option['noi_dung'] ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Analysis & Suitability Feedback when Selected
                            if (isSelected) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.psychology,
                                            size: 18, color: Colors.amber),
                                        const SizedBox(width: 6),
                                        Text(
                                          isEn
                                              ? 'Personality Analysis:'
                                              : 'Phân Tích Tính Cách:',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['phan_tich_tinh_cach'] ?? '',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.verified,
                                            size: 18, color: primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          isEn
                                              ? 'Aptitude Suitability:'
                                              : 'Mức Độ Phù Hợp Nghề:',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option['danh_gia_phu_hop'] ?? '',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                if (_selectedOptionId != null) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      isEn
                          ? 'Discuss Choices With AI Assistant'
                          : 'Thảo Luận Lựa Chọn Này Với AI Assistant',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final chosenOpt =
                          (_scenarioData!['cac_lua_chon'] as List).firstWhere(
                        (o) => o['id'] == _selectedOptionId,
                        orElse: () => {},
                      );
                      widget.onSendToChat(
                        isEn
                            ? 'I just experienced a realistic crisis scenario for **${_scenarioData!['nganh_nghe']}**: "${_scenarioData!['tieu_de_tinh_huong']}".\nI chose Option **$_selectedOptionId**: "${chosenOpt['noi_dung']}".\nCan you analyze deeper into this career\'s stress points and future outlook?'
                            : 'Tớ vừa tham gia trải nghiệm tình huống thực tế của ngành **${_scenarioData!['nganh_nghe']}**: "${_scenarioData!['tieu_de_tinh_huong']}".\nTớ chọn Phương án **$_selectedOptionId**: "${chosenOpt['noi_dung']}".\nNhờ EduPath AI phân tích sâu hơn về áp lực thực tế và lộ trình phát triển của ngành này!',
                      );
                    },
                  ),
                ]
              ],
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}
