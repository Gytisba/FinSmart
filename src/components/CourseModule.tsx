import React, { useState } from 'react';
import { ArrowLeft, Play, CheckCircle, BookOpen, Award } from 'lucide-react';
import { Level, UserProgress } from '../App';
import { useCourses } from '../hooks/useCourses';
import { useUserProgress } from '../hooks/useUserProgress';

interface CourseModuleProps {
  level: Level;
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
  const { getCourseByLevel, fetchCourseModules, fetchModuleLessons } = useCourses();
  const { completeLesson } = useUserProgress();
  const [currentLesson, setCurrentLesson] = useState(0);
  const [modules, setModules] = useState<any[]>([]);
  const [lessons, setLessons] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  React.useEffect(() => {
    loadCourseData();
  }, [level]);

  const loadCourseData = async () => {
    setLoading(true);
    setError(null);
    
    try {
      console.log('Found course:', course);
      
    const course = getCourseByLevel(level);
    if (course) {
        console.log('Found modules:', courseModules);
      const courseModules = await fetchCourseModules(course.id);
      setModules(courseModules);
      
      if (courseModules.length > 0) {
          console.log('Found lessons:', moduleLessons);
        const moduleLessons = await fetchModuleLessons(courseModules[0].id);
        } else {
          setError('Moduliai nerasti šiam kursui');
        setLessons(moduleLessons);
      } else {
        setError('Kursas nerastas šiam lygiui');
      }
    } catch (err) {
      console.error('Error loading course data:', err);
      setError('Klaida kraunant kurso duomenis');
    } finally {
    }
    setLoading(false);
    }
  };

  const handleLessonComplete = async (lessonId: string) => {
    await completeLesson(lessonId);
  };

  if (loading) {
    return (
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Kraunama pamoka...</p>
        </div>
      </div>
    );
  }

  if (error) {
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
        <div className="text-center">
          <p className="text-red-600 mb-4">{error}</p>
          <button 
            onClick={loadCourseData}
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
          >
            Bandyti dar kartą
          </button>
        </div>
      </div>
    );
  }

  if (lessons.length === 0) {
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
        <div className="text-center">
          <p className="text-gray-600">Pamokos nerastos šiam lygiui.</p>
          <p className="text-sm text-gray-500 mt-2">Moduliai: {modules.length}</p>
        </div>
      </div>
    );
  }

  const course = getCourseByLevel(level);
  const lesson = lessons[currentLesson];
  const isCompleted = false; // TODO: Check if lesson is completed

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
          <h1 className="text-2xl font-bold mb-2">{course?.title}</h1>
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <BookOpen className="h-4 w-4" />
              <span>Pamoka {currentLesson + 1} iš {lessons.length}</span>
            </div>
            <div className="flex items-center space-x-2">
              <Play className="h-4 w-4" />
              <span>{lesson.duration_minutes} min</span>
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
              {lessons.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentLesson(index)}
                  className={`w-3 h-3 rounded-full transition-colors ${
                    index === currentLesson
                      ? 'bg-blue-600'
                      : false // TODO: Check if lesson is completed
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

              {currentLesson < lessons.length - 1 ? (
                <button
                  onClick={() => {
                    handleLessonComplete(lesson.id);
                    setCurrentLesson(currentLesson + 1);
                  }}
                  className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors"
                >
                  Toliau
                </button>
              ) : (
                <button
                  onClick={() => {
                    handleLessonComplete(lesson.id);
                    onStartQuiz();
                  }}
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