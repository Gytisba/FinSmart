import React from 'react';
import { ArrowLeft, User, Award, TrendingUp, Target, RotateCcw } from 'lucide-react';
import { UserProgress } from '../App';

interface ProfileProps {
  userProgress: UserProgress;
  onBack: () => void;
  onResetProgress: () => void;
}

export const Profile: React.FC<ProfileProps> = ({ userProgress, onBack, onResetProgress }) => {
  const badges = [
    { id: 'first_five', name: 'Pirmieji 5', description: 'Baigė pirmus 5 modulius', icon: '🎯' },
    { id: 'point_master', name: 'Taškų meistras', description: 'Surinko 1000+ taškų', icon: '🏆' },
    { id: 'week_streak', name: 'Savaitės čempionas', description: '7 dienos iš eilės', icon: '🔥' },
    { id: 'quiz_expert', name: 'Testų ekspertas', description: 'Išlaikė 10 testų', icon: '🧠' },
    { id: 'calculator_user', name: 'Skaičiuoklių mėgėjas', description: 'Naudojo visas skaičiuokles', icon: '🧮' }
  ];

  const levels = [
    { id: 'beginner', name: 'Pradedantysis', min: 0, color: 'text-green-600' },
    { id: 'intermediate', name: 'Pažengęs', min: 500, color: 'text-blue-600' },
    { id: 'advanced', name: 'Ekspertas', min: 1500, color: 'text-purple-600' },
    { id: 'master', name: 'Meistras', min: 3000, color: 'text-orange-600' }
  ];

  const currentLevel = levels.reverse().find(level => userProgress.totalPoints >= level.min) || levels[0];
  const nextLevel = levels.find(level => level.min > userProgress.totalPoints);
  const progressToNext = nextLevel ? ((userProgress.totalPoints - currentLevel.min) / (nextLevel.min - currentLevel.min)) * 100 : 100;

  const achievements = [
    { name: 'Moduliai baigti', value: userProgress.completedModules.length, icon: '📚' },
    { name: 'Bendri taškai', value: userProgress.totalPoints, icon: '⭐' },
    { name: 'Dabartinė serija', value: userProgress.currentStreak, icon: '🔥' },
    { name: 'Įgygti ženkleliai', value: userProgress.badges.length, icon: '🏆' }
  ];

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors mb-6"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>Grįžti</span>
        </button>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-8">
          <div className="flex items-center space-x-4">
            <div className="bg-white bg-opacity-20 rounded-full p-4">
              <User className="h-12 w-12" />
            </div>
            <div>
              <h1 className="text-2xl font-bold">Jūsų profilis</h1>
              <p className="text-blue-100">Finansų mokymosi pažanga</p>
            </div>
          </div>
        </div>

        {/* Current Level */}
        <div className="p-8 border-b border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold text-gray-900">Dabartinis lygis</h2>
            <span className={`text-2xl font-bold ${currentLevel.color}`}>
              {currentLevel.name}
            </span>
          </div>

          {nextLevel && (
            <div>
              <div className="flex justify-between text-sm text-gray-600 mb-2">
                <span>Pažanga iki kito lygio</span>
                <span>{Math.round(progressToNext)}%</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-3">
                <div
                  className="bg-gradient-to-r from-blue-500 to-purple-500 h-3 rounded-full transition-all duration-500"
                  style={{ width: `${progressToNext}%` }}
                ></div>
              </div>
              <div className="text-sm text-gray-500 mt-2">
                Reikia dar {nextLevel.min - userProgress.totalPoints} taškų pasiekti "{nextLevel.name}" lygį
              </div>
            </div>
          )}
        </div>

        {/* Statistics */}
        <div className="p-8 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Statistika</h2>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
            {achievements.map((achievement, index) => (
              <div key={index} className="text-center">
                <div className="text-3xl mb-2">{achievement.icon}</div>
                <div className="text-2xl font-bold text-gray-900">{achievement.value}</div>
                <div className="text-sm text-gray-600">{achievement.name}</div>
              </div>
            ))}
          </div>
        </div>

        {/* Badges */}
        <div className="p-8 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Įgyti ženkleliai</h2>
          {userProgress.badges.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {userProgress.badges.map((badgeId) => {
                const badge = badges.find(b => b.id === badgeId);
                if (!badge) return null;
                
                return (
                  <div
                    key={badgeId}
                    className="flex items-center space-x-4 bg-gradient-to-r from-yellow-50 to-orange-50 border border-yellow-200 rounded-lg p-4"
                  >
                    <div className="text-3xl">{badge.icon}</div>
                    <div>
                      <h4 className="font-semibold text-gray-900">{badge.name}</h4>
                      <p className="text-sm text-gray-600">{badge.description}</p>
                    </div>
                  </div>
                );
              })}
            </div>
          ) : (
            <div className="text-center text-gray-500 py-8">
              <Award className="h-12 w-12 mx-auto mb-4 text-gray-300" />
              <p>Dar neturite įgytų ženklelių</p>
              <p className="text-sm">Mokykitės ir spręskite testus, kad užsidirbtumėte ženklelių!</p>
            </div>
          )}
        </div>

        {/* Available Badges */}
        <div className="p-8 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Galimi ženkleliai</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {badges.filter(badge => !userProgress.badges.includes(badge.id)).map((badge) => (
              <div
                key={badge.id}
                className="flex items-center space-x-4 bg-gray-50 border border-gray-200 rounded-lg p-4 opacity-75"
              >
                <div className="text-3xl grayscale">{badge.icon}</div>
                <div>
                  <h4 className="font-semibold text-gray-600">{badge.name}</h4>
                  <p className="text-sm text-gray-500">{badge.description}</p>
                </div>
                <div className="ml-auto">
                  <Target className="h-4 w-4 text-gray-400" />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Learning Goals */}
        <div className="p-8 border-b border-gray-200">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Mokymosi tikslai</h2>
          <div className="space-y-4">
            <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <div>
                  <h4 className="font-semibold text-blue-900">Savaitės tikslas</h4>
                  <p className="text-sm text-blue-700">Baigti 2 modulius per savaitę</p>
                </div>
                <div className="text-blue-600">
                  <TrendingUp className="h-6 w-6" />
                </div>
              </div>
              <div className="mt-3">
                <div className="w-full bg-blue-200 rounded-full h-2">
                  <div className="bg-blue-600 h-2 rounded-full" style={{ width: '60%' }}></div>
                </div>
                <p className="text-xs text-blue-600 mt-1">3/5 modulių baigta šią savaitę</p>
              </div>
            </div>

            <div className="bg-green-50 border border-green-200 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <div>
                  <h4 className="font-semibold text-green-900">Mėnesio tikslas</h4>
                  <p className="text-sm text-green-700">Surinkti 500 taškų per mėnesį</p>
                </div>
                <div className="text-green-600">
                  <Award className="h-6 w-6" />
                </div>
              </div>
              <div className="mt-3">
                <div className="w-full bg-green-200 rounded-full h-2">
                  <div className="bg-green-600 h-2 rounded-full" style={{ width: '80%' }}></div>
                </div>
                <p className="text-xs text-green-600 mt-1">400/500 taškų surinkta šį mėnesį</p>
              </div>
            </div>
          </div>
        </div>

        {/* Reset Progress */}
        <div className="p-8">
          <h2 className="text-xl font-semibold text-gray-900 mb-6">Pažangos valdymas</h2>
          <div className="bg-red-50 border border-red-200 rounded-lg p-6">
            <div className="flex items-start space-x-4">
              <RotateCcw className="h-6 w-6 text-red-600 mt-1" />
              <div className="flex-1">
                <h4 className="font-semibold text-red-900 mb-2">Iš naujo pradėti mokymąsi</h4>
                <p className="text-sm text-red-700 mb-4">
                  Ši funkcija ištrins visą jūsų pažangą, įskaitant taškus, ženklelius ir baigtus modulius. 
                  Šis veiksmas yra negrįžtamas.
                </p>
                <button
                  onClick={onResetProgress}
                  className="bg-red-600 text-white px-4 py-2 rounded-lg hover:bg-red-700 transition-colors text-sm font-medium"
                >
                  Ištrinti pažangą
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};