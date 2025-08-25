/*
  # Remove all courses policies and create simple ones

  1. Security Changes
    - Drop all existing RLS policies on courses table
    - Create simple policies that don't reference users table
    - Allow public read access to published courses
    - Allow authenticated users to manage their own courses

  This completely eliminates any reference to the users table.
*/

-- Drop all existing policies on courses table
DROP POLICY IF EXISTS "Anyone can view published courses" ON courses;
DROP POLICY IF EXISTS "Authors can manage their courses" ON courses;
DROP POLICY IF EXISTS "Public can view published courses" ON courses;
DROP POLICY IF EXISTS "Authenticated users can manage own courses" ON courses;
DROP POLICY IF EXISTS "Admins can manage all courses" ON courses;

-- Create simple policies that don't reference users table
CREATE POLICY "Public read published courses"
  ON courses
  FOR SELECT
  TO public
  USING (status = 'published');

CREATE POLICY "Authenticated manage own courses"
  ON courses
  FOR ALL
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);