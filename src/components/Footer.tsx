import React from 'react';
import { BookOpen, Mail, Github, Twitter } from 'lucide-react';

export const Footer: React.FC = () => {
  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid md:grid-cols-4 gap-8">
          {/* Brand */}
          <div>
            <div className="flex items-center space-x-2 mb-4">
              <div className="bg-gradient-to-r from-emerald-500 to-blue-600 p-2 rounded-lg">
                <BookOpen className="h-6 w-6 text-white" />
              </div>
              <div>
                <h3 className="text-lg font-bold">FinanSmart</h3>
                <p className="text-xs text-gray-400">Finansų edukacija lietuviams</p>
              </div>
            </div>
            <p className="text-gray-300 text-sm">
              Modernus finansų švietimo portalas, skirtas padėti lietuviams geriau valdyti savo finansus ir investuoti ateitį.
            </p>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Mokymosi lygiai</h4>
            <ul className="space-y-2 text-sm text-gray-300">
              <li><a href="#" className="hover:text-white transition-colors">Pradedančiųjų lygis</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Vidutinis lygis</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Pažengusiųjų lygis</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Testai ir quiz'ai</a></li>
            </ul>
          </div>

          {/* Tools */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Įrankiai</h4>
            <ul className="space-y-2 text-sm text-gray-300">
              <li><a href="#" className="hover:text-white transition-colors">Biudžeto skaičiuoklė</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Sudėtinių palūkanų skaičiuoklė</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Paskolos skaičiuoklė</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Finansų žodynas</a></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Kontaktai</h4>
            <ul className="space-y-3 text-sm text-gray-300">
              <li className="flex items-center space-x-2">
                <Mail className="h-4 w-4" />
                <a href="mailto:info@finansmart.lt" className="hover:text-white transition-colors">
                  info@finansmart.lt
                </a>
              </li>
              <li>
                <div className="flex space-x-3 mt-4">
                  <a href="#" className="text-gray-400 hover:text-white transition-colors">
                    <Github className="h-5 w-5" />
                  </a>
                  <a href="#" className="text-gray-400 hover:text-white transition-colors">
                    <Twitter className="h-5 w-5" />
                  </a>
                </div>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-800 mt-8 pt-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <p className="text-gray-400 text-sm">
              © 2024 FinanSmart. Visos teisės saugomos.
            </p>
            <div className="flex space-x-6 mt-4 md:mt-0">
              <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors">
                Privatumo politika
              </a>
              <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors">
                Naudojimosi taisyklės
              </a>
              <a href="#" className="text-gray-400 hover:text-white text-sm transition-colors">
                Slapukai
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};