import React, { useState } from 'react';
import { ArrowLeft, Play, CheckCircle, BookOpen, Award } from 'lucide-react';
import { Level, UserProgress } from '../App';

interface CourseModuleProps {
  level: Level;
  moduleId: string;
  userProgress: UserProgress;
  onStartQuiz: () => void;
  onBack: () => void;
}

export const CourseModule: React.FC<CourseModuleProps> = ({
  level,
  userProgress,
  onStartQuiz,
  onBack
}) => {
  const [currentLesson, setCurrentLesson] = useState(0);

  const modules = {
    beginner: {
      title: 'Asmeninių finansų pagrindai',
      lessons: [
        {
          title: 'Kas yra pinigai ir kaip jie veikia?',
          content: `
            <h3>Pinigų kilmė ir funkcijos</h3>
            <p>Pinigai yra visuomenės priimtas mainų įrankis, kuris palengvina prekybą ir paslaugų teikimą. Lietuvoje oficiali valiuta yra euras (€).</p>
            
            <h4>Pinigų pagrindinės funkcijos:</h4>
            <ul>
              <li><strong>Mainų priemonė</strong> - leidžia keisti prekes ir paslaugas</li>
              <li><strong>Vertės matas</strong> - nustato prekių ir paslaugų kainą</li>
              <li><strong>Vertybių saugykla</strong> - leidžia taupyti ateičiai</li>
            </ul>

            <h4>Infliacija ir perkamoji galia</h4>
            <p>Infliacija - tai kainų augimas laike. Lietuvoje vidutinė metinė infliacija yra apie 2-3%. 
            Tai reiškia, kad šiandien už 100€ galite nusipirkti daugiau nei už tuos pačius 100€ po metų.</p>

            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 my-4">
              <h5>Pavyzdys:</h5>
              <p>Jei infliacija 3%, tai kas šiandien kainuoja 100€, po metų kainuos 103€. 
              Todėl svarbu pinigus investuoti ar bent jau laikyti taupomosios sąskaitos su palūkanomis.</p>
            </div>
          `,
          duration: '5 min'
        },
        {
          title: 'Biudžeto sudarymas - jūsų finansų pagrindas',
          content: `
            <h3>Kodėl svarbu turėti biudžetą?</h3>
            <p>Biudžetas padeda kontroliuoti išlaidas, planuoti taupymą ir pasiekti finansinius tikslus.</p>
            
            <h4>Pagrindinė biudžeto formulė:</h4>
            <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg my-4">
              <p class="text-lg font-semibold">Pajamos - Išlaidos = Taupymas</p>
            </div>

            <h4>Biudžeto sudarymo žingsniai:</h4>
            <ol>
              <li><strong>Apskaičiuokite pajamas</strong> - algą, dividendus, kitas pajamas</li>
              <li><strong>Išvardykite išlaidas</strong>:
                <ul>
                  <li>Būtinos (būstas, maistas, transportas) - 50-60%</li>
                  <li>Pramogos ir poilsis - 20-30%</li>
                  <li>Taupymas - 10-20%</li>
                </ul>
              </li>
              <li><strong>Stebėkite ir koreguokite</strong></li>
            </ol>

            <div class="bg-green-50 border-l-4 border-green-400 p-4 my-4">
              <h5>Lietuvos kontekstas:</h5>
              <p>Vidutinis atlyginimas Lietuvoje 2024m. - apie 1,400€ "į rankas". 
              Vidutinės šeimos išlaidos būstui - 400-600€, maistui - 300-400€.</p>
            </div>
          `,
          duration: '7 min'
        },
        {
          title: 'Taupymas vs išlaidavimas - tinkamas balansas',
          content: `
            <h3>Taupymo svarba</h3>
            <p>Taupymas užtikrina finansinį stabilumą ir leidžia realizuoti svajones bei tikslus.</p>
            
            <h4>Taupymo principai:</h4>
            <ul>
              <li><strong>Mokėkite sau pirma</strong> - iš karto išskirkite taupymui dalį pajamų</li>
              <li><strong>Automatizuokite</strong> - nustatykite automatinį pinigų pervedimą į taupymo sąskaitą</li>
              <li><strong>50/30/20 taisyklė</strong>:
                <ul>
                  <li>50% - būtinos išlaidos</li>
                  <li>30% - pramogos</li>
                  <li>20% - taupymas ir investicijos</li>
                </ul>
              </li>
            </ul>

            <h4>Taupymo tikslai:</h4>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 my-4">
              <div class="bg-blue-50 p-4 rounded-lg">
                <h5 class="font-semibold">Trumpalaikiai (iki 1 metų)</h5>
                <ul>
                  <li>Nepamirštamųjų fondas (3-6 mėn. išlaidų)</li>
                  <li>Atostogos</li>
                  <li>Elektronikos atnaujinimas</li>
                </ul>
              </div>
              <div class="bg-green-50 p-4 rounded-lg">
                <h5 class="font-semibold">Ilgalaikiai (1+ metai)</h5>
                <ul>
                  <li>Būsto pirkimas</li>
                  <li>Automobilio keitimas</li>
                  <li>Pensija</li>
                </ul>
              </div>
            </div>
          `,
          duration: '6 min'
        }
      ]
    },
    intermediate: {
      title: 'Turto kūrimas ir finansiniai įrankiai',
      lessons: [
        {
          title: 'Lietuvos pensijų sistema',
          content: `
            <h3>Kaip veikia pensijų sistema Lietuvoje?</h3>
            <p>Lietuvoje veikia 3 pakopų pensijų sistema, skirta užtikrinti orų gyvenimą senatvėje.</p>
            
            <h4>I pakopa - Sodra (privaloma)</h4>
            <ul>
              <li>Valstybės socialinio draudimo pensija</li>
              <li>Finansuojama iš dabartinių darbuotojų įmokų</li>
              <li>2024m. vidutinė pensija - 450€</li>
            </ul>

            <h4>II pakopa - Pensijų fondai (savanoriška)</h4>
            <ul>
              <li>Privatūs pensijų fondai</li>
              <li>2% algos pereina į fondą (vietoj Sodros)</li>
              <li>Galima rinktis konservatyvų ar rizikingesnius fondus</li>
            </ul>

            <div class="bg-yellow-50 border-l-4 border-yellow-400 p-4 my-4">
              <h5>Svarbu žinoti:</h5>
              <p>Jei esate jaunesni nei 40 metų, II pakopa gali būti naudinga, 
              nes lėšos investuojamos ir gali augti daugiau nei infliacija.</p>
            </div>

            <h4>III pakopa - Papildomas taupymas</h4>
            <ul>
              <li>Asmeninis pensijų taupymas</li>
              <li>Mokestinės lengvatos (iki 2,000€ per metus)</li>
              <li>Pilnai kontroliuojate investicijas</li>
            </ul>
          `,
          duration: '8 min'
        }
      ]
    },
    advanced: {
      title: 'Investavimas ir ekonomikos supratimas',
      lessons: [
        {
          title: 'Akcijų rinkos pagrindai',
          content: `
            <h3>Kas yra akcijos?</h3>
            <p>Akcija - tai bendrovės dalies nuosavybės liudijimas. Pirkdami akciją, tampate bendrovės dalininku.</p>
            
            <h4>Akcijų tipai:</h4>
            <ul>
              <li><strong>Paprastosios akcijos</strong> - suteikia balsavimo teises ir dividendų teisę</li>
              <li><strong>Privilegijuotosios akcijos</strong> - prioritetas gaunant dividendus</li>
            </ul>

            <h4>Kaip uždirbti iš akcijų?</h4>
            <ol>
              <li><strong>Kapitalo augimas</strong> - akcijos kainos didėjimas</li>
              <li><strong>Dividendai</strong> - bendrovės pelnų paskirstymas akcininkams</li>
            </ol>

            <div class="bg-blue-50 border border-blue-200 p-4 rounded-lg my-4">
              <h5>Lietuvos akcijų rinka:</h5>
              <p>Nasdaq Vilnius biržoje prekiaujama lietuvių bendrovių akcijomis: 
              Ignitis grupė, Linas Agro, Grigeo ir kt.</p>
            </div>

            <h4>Investavimo principai:</h4>
            <ul>
              <li><strong>Diversifikacija</strong> - nejudėkite visų kiaušinių į vieną krepšį</li>
              <li><strong>Ilgalaikumas</strong> - akcijų rinka ilguoju laikotarpiu auga</li>
              <li><strong>Reguliarumas</strong> - investuokite nuolat, o ne vienkartinėmis sumomis</li>
            </ul>
          `,
          duration: '10 min'
        }
      ]
    }
  };

  const currentModule = modules[level];
  const lesson = currentModule.lessons[currentLesson];
  const isCompleted = userProgress.completedModules.includes(`${level}-${currentLesson}`);

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-6">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>Grįžti į lygius</span>
        </button>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-6">
          <h1 className="text-2xl font-bold mb-2">{currentModule.title}</h1>
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <BookOpen className="h-4 w-4" />
              <span>Pamoka {currentLesson + 1} iš {currentModule.lessons.length}</span>
            </div>
            <div className="flex items-center space-x-2">
              <Play className="h-4 w-4" />
              <span>{lesson.duration}</span>
            </div>
          </div>
        </div>

        <div className="p-8">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-semibold text-gray-900">{lesson.title}</h2>
            {isCompleted && (
              <div className="flex items-center space-x-1 text-green-600">
                <CheckCircle className="h-5 w-5" />
                <span className="text-sm font-medium">Baigta</span>
              </div>
            )}
          </div>

          <div 
            className="prose max-w-none lesson-content"
            dangerouslySetInnerHTML={{ __html: lesson.content }}
          />

          <div className="mt-8 flex justify-between items-center">
            <div className="flex space-x-2">
              {currentModule.lessons.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentLesson(index)}
                  className={`w-3 h-3 rounded-full transition-colors ${
                    index === currentLesson
                      ? 'bg-blue-600'
                      : userProgress.completedModules.includes(`${level}-${index}`)
                      ? 'bg-green-500'
                      : 'bg-gray-300'
                  }`}
                />
              ))}
            </div>

            <div className="flex space-x-4">
              {currentLesson > 0 && (
                <button
                  onClick={() => setCurrentLesson(currentLesson - 1)}
                  className="px-4 py-2 text-gray-600 hover:text-gray-800 transition-colors"
                >
                  Ankstesnė
                </button>
              )}

              {currentLesson < currentModule.lessons.length - 1 ? (
                <button
                  onClick={() => setCurrentLesson(currentLesson + 1)}
                  className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors"
                >
                  Toliau
                </button>
              ) : (
                <button
                  onClick={onStartQuiz}
                  className="bg-gradient-to-r from-emerald-500 to-green-600 text-white px-6 py-2 rounded-lg hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-200 flex items-center space-x-2"
                >
                  <Award className="h-4 w-4" />
                  <span>Pradėti testą</span>
                </button>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};