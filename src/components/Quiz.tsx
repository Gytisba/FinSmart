import React, { useState, useEffect } from 'react';
import { ArrowLeft, CheckCircle, XCircle, Award, Trophy } from 'lucide-react';
import { Level } from '../App';

interface QuizProps {
  level: Level;
  moduleId: string;
  onComplete: (moduleId: string, points: number) => void;
  onBack: () => void;
}

export const Quiz: React.FC<QuizProps> = ({ level, onComplete, onBack }) => {
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [selectedAnswers, setSelectedAnswers] = useState<number[]>([]);
  const [showResults, setShowResults] = useState(false);
  const [score, setScore] = useState(0);

  const quizzes = {
    beginner: {
      title: 'Asmeninių finansų pagrindų testas',
      questions: [
        {
          question: 'Kas yra infliacija?',
          options: [
            'Kainų mažėjimas laike',
            'Kainų augimas laike',
            'Valiutos keitimo kursas',
            'Banko palūkanų norma'
          ],
          correct: 1,
          explanation: 'Infliacija - tai kainų augimas laike, kuris mažina pinigų perkamąją galią.'
        },
        {
          question: 'Kiek procentų pajamų rekomenduojama skirti taupymui pagal 50/30/20 taisyklę?',
          options: ['10%', '15%', '20%', '25%'],
          correct: 2,
          explanation: '50/30/20 taisyklė rekomenduoja 20% pajamų skirti taupymui ir investicijoms.'
        },
        {
          question: 'Koks yra nepamirštamųjų fondo rekomenduojamas dydis?',
          options: [
            '1-2 mėnesių išlaidos',
            '3-6 mėnesių išlaidos',
            '1 metų išlaidos',
            '2 metų išlaidos'
          ],
          correct: 1,
          explanation: 'Nepamirštamųjų fondas turėtų padengti 3-6 mėnesių būtinąsias išlaidas.'
        },
        {
          question: 'Kuris banko sąskaitos tipas tinkamesnis taupymui?',
          options: [
            'Einamoji sąskaita',
            'Taupomoji sąskaita',
            'Kreditinė sąskaita',
            'Visi vienodai tinkami'
          ],
          correct: 1,
          explanation: 'Taupomoji sąskaita paprastai moka palūkanas ir skatina taupyti.'
        }
      ]
    },
    intermediate: {
      title: 'Turto kūrimo ir finansinių įrankių testas',
      questions: [
        {
          question: 'Kiek pakopų turi Lietuvos pensijų sistema?',
          options: ['2', '3', '4', '5'],
          correct: 1,
          explanation: 'Lietuvos pensijų sistema turi 3 pakopas: Sodra, privačių fondų ir asmeninis taupymas.'
        },
        {
          question: 'Kas yra sudėtinės palūkanos?',
          options: [
            'Palūkanos, mokamos tik nuo pradinės sumos',
            'Palūkanos, mokamos nuo pradinės sumos ir anksčiau gautų palūkanų',
            'Banko mokestis už paslaugas',
            'Valiutos keitimo mokestis'
          ],
          correct: 1,
          explanation: 'Sudėtinės palūkanos - palūkanos, mokamos nuo pradinės sumos ir anksčiau sukauptų palūkanų.'
        }
      ]
    },
    advanced: {
      title: 'Investavimo ir ekonomikos supratimo testas',
      questions: [
        {
          question: 'Kas yra diversifikacija?',
          options: [
            'Investavimas tik į vieną bendrovę',
            'Rizikos paskirstymas tarp skirtingų investicijų',
            'Akcijų pirkimas ir pardavimas per dieną',
            'Investavimas tik į būstą'
          ],
          correct: 1,
          explanation: 'Diversifikacija - rizikos paskirstymas investuojant į skirtingas bendrovės, sektorius ar regiones.'
        }
      ]
    }
  };

  const currentQuiz = quizzes[level];
  const question = currentQuiz.questions[currentQuestion];

  const handleAnswerSelect = (answerIndex: number) => {
    const newAnswers = [...selectedAnswers];
    newAnswers[currentQuestion] = answerIndex;
    setSelectedAnswers(newAnswers);
  };

  const handleNext = () => {
    if (currentQuestion < currentQuiz.questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1);
    } else {
      calculateScore();
    }
  };

  const calculateScore = () => {
    const correctAnswers = selectedAnswers.filter((answer, index) => 
      answer === currentQuiz.questions[index].correct
    ).length;
    
    const finalScore = Math.round((correctAnswers / currentQuiz.questions.length) * 100);
    setScore(finalScore);
    setShowResults(true);
  };

  const getScoreColor = (score: number) => {
    if (score >= 80) return 'text-green-600';
    if (score >= 60) return 'text-yellow-600';
    return 'text-red-600';
  };

  const getScoreMessage = (score: number) => {
    if (score >= 90) return 'Puiku! Jūs puikiai išmanote šią temą! 🎉';
    if (score >= 80) return 'Labai gerai! Tik keli niuansai liko neaiškūs. 👍';
    if (score >= 60) return 'Gerai, bet dar yra ką mokytis. 📚';
    return 'Rekomenduojame pakartoti medžiagą ir bandyti dar kartą. 💪';
  };

  if (showResults) {
    const points = Math.max(10, score);
    
    return (
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-xl shadow-lg overflow-hidden">
          <div className="bg-gradient-to-r from-purple-600 to-pink-600 text-white p-8 text-center">
            <Trophy className="h-16 w-16 mx-auto mb-4" />
            <h1 className="text-2xl font-bold mb-2">Testas baigtas!</h1>
            <p className="text-purple-100">Puiki veikla! Jūsų rezultatai:</p>
          </div>

          <div className="p-8">
            <div className="text-center mb-8">
              <div className={`text-6xl font-bold mb-4 ${getScoreColor(score)}`}>
                {score}%
              </div>
              <p className="text-xl text-gray-700 mb-4">
                {getScoreMessage(score)}
              </p>
              <div className="flex items-center justify-center space-x-2 text-emerald-600">
                <Award className="h-5 w-5" />
                <span className="font-semibold">+{points} taškai</span>
              </div>
            </div>

            <div className="space-y-4 mb-8">
              <h3 className="text-lg font-semibold text-gray-900">Testo rezultatai:</h3>
              {currentQuiz.questions.map((q, index) => {
                const userAnswer = selectedAnswers[index];
                const isCorrect = userAnswer === q.correct;
                
                return (
                  <div key={index} className="border rounded-lg p-4">
                    <div className="flex items-start space-x-3">
                      {isCorrect ? (
                        <CheckCircle className="h-5 w-5 text-green-500 mt-0.5" />
                      ) : (
                        <XCircle className="h-5 w-5 text-red-500 mt-0.5" />
                      )}
                      <div className="flex-1">
                        <p className="font-medium text-gray-900 mb-2">{q.question}</p>
                        <p className={`text-sm mb-2 ${isCorrect ? 'text-green-600' : 'text-red-600'}`}>
                          Jūsų atsakymas: {q.options[userAnswer]}
                        </p>
                        {!isCorrect && (
                          <p className="text-sm text-green-600 mb-2">
                            Teisingas atsakymas: {q.options[q.correct]}
                          </p>
                        )}
                        <p className="text-sm text-gray-600">{q.explanation}</p>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="flex space-x-4">
              <button
                onClick={() => onComplete(`${level}-quiz`, points)}
                className="flex-1 bg-gradient-to-r from-emerald-500 to-green-600 text-white py-3 rounded-lg hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-200"
              >
                Tęsti mokymosi
              </button>
              <button
                onClick={onBack}
                className="px-6 py-3 text-gray-600 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
              >
                Grįžti
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-6">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>Grįžti į pamoką</span>
        </button>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="bg-gradient-to-r from-emerald-600 to-blue-600 text-white p-6">
          <h1 className="text-xl font-bold mb-2">{currentQuiz.title}</h1>
          <div className="flex items-center justify-between">
            <span>Klausimas {currentQuestion + 1} iš {currentQuiz.questions.length}</span>
            <div className="w-32 bg-white bg-opacity-30 rounded-full h-2">
              <div
                className="bg-white h-2 rounded-full transition-all duration-300"
                style={{ width: `${((currentQuestion + 1) / currentQuiz.questions.length) * 100}%` }}
              />
            </div>
          </div>
        </div>

        <div className="p-8">
          <h2 className="text-xl font-semibold text-gray-900 mb-8">
            {question.question}
          </h2>

          <div className="space-y-4 mb-8">
            {question.options.map((option, index) => (
              <button
                key={index}
                onClick={() => handleAnswerSelect(index)}
                className={`w-full text-left p-4 rounded-lg border-2 transition-all duration-200 ${
                  selectedAnswers[currentQuestion] === index
                    ? 'border-blue-500 bg-blue-50'
                    : 'border-gray-200 hover:border-gray-300 hover:bg-gray-50'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <div className={`w-4 h-4 rounded-full border-2 ${
                    selectedAnswers[currentQuestion] === index
                      ? 'border-blue-500 bg-blue-500'
                      : 'border-gray-300'
                  }`}>
                    {selectedAnswers[currentQuestion] === index && (
                      <div className="w-full h-full rounded-full bg-white scale-50" />
                    )}
                  </div>
                  <span className="text-gray-900">{option}</span>
                </div>
              </button>
            ))}
          </div>

          <div className="flex justify-end">
            <button
              onClick={handleNext}
              disabled={selectedAnswers[currentQuestion] === undefined}
              className="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
            >
              {currentQuestion < currentQuiz.questions.length - 1 ? 'Toliau' : 'Baigti testą'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};