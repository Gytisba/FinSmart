import React, { useState, useEffect } from 'react';
import { ArrowLeft, BookOpen, Clock, CheckCircle, Play, Award } from 'lucide-react';
import { Level, UserProgress } from '../App';
import { useCourses } from '../hooks/useCourses';

interface CourseOverviewProps {
  level: Level;
  userProgress: UserProgress;
  onModuleSelect: (moduleId: string) => void;
  onBack: () => void;
}

export const CourseOverview: React.FC<CourseOverviewProps> = ({
  level,
  userProgress,
  onModuleSelect,
  onBack
}) => {
  const { getCourseByLevel, fetchCourseModules, loading: coursesLoading } = useCourses();
  const [modules, setModules] = useState<any[]>([]);
  const [modulesLoading, setModulesLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Wait for courses to load before trying to load modules
  useEffect(() => {
    if (!coursesLoading) {
      loadCourseModules();
    }
  }, [level, coursesLoading]);

  const loadCourseModules = async () => {
    setModulesLoading(true);
    setError(null);
    
    try {
      const course = getCourseByLevel(level);
      
      if (course) {
        const courseModules = await fetchCourseModules(course.id);
        setModules(courseModules);
        
        if (courseModules.length === 0) {
          setError('Moduliai nerasti šiam kursui');
        }
      } else {
        setError('Kursas nerastas šiam lygiui');
      }
    } catch (err) {
      console.error('Error loading course modules:', err);
      setError('Klaida kraunant kurso modulius');
    } finally {
      setModulesLoading(false);
    }
  };

  // Show loading if either courses or modules are loading
  if (coursesLoading || modulesLoading) {
    return (
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="text-center">
          <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">{coursesLoading ? 'Kraunami kursai...' : 'Kraunami moduliai...'}</p>
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
            onClick={loadCourseModules}
            className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700"
          >
            Bandyti dar kartą
          </button>
        </div>
      </div>
    );
  }

  const course = getCourseByLevel(level);
  const totalDuration = modules.reduce((sum, module) => sum + module.duration_minutes, 0);
  const completedModules = userProgress.completedModules.filter(moduleId => 
    modules.some(module => module.id === moduleId)
  ).length;

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
        {/* Course Header */}
        <div className="bg-gradient-to-r from-emerald-500 to-green-600 text-white p-8">
          <div className="flex items-center space-x-4 mb-4">
            <div className="bg-white bg-opacity-20 rounded-full p-3">
              <BookOpen className="h-8 w-8" />
            </div>
            <div>
              <h1 className="text-3xl font-bold">{course?.title}</h1>
              <p className="text-emerald-100">{course?.summary}</p>
            </div>
          </div>
          
          <div className="grid grid-cols-3 gap-6 mt-6">
            <div className="text-center">
              <div className="text-2xl font-bold">{modules.length}</div>
              <div className="text-emerald-200 text-sm">Moduliai</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold">{Math.round(totalDuration / 60)}h</div>
              <div className="text-emerald-200 text-sm">Trukmė</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold">{completedModules}/{modules.length}</div>
              <div className="text-emerald-200 text-sm">Baigta</div>
            </div>
          </div>
        </div>

        {/* Progress Bar */}
        <div className="p-6 border-b border-gray-200">
          <div className="flex justify-between text-sm text-gray-600 mb-2">
            <span>Kurso pažanga</span>
            <span>{Math.round((completedModules / modules.length) * 100)}%</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-3">
            <div
              className="bg-gradient-to-r from-emerald-500 to-green-600 h-3 rounded-full transition-all duration-500"
              style={{ width: `${(completedModules / modules.length) * 100}%` }}
            ></div>
          </div>
        </div>

        {/* Modules List */}
        <div className="p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Kurso moduliai</h2>
          <div className="space-y-4">
            {modules.map((module, index) => {
              const isCompleted = userProgress.completedModules.includes(module.id);
              const isLocked = index > 0 && !userProgress.completedModules.includes(modules[index - 1].id);
              
              return (
                <div
                  key={module.id}
                  className={`border rounded-xl p-6 transition-all duration-200 ${
                    isLocked 
                      ? 'bg-gray-50 border-gray-200 opacity-60' 
                      : 'bg-white border-gray-200 hover:border-emerald-300 hover:shadow-md cursor-pointer'
                  }`}
                  onClick={() => !isLocked && onModuleSelect(module.id)}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-4">
                      <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                        isCompleted 
                          ? 'bg-emerald-100 text-emerald-600' 
                          : isLocked 
                          ? 'bg-gray-100 text-gray-400'
                          : 'bg-blue-100 text-blue-600'
                      }`}>
                        {isCompleted ? (
                          <CheckCircle className="h-6 w-6" />
                        ) : isLocked ? (
                          <span className="text-sm font-bold">{index + 1}</span>
                        ) : (
                          <Play className="h-6 w-6" />
                        )}
                      </div>
                      
                      <div>
                        <h3 className={`text-lg font-semibold ${
                          isLocked ? 'text-gray-400' : 'text-gray-900'
                        }`}>
                          {module.title}
                        </h3>
                        <p className={`text-sm ${
                          isLocked ? 'text-gray-400' : 'text-gray-600'
                        }`}>
                          {module.description}
                        </p>
                        <div className={`flex items-center space-x-4 mt-2 text-xs ${
                          isLocked ? 'text-gray-400' : 'text-gray-500'
                        }`}>
                          <div className="flex items-center space-x-1">
                            <Clock className="h-3 w-3" />
                            <span>{module.duration_minutes} min</span>
                          </div>
                          <div className="flex items-center space-x-1">
                            <BookOpen className="h-3 w-3" />
                            <span>Modulis {index + 1}</span>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center space-x-2">
                      {isCompleted && (
                        <div className="flex items-center space-x-1 text-emerald-600 bg-emerald-50 px-3 py-1 rounded-full">
                          <Award className="h-4 w-4" />
                          <span className="text-sm font-medium">Baigta</span>
                        </div>
                      )}
                      {isLocked && (
                        <div className="text-gray-400 bg-gray-100 px-3 py-1 rounded-full">
                          <span className="text-sm">Užrakinta</span>
                        </div>
                      )}
                      {!isCompleted && !isLocked && (
                        <div className="text-blue-600">
                          <Play className="h-5 w-5" />
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};

export { CourseOverview }