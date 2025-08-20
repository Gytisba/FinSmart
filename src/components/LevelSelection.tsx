import React from 'react';
import { BookOpen, TrendingUp, BarChart3, CheckCircle, Lock } from 'lucide-react';
import { Level, UserProgress } from '../App';

interface LevelSelectionProps {
  onLevelSelect: (level: Level) => void;
  userProgress: UserProgress;
}

export const LevelSelection: React.FC<LevelSelectionProps> = ({ onLevelSelect, userProgress }) => {
  const levels = [
    {
      id: 'beginner' as Level,
      title: 'Pradedančiųjų lygis',
      subtitle: 'Asmeninių finansų pagrindai',
      icon: BookOpen,
      color: 'from-emerald-500 to-green-600',
      description: 'Išmokite finansų pagrindų: biudžeto sudarymo, taupymo ir pagrindinių finansinių įrankių naudojimo.',
      modules: [
        'Kas yra pinigai?',
        'Biudžeto sudarymas',
        'Taupymas vs išlaidavimas',
        'Banko sąskaitos',
        'Mokesčiai Lietuvoje'
      ],
      unlocked: true,
      progress: userProgress.completedModules.filter(m => m.startsWith('beginner')).length
    },
    {
      id: 'intermediate' as Level,
      title: 'Vidutinis lygis',
      subtitle: 'Turto kūrimas ir finansiniai įrankiai',
      icon: TrendingUp,
      color: 'from-blue-500 to-indigo-600',
      description: 'Sužinokite apie investavimą, pensijų kaupimą ir finansinių paslaugų naudojimą Lietuvoje.',
      modules: [
        'Lietuvos pensijų sistema',
        'Sudėtinės palūkanos',
        'Kreditinės kortelės',
        'Įvadas į investavimą',
        'Draudimo rūšys'
      ],
      unlocked: userProgress.completedModules.filter(m => m.startsWith('beginner')).length >= 3,
      progress: userProgress.completedModules.filter(m => m.startsWith('intermediate')).length
    },
    {
      id: 'advanced' as Level,
      title: 'Pažengusiųjų lygis',
      subtitle: 'Investavimas ir ekonomikos supratimas',
      icon: BarChart3,
      color: 'from-purple-500 to-pink-600',
      description: 'Gilintis į akcijų rinkas, ETF fondus ir makroekonomikos principus.',
      modules: [
        'Akcijų rinkos pagrindai',
        'ETF fondai',
        'Rizikos valdymas',
        'Kriptovaliutos',
        'Makroekonominiai rodikliai'
      ],
      unlocked: userProgress.completedModules.filter(m => m.startsWith('intermediate')).length >= 3,
      progress: userProgress.completedModules.filter(m => m.startsWith('advanced')).length
    }
  ];

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div className="text-center mb-16">
        <h2 className="text-3xl font-bold text-gray-900 mb-4">Pasirinkite mokymosi lygį</h2>
        <p className="text-xl text-gray-600 max-w-3xl mx-auto">
          Kiekvienas lygis suderintas su jūsų finansinių žinių lygiu. Pradėkite nuo pagrindų ir palaipsniui gilinkitės.
        </p>
      </div>

      <div className="grid md:grid-cols-3 gap-8">
        {levels.map((level, index) => {
          const Icon = level.icon;
          const isLocked = !level.unlocked;
          const completedModules = level.progress;
          const totalModules = level.modules.length;
          const progressPercent = (completedModules / totalModules) * 100;

          return (
            <div
              key={level.id}
              className={`relative bg-white rounded-2xl shadow-xl overflow-hidden transition-all duration-300 ${
                isLocked 
                  ? 'opacity-60 cursor-not-allowed' 
                  : 'cursor-pointer hover:scale-105 hover:shadow-2xl'
              }`}
              onClick={() => !isLocked && onLevelSelect(level.id)}
            >
              {isLocked && (
                <div className="absolute top-4 right-4 z-10">
                  <Lock className="h-6 w-6 text-gray-400" />
                </div>
              )}

              <div className={`h-32 bg-gradient-to-r ${level.color} relative`}>
                <div className="absolute inset-0 bg-black bg-opacity-20"></div>
                <div className="relative flex items-center justify-center h-full">
                  <Icon className="h-12 w-12 text-white" />
                </div>
              </div>

              <div className="p-6">
                <div className="flex items-center justify-between mb-2">
                  <h3 className="text-xl font-bold text-gray-900">{level.title}</h3>
                  {!isLocked && (
                    <div className="text-sm text-gray-500">
                      {completedModules}/{totalModules}
                    </div>
                  )}
                </div>
                
                <p className="text-emerald-600 font-medium text-sm mb-3">{level.subtitle}</p>
                <p className="text-gray-600 mb-6">{level.description}</p>

                {!isLocked && (
                  <div className="mb-6">
                    <div className="flex justify-between text-sm text-gray-500 mb-2">
                      <span>Pažanga</span>
                      <span>{Math.round(progressPercent)}%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div
                        className={`h-2 rounded-full bg-gradient-to-r ${level.color} transition-all duration-500`}
                        style={{ width: `${progressPercent}%` }}
                      ></div>
                    </div>
                  </div>
                )}

                <div className="space-y-2">
                  <h4 className="font-medium text-gray-900 text-sm">Moduliai:</h4>
                  {level.modules.slice(0, 3).map((module, moduleIndex) => (
                    <div key={moduleIndex} className="flex items-center space-x-2">
                      <CheckCircle className={`h-4 w-4 ${
                        userProgress.completedModules.includes(`${level.id}-${moduleIndex}`)
                          ? 'text-emerald-500'
                          : 'text-gray-300'
                      }`} />
                      <span className="text-sm text-gray-600">{module}</span>
                    </div>
                  ))}
                  {level.modules.length > 3 && (
                    <div className="text-sm text-gray-400">
                      +{level.modules.length - 3} daugiau modulių
                    </div>
                  )}
                </div>

                <div className="mt-6">
                  <button
                    disabled={isLocked}
                    className={`w-full py-3 px-4 rounded-lg font-medium transition-all duration-200 ${
                      isLocked
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        : `bg-gradient-to-r ${level.color} text-white hover:shadow-lg transform hover:-translate-y-0.5`
                    }`}
                  >
                    {isLocked ? 'Užrakinta' : 'Pradėti mokytis'}
                  </button>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};