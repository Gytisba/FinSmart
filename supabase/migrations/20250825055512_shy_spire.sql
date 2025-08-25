@@ .. @@
 ALTER TABLE user_quiz_attempts ENABLE ROW LEVEL SECURITY;
 
 -- Create RLS policies
-CREATE POLICY "Anyone can view published courses"
+DROP POLICY IF EXISTS "Anyone can view published courses" ON courses;
+CREATE POLICY "Anyone can view published courses"
   ON courses
   FOR SELECT
   TO public
   USING (status = 'published');
 
-CREATE POLICY "Anyone can view course modules"
+DROP POLICY IF EXISTS "Anyone can view course modules" ON course_modules;
+CREATE POLICY "Anyone can view course modules"
   ON course_modules
   FOR SELECT
   TO public
   USING (EXISTS (
@@ .. @@
     WHERE courses.id = course_modules.course_id AND courses.status = 'published'
   ));
 
-CREATE POLICY "Anyone can view course lessons"
+DROP POLICY IF EXISTS "Anyone can view course lessons" ON course_lessons;
+CREATE POLICY "Anyone can view course lessons"
   ON course_lessons
   FOR SELECT
   TO public
@@ .. @@
     WHERE courses.id = course_modules.course_id AND courses.status = 'published'
   ));
 
-CREATE POLICY "Anyone can view quiz questions"
+DROP POLICY IF EXISTS "Anyone can view quiz questions" ON course_quiz_questions;
+CREATE POLICY "Anyone can view quiz questions"
   ON course_quiz_questions
   FOR SELECT
   TO public
@@ .. @@
     WHERE courses.id = course_quiz_questions.course_id AND courses.status = 'published'
   ));
 
-CREATE POLICY "Anyone can view quiz options"
+DROP POLICY IF EXISTS "Anyone can view quiz options" ON course_quiz_options;
+CREATE POLICY "Anyone can view quiz options"
   ON course_quiz_options
   FOR SELECT
   TO public
@@ .. @@
     WHERE courses.id = course_quiz_questions.course_id AND courses.status = 'published'
   ));
 
-CREATE POLICY "Users can view own lesson progress"
+DROP POLICY IF EXISTS "Users can view own lesson progress" ON user_lesson_progress;
+CREATE POLICY "Users can view own lesson progress"
   ON user_lesson_progress
   FOR ALL
   TO authenticated
   USING (auth.uid() = user_id);
 
-CREATE POLICY "Users can view own quiz attempts"
+DROP POLICY IF EXISTS "Users can view own quiz attempts" ON user_quiz_attempts;
+CREATE POLICY "Users can view own quiz attempts"
   ON user_quiz_attempts
   FOR ALL
   TO authenticated