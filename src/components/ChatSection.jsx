import React, { useRef, useEffect, useState } from 'react';
import ReactMarkdown from 'react-markdown';
import { Send, Bot, User, Sparkles, Key, AlertCircle } from 'lucide-react';
import { QUICK_PROMPTS } from '../data/quickPrompts';

export default function ChatSection({
  messages,
  onSendMessage,
  isLoading,
  apiKey,
  openSettings
}) {
  const [inputText, setInputText] = useState('');
  const messagesEndRef = useRef(null);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages, isLoading]);

  const handleFormSubmit = (e) => {
    e.preventDefault();
    if (!inputText.trim() || isLoading) return;
    onSendMessage(inputText.trim());
    setInputText('');
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleFormSubmit(e);
    }
  };

  const handleChipClick = (promptText) => {
    if (isLoading) return;
    onSendMessage(promptText);
  };

  const hasApiKey = Boolean(apiKey && apiKey.trim().length > 10);

  return (
    <div className="chat-container">
      {/* Quick Prompts Bar */}
      <div className="quick-prompts-bar">
        {QUICK_PROMPTS.map((prompt, idx) => (
          <button
            key={idx}
            className="quick-prompt-chip"
            onClick={() => handleChipClick(prompt.text)}
            disabled={isLoading}
          >
            <span>{prompt.icon}</span>
            <span>{prompt.text}</span>
          </button>
        ))}
      </div>

      {/* Messages Scroll View */}
      <div className="messages-scroll-area">
        {!hasApiKey && (
          <div
            style={{
              background: 'rgba(244, 63, 94, 0.1)',
              border: '1px solid var(--accent-rose)',
              borderRadius: 'var(--radius-md)',
              padding: '1rem 1.25rem',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              marginBottom: '1rem'
            }}
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
              <AlertCircle size={24} color="var(--accent-rose)" />
              <div>
                <strong style={{ color: 'var(--accent-rose)' }}>Chưa có Gemini API Key</strong>
                <p style={{ fontSize: '0.85rem', color: 'var(--text-secondary)' }}>
                  Vui lòng nhập API Key để bắt đầu trò chuyện với Chuyên gia Hướng nghiệp AI.
                </p>
              </div>
            </div>
            <button className="btn-primary" style={{ width: 'auto', padding: '0.5rem 1rem' }} onClick={openSettings}>
              <Key size={16} /> Cài Đặt Key
            </button>
          </div>
        )}

        {messages.map((msg, index) => (
          <div key={index} className={`message-wrapper ${msg.role}`}>
            <div className={`avatar-box ${msg.role === 'user' ? 'avatar-user' : 'avatar-bot'}`}>
              {msg.role === 'user' ? <User size={18} /> : <Bot size={18} />}
            </div>

            <div className="message-bubble">
              {msg.role === 'user' ? (
                msg.content
              ) : (
                <ReactMarkdown>{msg.content}</ReactMarkdown>
              )}
            </div>
          </div>
        ))}

        {isLoading && (
          <div className="message-wrapper assistant">
            <div className="avatar-box avatar-bot">
              <Sparkles size={18} />
            </div>
            <div className="message-bubble">
              <div className="typing-indicator">
                <div className="typing-dot"></div>
                <div className="typing-dot"></div>
                <div className="typing-dot"></div>
              </div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input Bar */}
      <form className="chat-input-container" onSubmit={handleFormSubmit}>
        <textarea
          className="chat-textarea"
          placeholder={hasApiKey ? "Đặt câu hỏi về ngành học, khối thi, trường ĐH..." : "Nhấp Cài đặt API Key trước khi hỏi..."}
          value={inputText}
          onChange={(e) => setInputText(e.target.value)}
          onKeyDown={handleKeyDown}
          disabled={isLoading || !hasApiKey}
          rows={1}
        />
        <button
          type="submit"
          className="btn-send"
          disabled={isLoading || !inputText.trim() || !hasApiKey}
          title="Gửi câu hỏi"
        >
          <Send size={18} />
        </button>
      </form>
    </div>
  );
}
