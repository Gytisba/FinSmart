/*
  # Fix Courses Table RLS Policy

  1. Security Changes
    - Drop existing problematic RLS policy on courses table
    - Create new policy allowing anonymous users to read published courses
    - Ensure policy doesn't reference auth.users table for anonymous access

  2. Changes Made
    - Allow SELECT access for anonymous users on published courses
    - Maintain existing author/admin permissions for course management
*/

-- Drop the existing problematic policy
DROP POLICY IF EXISTS "Authors can manage their courses" ON courses;
DROP POLICY IF EXISTS "Anyone can view published courses" ON courses;

-- Create a simple policy for anonymous users to read published courses
CREATE POLICY "Anyone can view published courses"
  ON courses
  FOR SELECT
  TO anon, authenticated
  USING (status = 'published');

-- Create a separate policy for authenticated users to manage their own courses
CREATE POLICY "Authors can manage their courses"
  ON courses
  FOR ALL
  TO authenticated
  USING (
    auth.uid() = created_by OR 
    EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND (auth.users.raw_user_meta_data->>'role')::text IN ('admin', 'author')
    )
  )
  WITH CHECK (
    auth.uid() = created_by OR 
    EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND (auth.users.raw_user_meta_data->>'role')::text IN ('admin', 'author')
    )
  );

-- Also ensure related tables have proper policies for anonymous access
DROP POLICY IF EXISTS "Anyone can view course modules" ON course_modules;
DROP POLICY IF EXISTS "Anyone can view course lessons" ON course_lessons;
DROP POLICY IF EXISTS "Anyone can view quiz questions" ON course_quiz_questions;
DROP POLICY IF EXISTS "Anyone can view quiz options" ON course_quiz_options;

-- Allow anonymous users to read course content
CREATE POLICY "Anyone can view course modules"
  ON course_modules
  FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM courses 
      WHERE courses.id = course_modules.course_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view course lessons"
  ON course_lessons
  FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM course_modules 
      JOIN courses ON courses.id = course_modules.course_id
      WHERE course_modules.id = course_lessons.module_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view quiz questions"
  ON course_quiz_questions
  FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM courses 
      WHERE courses.id = course_quiz_questions.course_id 
      AND courses.status = 'published'
    )
  );

CREATE POLICY "Anyone can view quiz options"
  ON course_quiz_options
  FOR SELECT
  TO anon, authenticated
  USING (
    EXISTS (
      SELECT 1 FROM course_quiz_questions 
      JOIN courses ON courses.id = course_quiz_questions.course_id
      WHERE course_quiz_questions.id = course_quiz_options.question_id 
      AND courses.status = 'published'
    )
  );