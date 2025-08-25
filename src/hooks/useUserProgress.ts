import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from './useAuth';

export interface UserProgress {
  id: string;
  user_id: string;
  level: 'beginner' | 'intermediate' | 'advanced';
  completed_modules: string[];
  badges: string[];
  total_points: number;
  current_streak: number;
  created_at: string;
  updated_at: string;
}

export const useUserProgress = () => {
  const { user } = useAuth();
  const [progress, setProgress] = useState<UserProgress | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      fetchProgress();
    } else {
      setProgress(null);
      setLoading(false);
    }
  }, [user]);

  const fetchProgress = async () => {
    if (!user) return;

    let retryCount = 0;
    
    const attemptFetch = async (): Promise<void> => {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('user_progress')
        .select('*')
        .eq('user_id', user.id)
            // Progress doesn't exist, retry with exponential backoff
            if (retryCount < maxRetries) {
              retryCount++;
              setTimeout(() => attemptFetch(), 1000 * retryCount);
              return;
            } else {
              console.error('Progress not found after retries');
              setLoading(false);
              return;
            }
          } else {
            console.error('Error fetching progress:', error);
            setLoading(false);
      if (error) {
        if (error.code === 'PGRST116') {
          setTimeout(() => fetchProgress(), 1000);
          return;
          setLoading(false);
        }
        console.error('Error fetching progress:', error);
        setProgress(data);
      }
    };
    
    setLoading(true);
    await attemptFetch();
    } catch (error) {
      console.error('Error fetching progress:', error);
    } finally {
      setLoading(false);
    }
  };

  const updateProgress = async (updates: Partial<UserProgress>) => {
    if (!user || !progress) return { error: new Error('No user or progress found') };

    const { data, error } = await supabase
      .from('user_progress')
      .update(updates)
      .eq('user_id', user.id)
      .select()
      .single();

    if (!error && data) {
      setProgress(data);
    }

    return { data, error };
  };

  const completeLesson = async (lessonId: string) => {
    if (!user) return { error: new Error('No user logged in') };

    const { data, error } = await supabase
      .from('user_lesson_progress')
      .upsert({
        user_id: user.id,
        lesson_id: lessonId,
        completed_at: new Date().toISOString(),
      });

    return { data, error };
  };

  const completeQuiz = async (courseId: string, score: number, totalQuestions: number, points: number) => {
    if (!progress) return { error: new Error('No progress found') };

    // Record quiz attempt
    const { error: quizError } = await supabase
      .from('user_quiz_attempts')
      .insert({
        user_id: user!.id,
        course_id: courseId,
        score,
        total_questions: totalQuestions,
        points_earned: points,
        completed_at: new Date().toISOString(),
      });

    if (quizError) {
      return { error: quizError };
    }

    // Update user progress
    const newCompletedModules = [...progress.completed_modules];
    if (!newCompletedModules.includes(courseId)) {
      newCompletedModules.push(courseId);
    }

    const newTotalPoints = progress.total_points + points;
    const newStreak = progress.current_streak + 1;

    // Award badges based on achievements
    const newBadges = [...progress.badges];
    if (newCompletedModules.length === 5 && !newBadges.includes('first_five')) {
      newBadges.push('first_five');
    }
    if (newTotalPoints >= 1000 && !newBadges.includes('point_master')) {
      newBadges.push('point_master');
    }
    if (newStreak >= 7 && !newBadges.includes('week_streak')) {
      newBadges.push('week_streak');
    }

    return await updateProgress({
      completed_modules: newCompletedModules,
      badges: newBadges,
      total_points: newTotalPoints,
      current_streak: newStreak,
    });
  };

  const isLessonCompleted = async (lessonId: string): Promise<boolean> => {
    if (!user) return false;

    const { data, error } = await supabase
      .from('user_lesson_progress')
      .select('id')
      .eq('user_id', user.id)
      .eq('lesson_id', lessonId)
      .single();

    return !error && !!data;
  };

  const resetProgress = async () => {
    if (!user) return { error: new Error('No user logged in') };

    // Clear lesson progress
    await supabase
      .from('user_lesson_progress')
      .delete()
      .eq('user_id', user.id);

    // Clear quiz attempts
    await supabase
      .from('user_quiz_attempts')
      .delete()
      .eq('user_id', user.id);

    // Reset main progress
    return await updateProgress({
      level: 'beginner',
      completed_modules: [],
      badges: [],
      total_points: 0,
      current_streak: 0,
    });
  };

  return {
    progress,
    loading,
    updateProgress,
    completeLesson,
    completeQuiz,
    isLessonCompleted,
    resetProgress,
    refetch: fetchProgress,
  };
};