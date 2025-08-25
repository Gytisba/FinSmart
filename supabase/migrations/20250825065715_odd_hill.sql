/*
  # Simplify Courses RLS Policy

  1. Security Changes
    - Remove complex policy that accesses users table
    - Create simple policies for public access to published courses
    - Allow authenticated users to manage their own courses

  This removes the need to access the users table entirely.
*/

-- Drop the existing problematic policy
DROP POLICY IF EXISTS "Authors can manage their courses" ON courses;

-- Create simple policies that don't access users table
CREATE POLICY "Anyone can view published courses"
  ON courses
  FOR SELECT
  TO public
  USING (status = 'published');

CREATE POLICY "Authenticated users can manage their own courses"
  ON courses
  FOR ALL
  TO authenticated
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);