/*
  # Insert sample course data

  This migration adds sample courses, modules, lessons, and quiz questions
  to demonstrate the platform functionality.
*/

-- Insert sample courses
DO $$
DECLARE
  beginner_course_id uuid;
  intermediate_course_id uuid;
  advanced_course_id uuid;
  module1_id uuid;
  module2_id uuid;
  module3_id uuid;
  question1_id uuid;
  question2_id uuid;
  question3_id uuid;
BEGIN
  -- Get a user ID for created_by (use the first user or create a system user)
  INSERT INTO courses (id, slug, title, level, summary, status, created_by, published_at)
  VALUES 
    (gen_random_uuid(), 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published', (SELECT id FROM users LIMIT 1), now()),
    (gen_random_uuid(), 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'published', (SELECT id FROM users LIMIT 1), now()),
    (gen_random_uuid(), 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'published', (SELECT id FROM users LIMIT 1), now())
  ON CONFLICT (slug) DO NOTHING;

  -- Get course IDs
  SELECT id INTO beginner_course_id FROM courses WHERE slug = 'pradedanciuju-lygis';
  SELECT id INTO intermediate_course_id FROM courses WHERE slug = 'vidutinis-lygis';
  SELECT id INTO advanced_course_id FROM courses WHERE slug = 'pazengusiuju-lygis';

  -- Insert modules for beginner course
  INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes)
  VALUES 
    (gen_random_uuid(), beginner_course_id, 'Finansų pagrindai', 'Sužinokite, kas yra pinigai ir kaip jie veikia', 1, 45),
    (gen_random_uuid(), beginner_course_id, 'Biudžeto sudarymas', 'Išmokite sudaryti ir valdyti asmeninį biudžetą', 2, 60),
    (gen_random_uuid(), beginner_course_id, 'Taupymas ir investavimas', 'Pradėkite taupyti ir investuoti protingai', 3, 50)
  ON CONFLICT DO NOTHING;

  -- Get module IDs
  SELECT id INTO module1_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 1;
  SELECT id INTO module2_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 2;
  SELECT id INTO module3_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 3;

  -- Insert lessons
  INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes)
  VALUES 
    (module1_id, 'Kas yra pinigai?', '<h3>Pinigų istorija</h3><p>Pinigai yra mainų priemonė, kuri palengvina prekybą ir paslaugų teikimą. Lietuvoje naudojame eurus nuo 2015 metų.</p><h4>Pinigų funkcijos:</h4><ul><li>Mainų priemonė</li><li>Vertės matas</li><li>Vertės kaupimo priemonė</li></ul>', 1, 15),
    (module1_id, 'Infliacija ir perkamoji galia', '<h3>Kas yra infliacija?</h3><p>Infliacija - tai kainų lygio augimas ekonomikoje. Lietuvoje vidutinė infliacija per metus yra apie 2-3%.</p><h4>Kaip infliacija paveiks jus:</h4><ul><li>Sumažės pinigų perkamoji galia</li><li>Padidės prekių kainos</li><li>Svarbu investuoti, kad išsaugotumėte vertę</li></ul>', 2, 20),
    (module2_id, 'Pajamų ir išlaidų apskaita', '<h3>Biudžeto sudarymas</h3><p>Biudžetas - tai jūsų finansinis planas, kuris padeda valdyti pinigus.</p><h4>Biudžeto sudarymo žingsniai:</h4><ol><li>Suskaičiuokite visas pajamas</li><li>Išvardykite visas išlaidas</li><li>Palyginkite pajamas su išlaidomis</li><li>Planuokite taupymą</li></ol>', 1, 25),
    (module2_id, '50/30/20 taisyklė', '<h3>Populiari biudžeto taisyklė</h3><p>50/30/20 taisyklė padeda paskirstyti pajamas:</p><ul><li><strong>50%</strong> - būtinoms išlaidoms (nuoma, maistas)</li><li><strong>30%</strong> - pramogoms ir norimiems dalykams</li><li><strong>20%</strong> - taupymui ir investicijoms</li></ul>', 2, 20),
    (module3_id, 'Taupymo strategijos', '<h3>Kaip pradėti taupyti</h3><p>Taupymas - tai pinigų atidėjimas ateities poreikiams.</p><h4>Taupymo patarimai:</h4><ul><li>Automatizuokite taupymą</li><li>Pradėkite nuo mažų sumų</li><li>Turėkite avarinį fondą</li><li>Nustatykite tikslus</li></ul>', 1, 30)
  ON CONFLICT DO NOTHING;

  -- Insert quiz questions for beginner course
  INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index)
  VALUES 
    (gen_random_uuid(), beginner_course_id, 'Kas yra infliacija?', 'Infliacija yra kainų lygio augimas ekonomikoje per tam tikrą laikotarpį.', 1),
    (gen_random_uuid(), beginner_course_id, 'Kiek procentų pajamų rekomenduojama taupyti pagal 50/30/20 taisyklę?', '20% pajamų turėtų būti skiriama taupymui ir investicijoms.', 2),
    (gen_random_uuid(), beginner_course_id, 'Koks yra pagrindinis biudžeto tikslas?', 'Biudžetas padeda valdyti pinigus ir planuoti finansus.', 3)
  ON CONFLICT DO NOTHING;

  -- Get question IDs
  SELECT id INTO question1_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 1;
  SELECT id INTO question2_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 2;
  SELECT id INTO question3_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 3;

  -- Insert quiz options
  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index)
  VALUES 
    -- Question 1 options
    (question1_id, 'Kainų lygio augimas ekonomikoje', true, 1),
    (question1_id, 'Pinigų kiekio mažėjimas', false, 2),
    (question1_id, 'Palūkanų normų kilimas', false, 3),
    (question1_id, 'Valiutos stiprėjimas', false, 4),
    
    -- Question 2 options
    (question2_id, '10%', false, 1),
    (question2_id, '15%', false, 2),
    (question2_id, '20%', true, 3),
    (question2_id, '25%', false, 4),
    
    -- Question 3 options
    (question3_id, 'Padidinti pajamas', false, 1),
    (question3_id, 'Valdyti pinigus ir planuoti finansus', true, 2),
    (question3_id, 'Sumažinti mokesčius', false, 3),
    (question3_id, 'Pirkti daugiau prekių', false, 4)
  ON CONFLICT DO NOTHING;

END $$;