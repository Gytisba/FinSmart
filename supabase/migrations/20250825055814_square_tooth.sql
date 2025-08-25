/*
  # Create courses system tables

  1. New Tables
    - `courses` - Main course information
    - `course_modules` - Course modules/chapters
    - `course_lessons` - Individual lessons within modules
    - `course_quiz_questions` - Quiz questions for courses
    - `course_quiz_options` - Multiple choice options for quiz questions
    - `user_lesson_progress` - Track user lesson completion
    - `user_quiz_attempts` - Track user quiz attempts

  2. Security
    - Enable RLS on all tables
    - Add policies for public access to published content
    - Add policies for authenticated user progress tracking
*/

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  title text NOT NULL,
  level course_level NOT NULL DEFAULT 'beginner',
  summary text,
  cover_url text,
  status content_status NOT NULL DEFAULT 'draft',
  created_by uuid NOT NULL REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  published_at timestamptz
);

-- Create course_modules table
CREATE TABLE IF NOT EXISTS course_modules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  order_index integer NOT NULL,
  duration_minutes integer DEFAULT 30,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course_lessons table
CREATE TABLE IF NOT EXISTS course_lessons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id uuid NOT NULL REFERENCES course_modules(id) ON DELETE CASCADE,
  title text NOT NULL,
  content text NOT NULL,
  order_index integer NOT NULL,
  duration_minutes integer DEFAULT 15,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course_quiz_questions table
CREATE TABLE IF NOT EXISTS course_quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  question text NOT NULL,
  explanation text,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course_quiz_options table
CREATE TABLE IF NOT EXISTS course_quiz_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid NOT NULL REFERENCES course_quiz_questions(id) ON DELETE CASCADE,
  option_text text NOT NULL,
  is_correct boolean DEFAULT false,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user_lesson_progress table
CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  lesson_id uuid NOT NULL REFERENCES course_lessons(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, lesson_id)
);

-- Create user_quiz_attempts table
CREATE TABLE IF NOT EXISTS user_quiz_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  course_id uuid NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  score integer NOT NULL,
  total_questions integer NOT NULL,
  points_earned integer NOT NULL,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS courses_level_idx ON courses(level);
CREATE INDEX IF NOT EXISTS courses_status_idx ON courses(status);
CREATE INDEX IF NOT EXISTS course_modules_course_id_idx ON course_modules(course_id);
CREATE INDEX IF NOT EXISTS course_lessons_module_id_idx ON course_lessons(module_id);
CREATE INDEX IF NOT EXISTS course_quiz_questions_course_id_idx ON course_quiz_questions(course_id);
CREATE INDEX IF NOT EXISTS course_quiz_options_question_id_idx ON course_quiz_options(question_id);
CREATE INDEX IF NOT EXISTS user_lesson_progress_user_id_idx ON user_lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS user_quiz_attempts_user_id_idx ON user_quiz_attempts(user_id);

-- Enable RLS
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_quiz_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quiz_attempts ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can view published courses" ON courses;
DROP POLICY IF EXISTS "Anyone can view course modules" ON course_modules;
DROP POLICY IF EXISTS "Anyone can view course lessons" ON course_lessons;
DROP POLICY IF EXISTS "Anyone can view quiz questions" ON course_quiz_questions;
DROP POLICY IF EXISTS "Anyone can view quiz options" ON course_quiz_options;
DROP POLICY IF EXISTS "Users can manage own lesson progress" ON user_lesson_progress;
DROP POLICY IF EXISTS "Users can manage own quiz attempts" ON user_quiz_attempts;

-- Create RLS policies
CREATE POLICY "Anyone can view published courses"
  ON courses FOR SELECT
  TO public
  USING (status = 'published');

CREATE POLICY "Anyone can view course modules"
  ON course_modules FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM courses 
      WHERE courses.id = course_modules.course_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view course lessons"
  ON course_lessons FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM course_modules 
      JOIN courses ON courses.id = course_modules.course_id
      WHERE course_modules.id = course_lessons.module_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view quiz questions"
  ON course_quiz_questions FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM courses 
      WHERE courses.id = course_quiz_questions.course_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view quiz options"
  ON course_quiz_options FOR SELECT
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM course_quiz_questions 
      JOIN courses ON courses.id = course_quiz_questions.course_id
      WHERE course_quiz_questions.id = course_quiz_options.question_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Users can manage own lesson progress"
  ON user_lesson_progress FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage own quiz attempts"
  ON user_quiz_attempts FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);