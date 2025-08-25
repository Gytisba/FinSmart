import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { Level } from '../App';

export interface Course {
  id: string;
  level: Level;
  title: string;
  subtitle: string | null;
  description: string | null;
  color_from: string;
  color_to: string;
  icon: string;
  total_modules: number;
  modules?: CourseModule[];
}

export interface CourseModule {
  id: string;
  course_id: string;
  title: string;
  description: string | null;
  order_index: number;
  duration_minutes: number;
  lessons?: CourseLesson[];
}

export interface CourseLesson {
  id: string;
  module_id: string;
  title: string;
  content: string;
  order_index: number;
  duration_minutes: number;
}

export interface QuizQuestion {
  id: string;
  course_id: string;
  question: string;
  explanation: string | null;
  order_index: number;
  options: QuizOption[];
}

export interface QuizOption {
  id: string;
  question_id: string;
  option_text: string;
  is_correct: boolean;
  order_index: number;
}

export const useCourses = () => {
  const [courses, setCourses] = useState<Course[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const { data, error } = await supabase
        .from('courses')
        .select('*')
        .order('created_at');


      if (error) {
        console.error('Error fetching courses:', error);
        setError(error.message);
        setCourses([]);
      } else {
        setCourses(data || []);
      }
    } catch (err) {
      console.error('Error fetching courses:', err);
      setError('Network error');
      setCourses([]);
    } finally {
      setLoading(false);
    }
  };

  const getCourseByLevel = (level: Level): Course | null => {
    return courses.find(course => course.level === level) || null;
  };

  const fetchCourseModules = async (courseId: string): Promise<CourseModule[]> => {
    try {
      const { data, error } = await supabase
        .from('course_modules')
        .select('*')
        .eq('course_id', courseId)
        .order('order_index');

      if (error) {
        console.error('Error fetching course modules:', error);
        return [];
      }

      return data || [];
    } catch (err) {
      console.error('Error fetching course modules:', err);
      return [];
    }
  };

  const fetchModuleLessons = async (moduleId: string): Promise<CourseLesson[]> => {
    try {
      const { data, error } = await supabase
        .from('course_lessons')
        .select('*')
        .eq('module_id', moduleId)
        .order('order_index');

      if (error) {
        console.error('Error fetching module lessons:', error);
        return [];
      }

      return data || [];
    } catch (err) {
      console.error('Error fetching module lessons:', err);
      return [];
    }
  };

  const fetchQuizQuestions = async (courseId: string): Promise<QuizQuestion[]> => {
    try {
      const { data, error } = await supabase
        .from('course_quiz_questions')
        .select(`
          *,
          course_quiz_options (*)
        `)
        .eq('course_id', courseId)
        .order('order_index');

      if (error) {
        console.error('Error fetching quiz questions:', error);
        return [];
      }

      return (data || []).map(question => ({
        ...question,
        options: (question.course_quiz_options || []).sort((a: any, b: any) => a.order_index - b.order_index)
      }));
    } catch (err) {
      console.error('Error fetching quiz questions:', err);
      return [];
    }
  };

  return {
    courses,
    loading,
    error,
    getCourseByLevel,
    fetchCourseModules,
    fetchModuleLessons,
    fetchQuizQuestions,
    refetch: fetchCourses,
  };
};