import React, { useState } from 'react';
import { Key, ShieldCheck, ExternalLink, Save, X } from 'lucide-react';

export default function ApiKeyModal({ isOpen, onClose, apiKey, onSaveKey }) {
  const [tempKey, setTempKey] = useState(apiKey || '');
  const [showKey, setShowKey] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    onSaveKey(tempKey.trim());
    onClose();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <h3 className="modal-title">
            <Key className="text-indigo" size={20} />
            Cấu Hình Gemini API Key
          </h3>
          <button className="btn-close" onClick={onClose}>
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="input-group">
            <label className="input-label">
              Gemini API Key cá nhân của bạn:
            </label>
            <div style={{ position: 'relative' }}>
              <input
                type={showKey ? "text" : "password"}
                className="text-input"
                placeholder="AIzaSy..."
                value={tempKey}
                onChange={(e) => setTempKey(e.target.value)}
                autoFocus
              />
              <button
                type="button"
                onClick={() => setShowKey(!showKey)}
                style={{
                  position: 'absolute',
                  right: '12px',
                  top: '50%',
                  transform: 'translateY(-50%)',
                  fontSize: '0.8rem',
                  color: 'var(--text-muted)'
                }}
              >
                {showKey ? 'Ẩn' : 'Hiện'}
              </button>
            </div>
          </div>

          <div style={{ display: 'flex', gap: '0.75rem', marginTop: '1.25rem' }}>
            <button type="submit" className="btn-primary">
              <Save size={16} />
              Lưu Key Vấn Tin
            </button>
            <button type="button" className="btn-secondary" onClick={onClose}>
              Hủy
            </button>
          </div>
        </form>

        <div className="help-box">
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem', fontWeight: '600', marginBottom: '0.25rem' }}>
            <ShieldCheck size={16} color="var(--brand-primary)" />
            <span>Bảo mật 100% trên LocalStorage</span>
          </div>
          <p style={{ marginBottom: '0.5rem' }}>
            API Key của bạn được lưu an toàn trong trình duyệt cá nhân và KHÔNG BAO GIỜ đẩy lên server nào khác.
          </p>
          <a
            href="https://aistudio.google.com/app/apikey"
            target="_blank"
            rel="noopener noreferrer"
            className="help-link"
            style={{ display: 'inline-flex', alignItems: 'center', gap: '0.3rem' }}
          >
            Lấy Gemini API Key miễn phí từ Google AI Studio <ExternalLink size={14} />
          </a>
        </div>
      </div>
    </div>
  );
}
