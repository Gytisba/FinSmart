@@ .. @@
 DO $$
 DECLARE
   course_beginner_id uuid;
   course_intermediate_id uuid;
   course_advanced_id uuid;
   module_id uuid;
   lesson_id uuid;
   question_id uuid;
+  dummy_user_id uuid := '00000000-0000-0000-0000-000000000000';
 BEGIN
   -- Insert courses
-  INSERT INTO courses (id, slug, title, level, summary, status, created_by, published_at)
+  INSERT INTO courses (id, slug, title, level, summary, status, created_by, published_at)
   VALUES 
-    (gen_random_uuid(), 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published', (SELECT id FROM users LIMIT 1), now()),
-    (gen_random_uuid(), 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'published', (SELECT id FROM users LIMIT 1), now()),
-    (gen_random_uuid(), 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'published', (SELECT id FROM users LIMIT 1), now())
+    (gen_random_uuid(), 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published', dummy_user_id, now()),
+    (gen_random_uuid(), 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'published', dummy_user_id, now()),
+    (gen_random_uuid(), 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'published', dummy_user_id, now())
   ON CONFLICT (slug) DO NOTHING;