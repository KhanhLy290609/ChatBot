import React, { useState } from 'react';
import { HOLLAND_QUESTIONS, HOLLAND_TYPES_INFO } from '../data/hollandQuiz';
import { Compass, CheckCircle2, RotateCcw, MessageSquarePlus, ArrowRight } from 'lucide-react';

export default function HollandQuizSection({ onSendQuizResultToChat }) {
  const [currentStep, setCurrentStep] = useState(0);
  const [answers, setAnswers] = useState({});
  const [isCompleted, setIsCompleted] = useState(false);

  const handleSelectOption = (type) => {
    const updatedAnswers = { ...answers, [currentStep]: type };
    setAnswers(updatedAnswers);

    if (currentStep < HOLLAND_QUESTIONS.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      setIsCompleted(true);
    }
  };

  const calculateResults = () => {
    const counts = { R: 0, I: 0, A: 0, S: 0, E: 0, C: 0 };
    Object.values(answers).forEach((type) => {
      if (counts[type] !== undefined) counts[type]++;
    });

    const sortedTypes = Object.keys(counts).sort((a, b) => counts[b] - counts[a]);
    const topTypeKey = sortedTypes[0];
    return {
      topTypeKey,
      topTypeInfo: HOLLAND_TYPES_INFO[topTypeKey],
      scores: counts
    };
  };

  const handleReset = () => {
    setAnswers({});
    setCurrentStep(0);
    setIsCompleted(false);
  };

  const handleAskAI = () => {
    const { topTypeInfo, topTypeKey } = calculateResults();
    const promptMessage = `Tớ vừa làm xong trắc nghiệm Holland và có kết quả nhóm tính cách nổi bật nhất là **${topTypeInfo.name} (${topTypeKey})**.\n` +
      `Mô tả: "${topTypeInfo.description}"\n\n` +
      `Nhờ EduPath AI phân tích chi tiết cho tớ các ngành học phù hợp nhất với nhóm tính cách này, các trường Đại học hàng đầu tại Việt Nam và lộ trình thi khối ngành tương ứng!`;
    
    onSendQuizResultToChat(promptMessage);
  };

  const currentQ = HOLLAND_QUESTIONS[currentStep];
  const progressPercent = ((currentStep + (isCompleted ? 1 : 0)) / HOLLAND_QUESTIONS.length) * 100;

  return (
    <div className="quiz-card">
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '1rem' }}>
        <h2 style={{ fontSize: '1.3rem', fontWeight: 800, display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Compass className="text-indigo" size={24} />
          Trắc Nghiệm Định Hướng Holland (6 Câu Hỏi)
        </h2>
        <span style={{ fontSize: '0.85rem', color: 'var(--text-muted)', fontWeight: 600 }}>
          {isCompleted ? "Hoàn thành!" : `Câu ${currentStep + 1} / ${HOLLAND_QUESTIONS.length}`}
        </span>
      </div>

      {/* Progress Bar */}
      <div className="quiz-progress-bar">
        <div className="quiz-progress-fill" style={{ width: `${progressPercent}%` }}></div>
      </div>

      {!isCompleted ? (
        <div>
          <h3 style={{ fontSize: '1.1rem', fontWeight: 700, marginBottom: '1.5rem', color: 'var(--text-primary)' }}>
            {currentQ.question}
          </h3>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
            {currentQ.options.map((opt, idx) => (
              <button
                key={idx}
                className="quiz-option-btn"
                onClick={() => handleSelectOption(opt.type)}
              >
                <span>{opt.text}</span>
                <ArrowRight size={16} color="var(--brand-primary)" />
              </button>
            ))}
          </div>
        </div>
      ) : (
        (() => {
          const { topTypeInfo, topTypeKey } = calculateResults();
          return (
            <div style={{ animation: 'fadeIn 0.3s ease' }}>
              <div
                style={{
                  background: 'linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.1) 100%)',
                  border: '1px solid var(--brand-primary)',
                  borderRadius: 'var(--radius-lg)',
                  padding: '1.5rem',
                  marginBottom: '1.5rem'
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', color: 'var(--brand-primary)', fontWeight: 700, marginBottom: '0.5rem' }}>
                  <CheckCircle2 size={22} />
                  <span>KẾT QUẢ ĐỊNH HƯỚNG HOLLAND CỦA BẠN</span>
                </div>
                <h3 style={{ fontSize: '1.4rem', fontWeight: 800, color: 'var(--text-primary)', marginBottom: '0.5rem' }}>
                  Mã Holland: <span style={{ color: 'var(--brand-primary)' }}>{topTypeKey}</span> - {topTypeInfo.name}
                </h3>
                <p style={{ color: 'var(--text-secondary)', marginBottom: '1rem' }}>
                  {topTypeInfo.description}
                </p>

                <h4 style={{ fontSize: '0.95rem', fontWeight: 700, color: 'var(--text-primary)', marginBottom: '0.5rem' }}>
                  Các nhóm ngành học gợi ý hàng đầu:
                </h4>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem' }}>
                  {topTypeInfo.majors.map((major, i) => (
                    <span key={i} className="badge badge-indigo" style={{ fontSize: '0.85rem', padding: '0.4rem 0.8rem' }}>
                      {major}
                    </span>
                  ))}
                </div>
              </div>

              <div style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap' }}>
                <button className="btn-primary" style={{ flex: 1 }} onClick={handleAskAI}>
                  <MessageSquarePlus size={18} />
                  Gửi Kết Quả Cho AI Chatbot Phân Tích Sâu
                </button>
                <button className="btn-secondary" onClick={handleReset}>
                  <RotateCcw size={16} /> Làm Lại Trắc Nghiệm
                </button>
              </div>
            </div>
          );
        })()
      )}
    </div>
  );
}
