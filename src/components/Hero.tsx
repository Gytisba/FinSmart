import React from 'react';
import { TrendingUp, Users, BookOpen, Trophy } from 'lucide-react';
import { useAuth } from '../hooks/useAuth';

interface HeroProps {
  onAuthRequired: (mode: 'login' | 'register') => void;
}

export const Hero: React.FC<HeroProps> = ({ onAuthRequired }) => {
  const { user } = useAuth();

  const stats = [
    { icon: Users, label: 'Aktyvūs mokiniai', value: '12,547' },
    { icon: BookOpen, label: 'Mokymų moduliai', value: '47' },
    { icon: Trophy, label: 'Įgyti sertifikatai', value: '8,923' },
    { icon: TrendingUp, label: 'Vidutinis pažangumas', value: '87%' }
  ];

  return (
    <div className="relative overflow-hidden bg-gradient-to-r from-emerald-600 via-blue-600 to-purple-600">
      <div className="absolute inset-0 bg-black opacity-20"></div>
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
        <div className="text-center">
          <h1 className="text-4xl md:text-6xl font-bold text-white mb-6">
            Finansų edukacija
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-orange-400">
              lietuviams
            </span>
          </h1>
          <p className="text-xl md:text-2xl text-blue-100 mb-8 max-w-3xl mx-auto">
            Mokykitės finansų valdymo, investavimo ir taupymo su moderniomis, interaktyviomis pamokėlėmis, 
            pritaikytomis Lietuvos rinkai
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center">
            {user ? (
              <button className="bg-white text-blue-600 px-8 py-4 rounded-lg font-semibold text-lg hover:bg-blue-50 transition-colors duration-200 transform hover:scale-105">
                Tęsti mokymąsi
              </button>
            ) : (
              <>
                <button 
                  onClick={() => onAuthRequired('register')}
                  className="bg-white text-blue-600 px-8 py-4 rounded-lg font-semibold text-lg hover:bg-blue-50 transition-colors duration-200 transform hover:scale-105"
                >
                  Pradėti mokytis
                </button>
                <button 
                  onClick={() => onAuthRequired('login')}
                  className="border-2 border-white text-white px-8 py-4 rounded-lg font-semibold text-lg hover:bg-white hover:text-blue-600 transition-all duration-200 transform hover:scale-105"
                >
                  Prisijungti
                </button>
              </>
            )}
          </div>
        </div>

        <div className="mt-20 grid grid-cols-2 md:grid-cols-4 gap-8">
          {stats.map((stat, index) => {
            const Icon = stat.icon;
            return (
              <div key={index} className="text-center">
                <div className="bg-white bg-opacity-20 rounded-full p-4 w-16 h-16 mx-auto mb-4 flex items-center justify-center">
                  <Icon className="h-8 w-8 text-white" />
                </div>
                <div className="text-2xl font-bold text-white mb-1">{stat.value}</div>
                <div className="text-blue-200 text-sm">{stat.label}</div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};