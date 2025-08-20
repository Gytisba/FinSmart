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

    try {
      const { data, error } = await supabase
        .from('user_progress')
        .select('*')
        .eq('user_id', user.id)
        .single();

      if (error) {
        console.error('Error fetching progress:', error);
      } else {
        setProgress(data);
      }
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

  const completeModule = async (moduleId: string, points: number) => {
    if (!progress) return { error: new Error('No progress found') };

    const newCompletedModules = [...progress.completed_modules];
    if (!newCompletedModules.includes(moduleId)) {
      newCompletedModules.push(moduleId);
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

  const resetProgress = async () => {
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
    completeModule,
    resetProgress,
    refetch: fetchProgress,
  };
};