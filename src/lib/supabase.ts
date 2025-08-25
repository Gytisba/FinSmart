import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase environment variables');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export type Database = {
  public: {
    Tables: {
      user_profiles: {
        Row: {
          id: string;
          email: string;
          full_name: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id: string;
          email: string;
          full_name?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          email?: string;
          full_name?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      user_progress: {
        Row: {
          id: string;
          user_id: string;
          level: 'beginner' | 'intermediate' | 'advanced';
          completed_modules: string[];
          badges: string[];
          total_points: number;
          current_streak: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          level?: 'beginner' | 'intermediate' | 'advanced';
          completed_modules?: string[];
          badges?: string[];
          total_points?: number;
          current_streak?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          level?: 'beginner' | 'intermediate' | 'advanced';
          completed_modules?: string[];
          badges?: string[];
          total_points?: number;
          current_streak?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      courses: {
        Row: {
          id: string;
          slug: string;
          title: string;
          level: 'beginner' | 'intermediate' | 'advanced';
          summary: string | null;
          cover_url: string | null;
          status: 'draft' | 'published' | 'archived';
          created_by: string;
          created_at: string;
          updated_at: string;
          published_at: string | null;
        };
        Insert: {
          id?: string;
          slug: string;
          title: string;
          level: 'beginner' | 'intermediate' | 'advanced';
          summary?: string | null;
          cover_url?: string | null;
          status?: 'draft' | 'published' | 'archived';
          created_by: string;
          created_at?: string;
          updated_at?: string;
          published_at?: string | null;
        };
        Update: {
          id?: string;
          slug?: string;
          title?: string;
          level?: 'beginner' | 'intermediate' | 'advanced';
          summary?: string | null;
          cover_url?: string | null;
          status?: 'draft' | 'published' | 'archived';
          created_by?: string;
          created_at?: string;
          updated_at?: string;
          published_at?: string | null;
        };
      };
      course_modules: {
        Row: {
          id: string;
          course_id: string;
          title: string;
          description: string | null;
          order_index: number;
          duration_minutes: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          course_id: string;
          title: string;
          description?: string | null;
          order_index: number;
          duration_minutes?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          course_id?: string;
          title?: string;
          description?: string | null;
          order_index?: number;
          duration_minutes?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      course_lessons: {
        Row: {
          id: string;
          module_id: string;
          title: string;
          content: string;
          order_index: number;
          duration_minutes: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          module_id: string;
          title: string;
          content: string;
          order_index: number;
          duration_minutes?: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          module_id?: string;
          title?: string;
          content?: string;
          order_index?: number;
          duration_minutes?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      course_quiz_questions: {
        Row: {
          id: string;
          course_id: string;
          question: string;
          explanation: string | null;
          order_index: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          course_id: string;
          question: string;
          explanation?: string | null;
          order_index: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          course_id?: string;
          question?: string;
          explanation?: string | null;
          order_index?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      course_quiz_options: {
        Row: {
          id: string;
          question_id: string;
          option_text: string;
          is_correct: boolean;
          order_index: number;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          question_id: string;
          option_text: string;
          is_correct?: boolean;
          order_index: number;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          question_id?: string;
          option_text?: string;
          is_correct?: boolean;
          order_index?: number;
          created_at?: string;
          updated_at?: string;
        };
      };
      user_lesson_progress: {
        Row: {
          id: string;
          user_id: string;
          lesson_id: string;
          completed_at: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          lesson_id: string;
          completed_at?: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          lesson_id?: string;
          completed_at?: string;
          created_at?: string;
        };
      };
      user_quiz_attempts: {
        Row: {
          id: string;
          user_id: string;
          course_id: string;
          score: number;
          total_questions: number;
          points_earned: number;
          completed_at: string;
          created_at: string;
        };
        Insert: {
          id?: string;
          user_id: string;
          course_id: string;
          score: number;
          total_questions: number;
          points_earned: number;
          completed_at?: string;
          created_at?: string;
        };
        Update: {
          id?: string;
          user_id?: string;
          course_id?: string;
          score?: number;
          total_questions?: number;
          points_earned?: number;
          completed_at?: string;
          created_at?: string;
        };
      };
    };
  };
};