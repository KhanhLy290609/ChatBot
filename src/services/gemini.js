/**
 * Gemini API Service - EduPath AI
 * Handles API calls to Gemini 1.5 Flash model with system prompt for THPT career counseling.
 */

const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

const SYSTEM_PROMPT = `
Bạn là "EduPath AI" - Chuyên gia Tư vấn Hướng nghiệp và Chọn ngành Đại học dành riêng cho học sinh THPT (lớp 10, 11, 12) tại Việt Nam.

Nhiệm vụ chính của bạn:
1. Tư vấn định hướng ngành học phù hợp với tính cách, sở thích, lực học và các tổ hợp môn thi (A00, A01, B00, C00, D01, D07,...).
2. Cung cấp thông tin chính xác về các ngành học hot tại Việt Nam, nhu cầu thị trường lao động, mức lương khởi điểm tham khảo và danh sách các trường Đại học uy tín (ví dụ: Bách Khoa, Quốc Gia, Ngoại Thương, Kinh Tế Quốc Dân, Y Hà Nội, Y Dược TP.HCM, FPT...).
3. Phân tích điểm mạnh, điểm yếu và gợi ý lộ trình ôn thi/chuẩn bị kỹ năng từ cấp 3.
4. Trả lời thân thiện, truyền cảm hứng, thấu hiểu áp lực thi cử của học sinh THPT.

Quy tắc trình bày:
- Trả lời hoàn toàn bằng tiếng Việt chuẩn.
- Sử dụng định dạng Markdown rõ ràng (dùng danh sách gạch đầu dòng, từ khóa in đậm, bảng so sánh nếu cần).
- Nếu câu hỏi chưa đủ thông tin (vd: học sinh chưa nói học khối gì hay thích gì), hãy chủ động đặt 2-3 câu hỏi gợi mở ngắn gọn.
`;

/**
 * Sends messages history to Gemini API and returns generated response text.
 * @param {Array<{role: string, content: string}>} messagesHistory 
 * @param {string} apiKey 
 * @returns {Promise<string>}
 */
export async function sendChatMessage(messagesHistory, apiKey) {
  if (!apiKey || apiKey.trim() === '') {
    throw new Error('MISSING_API_KEY');
  }

  // Format contents for Gemini API API payload
  const contents = messagesHistory.map(msg => ({
    role: msg.role === 'user' ? 'user' : 'model',
    parts: [{ text: msg.content }]
  }));

  const payload = {
    system_instruction: {
      parts: [{ text: SYSTEM_PROMPT }]
    },
    contents: contents,
    generationConfig: {
      temperature: 0.7,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 2048,
    }
  };

  try {
    const response = await fetch(`${GEMINI_API_URL}?key=${apiKey.trim()}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      if (response.status === 400 || response.status === 401) {
        throw new Error('INVALID_API_KEY');
      } else if (response.status === 429) {
        throw new Error('RATE_LIMIT');
      } else {
        throw new Error(errorData.error?.message || `Lỗi kết nối máy chủ (${response.status})`);
      }
    }

    const data = await response.json();
    const botText = data.candidates?.[0]?.content?.parts?.[0]?.text;

    if (!botText) {
      throw new Error('AI không phản hồi nội dung. Vui lòng thử lại!');
    }

    return botText;
  } catch (error) {
    console.error('Gemini Service Error:', error);
    throw error;
  }
}
