import React, { useState, useEffect } from 'react';
import Header from './components/Header';
import ApiKeyModal from './components/ApiKeyModal';
import ChatSection from './components/ChatSection';
import HollandQuizSection from './components/HollandQuizSection';
import CareerExplorerSection from './components/CareerExplorerSection';
import { sendChatMessage } from './services/gemini';

const LOCAL_STORAGE_KEY = 'edupath_gemini_api_key';
const LOCAL_STORAGE_THEME = 'edupath_theme';
const LOCAL_STORAGE_CHAT = 'edupath_chat_history';

const INITIAL_WELCOME_MSG = {
  role: 'assistant',
  content: `Xin chào bạn! Tớ là **EduPath AI** - Chuyên gia tư vấn hướng nghiệp chọn ngành Đại học dành riêng cho học sinh THPT tại Việt Nam 🎓\n\nBạn đang băn khoăn về chọn ngành học, chọn tổ hợp khối thi (A00, A01, B00, C00, D01...), tìm trường Đại học phù hợp hay lo lắng về cơ hội việc làm tương lai?\n\nHãy đặt câu hỏi trực tiếp hoặc thử bài **Trắc nghiệm Holland** ở thanh menu để tớ hỗ trợ bạn nhé!`
};

export default function App() {
  const [activeTab, setActiveTab] = useState('chat');
  const [apiKey, setApiKey] = useState(() => localStorage.getItem(LOCAL_STORAGE_KEY) || '');
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [theme, setTheme] = useState(() => localStorage.getItem(LOCAL_STORAGE_THEME) || 'light');
  const [messages, setMessages] = useState(() => {
    const saved = localStorage.getItem(LOCAL_STORAGE_CHAT);
    if (saved) {
      try { return JSON.parse(saved); } catch (e) { /* fallback */ }
    }
    return [INITIAL_WELCOME_MSG];
  });
  const [isLoading, setIsLoading] = useState(false);

  // Apply dark/light theme to root HTML element
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem(LOCAL_STORAGE_THEME, theme);
  }, [theme]);

  // Persist chat history to localStorage
  useEffect(() => {
    localStorage.setItem(LOCAL_STORAGE_CHAT, JSON.stringify(messages));
  }, [messages]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  const handleSaveApiKey = (newKey) => {
    setApiKey(newKey);
    localStorage.setItem(LOCAL_STORAGE_KEY, newKey);
  };

  const handleClearChat = () => {
    if (window.confirm("Bạn có chắc chắn muốn xóa toàn bộ lịch sử trò chuyện?")) {
      setMessages([INITIAL_WELCOME_MSG]);
    }
  };

  const handleSendMessage = async (userText) => {
    if (!apiKey || apiKey.trim().length === 0) {
      setIsSettingsOpen(true);
      return;
    }

    const newMessages = [...messages, { role: 'user', content: userText }];
    setMessages(newMessages);
    setIsLoading(true);

    try {
      const botResponse = await sendChatMessage(newMessages, apiKey);
      setMessages([...newMessages, { role: 'assistant', content: botResponse }]);
    } catch (error) {
      let errorMsg = "⚠️ Đã xảy ra lỗi khi kết nối với Gemini AI. Vui lòng thử lại!";
      if (error.message === 'MISSING_API_KEY' || error.message === 'INVALID_API_KEY') {
        errorMsg = "⚠️ **Gemini API Key không hợp lệ hoặc đã bị khóa.** Vui lòng nhấp vào icon Chìa khóa ở góc trên để cập nhật Key mới.";
        setIsSettingsOpen(true);
      } else if (error.message === 'RATE_LIMIT') {
        errorMsg = "⚠️ **Hệ thống đang quá tải (Rate Limit).** Vui lòng chờ vài giây rồi thử lại câu hỏi!";
      }

      setMessages([...newMessages, { role: 'assistant', content: errorMsg }]);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSendPromptFromOtherTabs = (promptMessage) => {
    setActiveTab('chat');
    handleSendMessage(promptMessage);
  };

  return (
    <div className="app-container">
      <Header
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        apiKey={apiKey}
        openSettings={() => setIsSettingsOpen(true)}
        theme={theme}
        toggleTheme={toggleTheme}
        clearChat={handleClearChat}
      />

      <main className="main-content">
        {activeTab === 'chat' && (
          <ChatSection
            messages={messages}
            onSendMessage={handleSendMessage}
            isLoading={isLoading}
            apiKey={apiKey}
            openSettings={() => setIsSettingsOpen(true)}
          />
        )}

        {activeTab === 'quiz' && (
          <HollandQuizSection
            onSendQuizResultToChat={handleSendPromptFromOtherTabs}
          />
        )}

        {activeTab === 'careers' && (
          <CareerExplorerSection
            onAskAboutCareer={handleSendPromptFromOtherTabs}
          />
        )}
      </main>

      <ApiKeyModal
        isOpen={isSettingsOpen}
        onClose={() => setIsSettingsOpen(false)}
        apiKey={apiKey}
        onSaveKey={handleSaveApiKey}
      />
    </div>
  );
}
