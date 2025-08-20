import React, { useState, useEffect } from 'react';
import { useAuth } from './hooks/useAuth';
import { useUserProgress } from './hooks/useUserProgress';
import { AuthModal } from './components/AuthModal';
import { Header } from './components/Header';
import { Hero } from './components/Hero';
import { LevelSelection } from './components/LevelSelection';
import { CourseModule } from './components/CourseModule';
import { Quiz } from './components/Quiz';
import { Calculator } from './components/Calculator';
import { Glossary } from './components/Glossary';
import { News } from './components/News';
import { Resources } from './components/Resources';
import { Profile } from './components/Profile';
import { Footer } from './components/Footer';
import { supabase } from './lib/supabase';

export type Section = 'home' | 'course' | 'quiz' | 'calculator' | 'glossary' | 'news' | 'resources' | 'profile';
export type Level = 'beginner' | 'intermediate' | 'advanced';

export interface UserProgress {
  id: string;
  user_id: string;
  level: 'beginner' | 'intermediate' | 'advanced';
  completedModules: string[];
  badges: string[];
  total_points: number;
  current_streak: number;
  created_at: string;
  updated_at: string;
}

function App() {
  const { user, loading: authLoading } = useAuth();
  const { progress, loading: progressLoading, completeModule, resetProgress } = useUserProgress();
  const [currentSection, setCurrentSection] = useState<Section>('home');
  const [selectedLevel, setSelectedLevel] = useState<Level>('beginner');
  const [selectedModule, setSelectedModule] = useState<string>('');
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [authModalMode, setAuthModalMode] = useState<'login' | 'register'>('login');

  const handleLevelSelect = (level: Level) => {
    setSelectedLevel(level);
    setCurrentSection('course');
  };

  const handleModuleSelect = (moduleId: string) => {
    setSelectedModule(moduleId);
    setCurrentSection('course');
  };

  const handleQuizComplete = (moduleId: string, points: number) => {
    if (user && progress) {
      completeModule(moduleId, points);
    }
    setCurrentSection('home');
  };

  const handleResetProgress = async () => {
    if (user && progress) {
      const confirmed = window.confirm('Ar tikrai norite ištrinti visą savo pažangą? Šis veiksmas yra negrįžtamas.');
      if (confirmed) {
        await resetProgress();
      }
    }
  };

  const handleAuthRequired = (mode: 'login' | 'register' = 'login') => {
    setAuthModalMode(mode);
    setShowAuthModal(true);
  };

  // Convert database progress to app format
  const appProgress = progress ? {
    level: progress.level as Level,
    completedModules: progress.completed_modules,
    badges: progress.badges,
    totalPoints: progress.total_points,
    currentStreak: progress.current_streak
  } : {
    level: 'beginner' as Level,
    completedModules: [],
    badges: [],
    totalPoints: 0,
    currentStreak: 0
  };

  if (authLoading || progressLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Kraunama...</p>
        </div>
      </div>
    );
  }

  const renderCurrentSection = () => {
    if (!user) {
      return (
        <>
          <Hero onAuthRequired={handleAuthRequired} />
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 text-center">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">
              Prisijunkite, kad pradėtumėte mokytis
            </h2>
            <p className="text-gray-600 mb-8">
              Sukurkite paskyrą ir sekite savo pažangą finansų mokymesi
            </p>
            <div className="flex justify-center space-x-4">
              <button
                onClick={() => handleAuthRequired('register')}
                className="bg-gradient-to-r from-emerald-500 to-green-600 text-white px-8 py-3 rounded-lg hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-200"
              >
                Registruotis
              </button>
              <button
                onClick={() => handleAuthRequired('login')}
                className="border-2 border-blue-600 text-blue-600 px-8 py-3 rounded-lg hover:bg-blue-50 transition-colors"
              >
                Prisijungti
              </button>
            </div>
          </div>
        </>
      );
    }

    switch (currentSection) {
      case 'course':
        return (
          <CourseModule
            level={selectedLevel}
            moduleId={selectedModule}
            userProgress={appProgress}
            onStartQuiz={() => setCurrentSection('quiz')}
            onBack={() => setCurrentSection('home')}
          />
        );
      case 'quiz':
        return (
          <Quiz
            level={selectedLevel}
            moduleId={selectedModule}
            onComplete={handleQuizComplete}
            onBack={() => setCurrentSection('course')}
          />
        );
      case 'calculator':
        return <Calculator onBack={() => setCurrentSection('home')} />;
      case 'glossary':
        return <Glossary onBack={() => setCurrentSection('home')} />;
      case 'news':
        return <News onBack={() => setCurrentSection('home')} />;
      case 'resources':
        return <Resources onBack={() => setCurrentSection('home')} />;
      case 'profile':
        return (
          <Profile
            userProgress={appProgress}
            onBack={() => setCurrentSection('home')}
            onResetProgress={handleResetProgress}
          />
        );
      default:
        return (
          <>
            <Hero onAuthRequired={handleAuthRequired} />
            <LevelSelection
              onLevelSelect={handleLevelSelect}
              userProgress={appProgress}
            />
          </>
        );
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
      <Header
        currentSection={currentSection}
        onSectionChange={setCurrentSection}
        userProgress={appProgress}
        onAuthRequired={handleAuthRequired}
      />
      <main className="min-h-screen">
        {renderCurrentSection()}
      </main>
      <AuthModal
        isOpen={showAuthModal}
        onClose={() => setShowAuthModal(false)}
        initialMode={authModalMode}
      />
      <Footer />
    </div>
  );
}

export default App;