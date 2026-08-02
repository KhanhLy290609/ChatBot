import React, { useState } from 'react';
import { CAREER_CARDS } from '../data/careerCards';
import { Search, Award, MessageSquare, Building2, Banknote, Sparkles } from 'lucide-react';

export default function CareerExplorerSection({ onAskAboutCareer }) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedBlock, setSelectedBlock] = useState('ALL');

  const filteredCareers = CAREER_CARDS.filter((card) => {
    const matchesSearch =
      card.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      card.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
      card.colleges.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesBlock = selectedBlock === 'ALL' || card.block.includes(selectedBlock);

    return matchesSearch && matchesBlock;
  });

  const handleCardClick = (card) => {
    const promptMessage = `Nhờ EduPath AI tư vấn chuyên sâu về ngành **${card.title}** (Khối thi ${card.block}).\n` +
      `- Mô tả: ${card.description}\n` +
      `- Chi tiết về điểm chuẩn những năm gần đây, cơ hội việc làm thực tế và danh sách các trường đào tạo uy tín hàng đầu?`;
    
    onAskAboutCareer(promptMessage);
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
      {/* Search & Filter Header */}
      <div
        style={{
          background: 'var(--bg-glass)',
          backdropFilter: 'blur(8px)',
          border: '1px solid var(--bg-glass-border)',
          borderRadius: 'var(--radius-lg)',
          padding: '1.25rem 1.5rem',
          boxShadow: 'var(--shadow-sm)',
          display: 'flex',
          flexDirection: 'column',
          gap: '1rem'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '0.75rem' }}>
          <div>
            <h2 style={{ fontSize: '1.25rem', fontWeight: 800, display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <Award className="text-indigo" size={22} />
              Tra Cứu Danh Mục Ngành Học Hot Tại Việt Nam
            </h2>
            <p style={{ fontSize: '0.85rem', color: 'var(--text-muted)' }}>
              Khám phá tổ hợp môn xét tuyển, mức lương tham khảo và các trường Đại học đào tạo tốt nhất.
            </p>
          </div>

          <div style={{ position: 'relative', width: '100%', maxWidth: '300px' }}>
            <Search size={18} style={{ position: 'absolute', left: '12px', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-muted)' }} />
            <input
              type="text"
              className="text-input"
              style={{ paddingLeft: '2.4rem', height: '40px' }}
              placeholder="Tìm tên ngành, từ khóa..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
        </div>

        {/* Subject Block Filter */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem', flexWrap: 'wrap' }}>
          <span style={{ fontSize: '0.85rem', fontWeight: 600, color: 'var(--text-secondary)' }}>Lọc khối thi:</span>
          {['ALL', 'A00', 'A01', 'B00', 'C00', 'D01', 'D07'].map((block) => (
            <button
              key={block}
              className={`nav-tab-btn ${selectedBlock === block ? 'active' : ''}`}
              style={{ padding: '0.3rem 0.75rem', fontSize: '0.8rem' }}
              onClick={() => setSelectedBlock(block)}
            >
              {block === 'ALL' ? 'Tất cả khối' : `Khối ${block}`}
            </button>
          ))}
        </div>
      </div>

      {/* Cards Grid */}
      <div className="careers-grid">
        {filteredCareers.map((card) => (
          <div key={card.id} className="career-card">
            <div>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                <span className="badge badge-emerald">{card.hotLevel}</span>
                <span style={{ fontSize: '0.75rem', fontWeight: 600, color: 'var(--brand-primary)', background: 'var(--bg-tertiary)', padding: '0.2rem 0.5rem', borderRadius: 'var(--radius-sm)' }}>
                  Khối {card.block}
                </span>
              </div>

              <h3 style={{ fontSize: '1.1rem', fontWeight: 700, marginBottom: '0.4rem', color: 'var(--text-primary)' }}>
                {card.title}
              </h3>
              <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)', marginBottom: '1rem', lineClamp: 2 }}>
                {card.description}
              </p>

              <div style={{ display: 'flex', flexDirection: 'column', gap: '0.4rem', fontSize: '0.8rem', color: 'var(--text-secondary)', marginBottom: '1.25rem' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                  <Banknote size={15} color="var(--accent-emerald)" />
                  <span><strong>Lương:</strong> {card.salary}</span>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                  <Building2 size={15} color="var(--brand-primary)" />
                  <span><strong>Trường:</strong> {card.colleges}</span>
                </div>
              </div>
            </div>

            <button
              className="btn-primary"
              style={{ width: '100%', fontSize: '0.85rem', padding: '0.6rem' }}
              onClick={() => handleCardClick(card)}
            >
              <Sparkles size={16} />
              Hỏi AI Chi Tiết Ngành Này
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
