import React, { useState, useEffect } from 'react';
import { ArrowLeft, CheckCircle, XCircle, Award, Trophy } from 'lucide-react';
import { Level } from '../App';
import { useCourses } from '../hooks/useCourses';
import { useUserProgress } from '../hooks/useUserProgress';

interface QuizProps {
  level: Level;
  moduleId: string;
  onComplete: (moduleId: string, points: number) => void;
  onBack: () => void;
}

export const Quiz: React.FC<QuizProps> = ({ level, onComplete, onBack }) => {
  const { getCourseByLevel, fetchQuizQuestions } = useCourses();
  const { completeQuiz } = useUserProgress();
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [selectedAnswers, setSelectedAnswers] = useState<number[]>([]);
  const [showResults, setShowResults] = useState(false);
  const [score, setScore] = useState(0);
  const [questions, setQuestions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadQuizData();
  }, [level]);

  const loadQuizData = async () => {
    setLoading(true);
    const course = getCourseByLevel(level);
    if (course) {
      const quizQuestions = await fetchQuizQuestions(course.id);
      setQuestions(quizQuestions);
    }
    setLoading(false);
  };

  if (loading) {
    return (
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Kraunamas testas...</p>
        </div>
      </div>
    );
  }

  if (questions.length === 0) {
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
        <div className="text-center">
          <p className="text-gray-600">Testas nerastas šiam lygiui.</p>
        </div>
      </div>
    );
  }

  const course = getCourseByLevel(level);
  const question = questions[currentQuestion];

  const handleAnswerSelect = (answerIndex: number) => {
    const newAnswers = [...selectedAnswers];
    newAnswers[currentQuestion] = answerIndex;
    setSelectedAnswers(newAnswers);
  };

  const handleNext = () => {
    if (currentQuestion < questions.length - 1) {
      setCurrentQuestion(currentQuestion + 1);
    } else {
      calculateScore();
    }
  };

  const calculateScore = async () => {
    const correctAnswers = selectedAnswers.filter((answer, index) => 
      answer === questions[index].options.findIndex((opt: any) => opt.is_correct)
    ).length;
    
    const finalScore = Math.round((correctAnswers / questions.length) * 100);
    setScore(finalScore);
    
    // Save quiz attempt
    const points = Math.max(10, finalScore);
    if (course) {
      await completeQuiz(course.id, finalScore, questions.length, points);
    }
    
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
              {questions.map((q, index) => {
                const userAnswer = selectedAnswers[index];
                const correctAnswerIndex = q.options.findIndex((opt: any) => opt.is_correct);
                const isCorrect = userAnswer === correctAnswerIndex;
                
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
                          Jūsų atsakymas: {q.options[userAnswer]?.option_text}
                        </p>
                        {!isCorrect && (
                          <p className="text-sm text-green-600 mb-2">
                            Teisingas atsakymas: {q.options[correctAnswerIndex]?.option_text}
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
                onClick={() => onComplete(course?.id || '', points)}
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
          <h1 className="text-xl font-bold mb-2">{course?.title} - Testas</h1>
          <div className="flex items-center justify-between">
            <span>Klausimas {currentQuestion + 1} iš {questions.length}</span>
            <div className="w-32 bg-white bg-opacity-30 rounded-full h-2">
              <div
                className="bg-white h-2 rounded-full transition-all duration-300"
                style={{ width: `${((currentQuestion + 1) / questions.length) * 100}%` }}
              />
            </div>
          </div>
        </div>

        <div className="p-8">
          <h2 className="text-xl font-semibold text-gray-900 mb-8">
            {question.question}
          </h2>

          <div className="space-y-4 mb-8">
            {question.options.map((option: any, index: number) => (
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
                  <span className="text-gray-900">{option.option_text}</span>
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
              {currentQuestion < questions.length - 1 ? 'Toliau' : 'Baigti testą'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};