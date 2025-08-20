import React from 'react';
import { BookOpen, Calculator, Book, Newspaper, FileText, User, Home, Award, LogOut } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';
import { Section, UserProgress } from '../App';

interface HeaderProps {
  currentSection: Section;
  onSectionChange: (section: Section) => void;
  userProgress: UserProgress;
  onAuthRequired: (mode: 'login' | 'register') => void;
}

export const Header: React.FC<HeaderProps> = ({ 
  currentSection, 
  onSectionChange, 
  userProgress, 
  onAuthRequired 
}) => {
  const { user, profile, signOut } = useAuth();

  const navigation = [
    { id: 'home' as Section, label: 'Pagrindinis', icon: Home },
    { id: 'calculator' as Section, label: 'Skaičiuoklės', icon: Calculator },
    { id: 'glossary' as Section, label: 'Žodynas', icon: Book },
    { id: 'news' as Section, label: 'Naujienos', icon: Newspaper },
    { id: 'resources' as Section, label: 'Ištekliai', icon: FileText },
    { id: 'profile' as Section, label: 'Profilis', icon: User }
  ];

  const handleSignOut = async () => {
    await signOut();
  };

  return (
    <header className="bg-white shadow-lg sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <div 
            className="flex items-center space-x-2 cursor-pointer"
            onClick={() => onSectionChange('home')}
          >
            <div className="bg-gradient-to-r from-emerald-500 to-blue-600 p-2 rounded-lg">
              <BookOpen className="h-8 w-8 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">FinanSmart</h1>
              <p className="text-xs text-gray-500">Finansų edukacija lietuviams</p>
            </div>
          </div>

          <nav className="hidden md:flex items-center space-x-6">
            {navigation.map((item) => {
              const Icon = item.icon;
              return (
                <button
                  key={item.id}
                  onClick={() => onSectionChange(item.id)}
                  className={`flex items-center space-x-1 px-3 py-2 rounded-lg transition-all duration-200 ${
                    currentSection === item.id
                      ? 'bg-blue-100 text-blue-700'
                      : 'text-gray-600 hover:text-blue-600 hover:bg-gray-50'
                  }`}
                >
                  <Icon className="h-4 w-4" />
                  <span className="text-sm font-medium">{item.label}</span>
                </button>
              );
            })}
          </nav>

          <div className="flex items-center space-x-4">
            {user ? (
              <>
                <div className="flex items-center space-x-2 bg-gradient-to-r from-emerald-100 to-blue-100 px-3 py-2 rounded-lg">
                  <Award className="h-4 w-4 text-emerald-600" />
                  <span className="text-sm font-semibold text-gray-700">{userProgress.totalPoints} taškai</span>
                </div>
                
                <div className="flex items-center space-x-1">
                  {userProgress.badges.slice(0, 3).map((badge, index) => (
                    <div key={badge} className="w-6 h-6 bg-yellow-400 rounded-full flex items-center justify-center">
                      <span className="text-xs">🏆</span>
                    </div>
                  ))}
                  {userProgress.badges.length > 3 && (
                    <span className="text-xs text-gray-500">+{userProgress.badges.length - 3}</span>
                  )}
                </div>

                <div className="flex items-center space-x-2">
                  <div className="text-sm">
                    <p className="font-medium text-gray-900">
                      {profile?.full_name || 'Vartotojas'}
                    </p>
                    <p className="text-gray-500 text-xs">{profile?.email}</p>
                  </div>
                  <button
                    onClick={handleSignOut}
                    className="p-2 text-gray-400 hover:text-gray-600 transition-colors"
                    title="Atsijungti"
                  >
                    <LogOut className="h-4 w-4" />
                  </button>
                </div>
              </>
            ) : (
              <div className="flex items-center space-x-2">
                <button
                  onClick={() => onAuthRequired('login')}
                  className="text-gray-600 hover:text-blue-600 px-3 py-2 rounded-lg transition-colors"
                >
                  Prisijungti
                </button>
                <button
                  onClick={() => onAuthRequired('register')}
                  className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:shadow-lg transition-all duration-200"
                >
                  Registruotis
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};