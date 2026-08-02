import React from 'react';
import { GraduationCap, MessageSquare, Compass, Award, Key, Sun, Moon, Trash2 } from 'lucide-react';

export default function Header({ activeTab, setActiveTab, apiKey, openSettings, theme, toggleTheme, clearChat }) {
  const isKeyValid = Boolean(apiKey && apiKey.trim().length > 10);

  return (
    <header className="header-container">
      <div className="brand-logo">
        <div className="logo-icon">
          <GraduationCap size={26} />
        </div>
        <div>
          <h1 className="brand-title">EduPath AI</h1>
          <p className="brand-subtitle">Tư Vấn Hướng Nghiệp & Chọn Ngành THPT</p>
        </div>
      </div>

      <nav className="nav-tabs">
        <button
          className={`nav-tab-btn ${activeTab === 'chat' ? 'active' : ''}`}
          onClick={() => setActiveTab('chat')}
        >
          <MessageSquare size={16} />
          <span>Chatbot AI</span>
        </button>

        <button
          className={`nav-tab-btn ${activeTab === 'quiz' ? 'active' : ''}`}
          onClick={() => setActiveTab('quiz')}
        >
          <Compass size={16} />
          <span>Trắc Nghiệm Holland</span>
        </button>

        <button
          className={`nav-tab-btn ${activeTab === 'careers' ? 'active' : ''}`}
          onClick={() => setActiveTab('careers')}
        >
          <Award size={16} />
          <span>Ngành Học Hot</span>
        </button>
      </nav>

      <div className="header-actions">
        <button
          className="action-btn"
          onClick={openSettings}
          title={isKeyValid ? "API Key đã sẵn sàng" : "Chưa cài đặt Gemini API Key"}
        >
          <Key size={18} />
          <span className={`status-badge ${isKeyValid ? 'active' : 'missing'}`} />
        </button>

        <button
          className="action-btn"
          onClick={toggleTheme}
          title="Chuyển chế độ Sáng / Tối"
        >
          {theme === 'dark' ? <Sun size={18} /> : <Moon size={18} />}
        </button>

        {activeTab === 'chat' && (
          <button
            className="action-btn"
            onClick={clearChat}
            title="Xóa cuộc trò chuyện"
          >
            <Trash2 size={18} />
          </button>
        )}
      </div>
    </header>
  );
}
