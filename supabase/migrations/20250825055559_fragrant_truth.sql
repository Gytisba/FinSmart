/*
  # Complete Courses System Setup

  1. New Tables
    - `courses` - Main course information by level
    - `course_modules` - Modules within courses  
    - `course_lessons` - Individual lessons with content
    - `course_quiz_questions` - Quiz questions for courses
    - `course_quiz_options` - Multiple choice options
    - `user_lesson_progress` - Track lesson completion
    - `user_quiz_attempts` - Track quiz attempts and scores

  2. Security
    - Enable RLS on all tables
    - Allow public read access to published course content
    - Restrict user progress to authenticated users only

  3. Sample Data
    - Complete beginner, intermediate, and advanced courses
    - Lessons with HTML content
    - Quiz questions with explanations
*/

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Anyone can view published courses" ON courses;
DROP POLICY IF EXISTS "Anyone can view course modules" ON course_modules;
DROP POLICY IF EXISTS "Anyone can view course lessons" ON course_lessons;
DROP POLICY IF EXISTS "Anyone can view quiz questions" ON course_quiz_questions;
DROP POLICY IF EXISTS "Anyone can view quiz options" ON course_quiz_options;

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  title text NOT NULL,
  level course_level NOT NULL DEFAULT 'beginner',
  summary text,
  cover_url text,
  status content_status NOT NULL DEFAULT 'published',
  created_by uuid REFERENCES users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  published_at timestamptz DEFAULT now()
);

-- Create course modules table
CREATE TABLE IF NOT EXISTS course_modules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  order_index integer NOT NULL DEFAULT 0,
  duration_minutes integer DEFAULT 30,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course lessons table
CREATE TABLE IF NOT EXISTS course_lessons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id uuid REFERENCES course_modules(id) ON DELETE CASCADE,
  title text NOT NULL,
  content text NOT NULL,
  order_index integer NOT NULL DEFAULT 0,
  duration_minutes integer DEFAULT 10,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create quiz questions table
CREATE TABLE IF NOT EXISTS course_quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  question text NOT NULL,
  explanation text,
  order_index integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create quiz options table
CREATE TABLE IF NOT EXISTS course_quiz_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid REFERENCES course_quiz_questions(id) ON DELETE CASCADE,
  option_text text NOT NULL,
  is_correct boolean DEFAULT false,
  order_index integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user lesson progress table
CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  lesson_id uuid REFERENCES course_lessons(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, lesson_id)
);

-- Create user quiz attempts table
CREATE TABLE IF NOT EXISTS user_quiz_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  score integer NOT NULL,
  total_questions integer NOT NULL,
  points_earned integer NOT NULL,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_quiz_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quiz_attempts ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for public access to published content
CREATE POLICY "Anyone can view published courses"
  ON courses FOR SELECT
  TO public
  USING (status = 'published');

CREATE POLICY "Anyone can view course modules"
  ON course_modules FOR SELECT
  TO public
  USING (EXISTS (
    SELECT 1 FROM courses 
    WHERE courses.id = course_modules.course_id 
    AND courses.status = 'published'
  ));

CREATE POLICY "Anyone can view course lessons"
  ON course_lessons FOR SELECT
  TO public
  USING (EXISTS (
    SELECT 1 FROM course_modules 
    JOIN courses ON courses.id = course_modules.course_id
    WHERE course_modules.id = course_lessons.module_id 
    AND courses.status = 'published'
  ));

CREATE POLICY "Anyone can view quiz questions"
  ON course_quiz_questions FOR SELECT
  TO public
  USING (EXISTS (
    SELECT 1 FROM courses 
    WHERE courses.id = course_quiz_questions.course_id 
    AND courses.status = 'published'
  ));

CREATE POLICY "Anyone can view quiz options"
  ON course_quiz_options FOR SELECT
  TO public
  USING (EXISTS (
    SELECT 1 FROM course_quiz_questions 
    JOIN courses ON courses.id = course_quiz_questions.course_id
    WHERE course_quiz_questions.id = course_quiz_options.question_id 
    AND courses.status = 'published'
  ));

-- User progress policies (authenticated users only)
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

-- Insert sample course data
INSERT INTO courses (slug, title, level, summary, status) VALUES
('pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published'),
('vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir pensijų kaupimas', 'published'),
('pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Akcijų rinkos ir ekonomikos principai', 'published');

-- Get course IDs for reference
DO $$
DECLARE
  beginner_course_id uuid;
  intermediate_course_id uuid;
  advanced_course_id uuid;
  module_id uuid;
  question_id uuid;
BEGIN
  -- Get course IDs
  SELECT id INTO beginner_course_id FROM courses WHERE slug = 'pradedanciuju-lygis';
  SELECT id INTO intermediate_course_id FROM courses WHERE slug = 'vidutinis-lygis';
  SELECT id INTO advanced_course_id FROM courses WHERE slug = 'pazengusiuju-lygis';

  -- Insert beginner course module
  INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes)
  VALUES (beginner_course_id, 'Finansų pagrindai', 'Išmokite pagrindinius finansų valdymo principus', 1, 45)
  RETURNING id INTO module_id;

  -- Insert beginner lessons
  INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
  (module_id, 'Kas yra pinigai?', '<h3>Pinigų esmė</h3><p>Pinigai yra mainų priemonė, kuri leidžia mums įsigyti prekes ir paslaugas. Lietuvoje naudojame eurus (€) nuo 2015 metų.</p><h4>Pinigų funkcijos:</h4><ul><li>Mainų priemonė</li><li>Vertės matas</li><li>Vertės kaupimo priemonė</li></ul><p>Svarbu suprasti, kad pinigai patys savaime neturi vertės - jų vertė priklauso nuo to, ką už juos galime nusipirkti.</p>', 1, 15),
  (module_id, 'Biudžeto sudarymas', '<h3>Kodėl svarbu turėti biudžetą?</h3><p>Biudžetas - tai jūsų finansinis planas, kuris padeda kontroliuoti pajamas ir išlaidas.</p><h4>Biudžeto sudarymo žingsniai:</h4><ol><li>Suskaičiuokite visas pajamas</li><li>Išvardykite visas išlaidas</li><li>Suskirstykite išlaidas į kategorijas</li><li>Palyginkite pajamas su išlaidomis</li><li>Koreguokite pagal poreikius</li></ol><p><strong>50/30/20 taisyklė:</strong></p><ul><li>50% - būtinos išlaidos (nuoma, maistas)</li><li>30% - pramogos ir norai</li><li>20% - taupymas ir investicijos</li></ul>', 2, 20),
  (module_id, 'Taupymo pradmenys', '<h3>Kodėl taupyti?</h3><p>Taupymas - tai pinigų atidėjimas ateities poreikiams. Tai finansinio saugumo pagrindas.</p><h4>Taupymo tikslai:</h4><ul><li>Nepamirštamasis fondas (3-6 mėnesių išlaidos)</li><li>Trumpalaikiai tikslai (atostogos, technika)</li><li>Ilgalaikiai tikslai (būsto įmoka, pensija)</li></ul><h5>Taupymo strategijos:</h5><p>Pradėkite nuo mažo - net 10€ per mėnesį yra geras pradžia. Automatizuokite taupymą - nustatykite automatinį pervedimą į taupymo sąskaitą.</p>', 3, 10);

  -- Insert intermediate course module
  INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes)
  VALUES (intermediate_course_id, 'Investavimo pagrindai', 'Sužinokite apie investavimo galimybes Lietuvoje', 1, 60)
  RETURNING id INTO module_id;

  -- Insert intermediate lessons
  INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
  (module_id, 'Pensijų sistema Lietuvoje', '<h3>Lietuvos pensijų sistemos pakopos</h3><p>Lietuvoje veikia 3 pakopų pensijų sistema:</p><h4>I pakopa - Valstybinio socialinio draudimo pensija</h4><p>Privaloma visiem dirbantiems. Pensijos dydis priklauso nuo stažo ir įmokų dydžio.</p><h4>II pakopa - Pensijų kaupimas</h4><p>Savanoriškas dalyvavimas. Dalis SODRA įmokų nukreipiama į pasirinktą pensijų fondą.</p><h4>III pakopa - Papildomas pensijų kaupimas</h4><p>Savanoriškas papildomas taupymas pensijai per draudimo bendroves ar banko produktus.</p><p><strong>Patarimas:</strong> Kuo anksčiau pradėsite kaupti pensijai, tuo daugiau pinigų turėsite senatvėje dėl sudėtinių palūkanų poveikio.</p>', 1, 20),
  (module_id, 'Sudėtinės palūkanos', '<h3>Sudėtinių palūkanų stebuklas</h3><p>Sudėtinės palūkanos - tai palūkanos, skaičiuojamos ne tik nuo pradinės sumos, bet ir nuo anksčiau sukauptų palūkanų.</p><h4>Pavyzdys:</h4><p>Investavote 1000€ su 7% metinėmis palūkanomis:</p><ul><li>Po 1 metų: 1070€</li><li>Po 10 metų: 1967€</li><li>Po 20 metų: 3870€</li><li>Po 30 metų: 7612€</li></ul><p>Matote, kaip laikas padaugina jūsų pinigus! Kuo anksčiau pradėsite investuoti, tuo daugiau laiko turės jūsų pinigai augti.</p><h5>Praktinis patarimas:</h5><p>Net mažos sumos, reguliariai investuojamos, gali virsti dideliais kapitalais. 100€ per mėnesį 30 metų su 7% palūkanomis taps 122,000€!</p>', 2, 15),
  (module_id, 'Investavimo pradžia', '<h3>Pirmieji žingsniai investuojant</h3><p>Investavimas - tai pinigų paskirstymas tarp įvairių finansinių instrumentų siekiant gauti pelno.</p><h4>Pagrindiniai investavimo principai:</h4><ol><li><strong>Diversifikacija</strong> - nepaskirstykite visų kiaušinių į vieną krepšelį</li><li><strong>Laiko horizontas</strong> - ilgalaikis investavimas paprastai saugesnis</li><li><strong>Rizikos valdymas</strong> - investuokite tik tai, ką galite prarasti</li></ol><h5>Investavimo galimybės Lietuvoje:</h5><ul><li>Banko indėliai (mažiausia rizika, mažiausias pelnas)</li><li>Valstybės obligacijos</li><li>Investiciniai fondai</li><li>ETF fondai</li><li>Akcijos</li></ul><p>Pradedantiesiems rekomenduojami diversifikuoti fondai arba ETF.</p>', 3, 25);

  -- Insert advanced course module
  INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes)
  VALUES (advanced_course_id, 'Akcijų rinkos', 'Gilintis į akcijų prekybą ir analizę', 1, 90)
  RETURNING id INTO module_id;

  -- Insert advanced lessons
  INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
  (module_id, 'Akcijų rinkos pagrindai', '<h3>Kas yra akcijos?</h3><p>Akcija - tai bendrovės nuosavybės dalis. Pirkdami akciją, tampate bendrovės dalininku.</p><h4>Akcijų tipai:</h4><ul><li><strong>Paprastosios akcijos</strong> - suteikia balsavimo teises ir dividendų gavimo galimybę</li><li><strong>Privilegijuotosios akcijos</strong> - pirmenybė gaunant dividendus, bet paprastai be balsavimo teisių</li></ul><h4>Kaip uždirbti iš akcijų:</h4><ol><li><strong>Dividendai</strong> - bendrovės pelnų dalis, mokama akcininkams</li><li><strong>Kapitalo prieaugis</strong> - akcijos kainos augimas</li></ol><h5>Akcijų biržos:</h5><p>Lietuvoje veikia NASDAQ Vilnius birža. Didžiausios pasaulio biržos: NYSE, NASDAQ, LSE.</p><p><strong>Svarbu:</strong> Akcijų kainos svyruoja, todėl galite prarasti dalį ar visus investuotus pinigus.</p>', 1, 30),
  (module_id, 'ETF fondai', '<h3>Kas yra ETF?</h3><p>ETF (Exchange-Traded Fund) - tai investicinis fondas, prekiaujamas biržoje kaip paprastos akcijos.</p><h4>ETF privalumai:</h4><ul><li>Diversifikacija - vienas ETF gali turėti šimtus akcijų</li><li>Maži mokesčiai - paprastai 0,1-0,5% per metus</li><li>Likvidumas - galima pirkti/parduoti bet kada</li><li>Skaidrumas - žinote, į ką investuojate</li></ul><h4>Populiarūs ETF tipai:</h4><ul><li><strong>Indekso ETF</strong> - seka konkretų indeksą (pvz., S&P 500)</li><li><strong>Sektorių ETF</strong> - investuoja į konkretų sektorių</li><li><strong>Geografiniai ETF</strong> - investuoja į konkretų regioną</li><li><strong>Obligacijų ETF</strong> - investuoja į obligacijas</li></ul><p>ETF yra puikus būdas pradedantiesiems diversifikuoti savo portfelį su mažomis sumomis.</p>', 2, 25),
  (module_id, 'Rizikos valdymas', '<h3>Investavimo rizikos</h3><p>Kiekvienas investavimas turi riziką. Svarbu ją suprasti ir valdyti.</p><h4>Rizikos tipai:</h4><ul><li><strong>Rinkos rizika</strong> - bendras rinkos kritimas</li><li><strong>Bendrovės rizika</strong> - konkrečios bendrovės problemos</li><li><strong>Likvidumo rizika</strong> - sunkumai parduodant investiciją</li><li><strong>Valiutos rizika</strong> - valiutos kurso svyravimai</li><li><strong>Infliacijos rizika</strong> - perkamosios galios mažėjimas</li></ul><h4>Rizikos valdymo strategijos:</h4><ol><li><strong>Diversifikacija</strong> - investavimas į skirtingus aktyvus</li><li><strong>Laiko diversifikacija</strong> - reguliarus investavimas (DCA)</li><li><strong>Pozicijos dydžio valdymas</strong> - neinvestuoti per daug į vieną aktyvą</li><li><strong>Stop-loss orderiai</strong> - automatinis pardavimas esant nuostoliams</li></ol><p><strong>Auksinė taisyklė:</strong> Niekada neinvestuokite pinigų, kurių negalite prarasti!</p>', 3, 35);

  -- Insert quiz questions for beginner course
  INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
  (beginner_course_id, 'Kuri iš šių yra pagrindinė pinigų funkcija?', 'Pinigai pirmiausia yra mainų priemonė, leidžianti keisti prekes ir paslaugas.', 1)
  RETURNING id INTO question_id;

  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
  (question_id, 'Mainų priemonė', true, 1),
  (question_id, 'Dekoracijos', false, 2),
  (question_id, 'Kolekcionavimo objektas', false, 3),
  (question_id, 'Žaidimo priemonė', false, 4);

  INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
  (beginner_course_id, 'Pagal 50/30/20 taisyklę, kiek procentų pajamų turėtų būti skiriama taupymui?', '20% pajamų turėtų būti skiriama taupymui ir investicijoms pagal šią populiarią biudžeto taisyklę.', 2)
  RETURNING id INTO question_id;

  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
  (question_id, '10%', false, 1),
  (question_id, '20%', true, 2),
  (question_id, '30%', false, 3),
  (question_id, '50%', false, 4);

  -- Insert quiz questions for intermediate course
  INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
  (intermediate_course_id, 'Kiek pakopų turi Lietuvos pensijų sistema?', 'Lietuvos pensijų sistema turi 3 pakopas: I - privalomoji, II - savanoriška, III - papildoma.', 1)
  RETURNING id INTO question_id;

  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
  (question_id, '2 pakopas', false, 1),
  (question_id, '3 pakopas', true, 2),
  (question_id, '4 pakopas', false, 3),
  (question_id, '5 pakopas', false, 4);

  -- Insert quiz questions for advanced course
  INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
  (advanced_course_id, 'Kas yra ETF?', 'ETF (Exchange-Traded Fund) yra investicinis fondas, prekiaujamas biržoje kaip akcijos.', 1)
  RETURNING id INTO question_id;

  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
  (question_id, 'European Trading Fund', false, 1),
  (question_id, 'Exchange-Traded Fund', true, 2),
  (question_id, 'Electronic Transfer Fund', false, 3),
  (question_id, 'Emergency Trading Fund', false, 4);

END $$;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_courses_level ON courses(level);
CREATE INDEX IF NOT EXISTS idx_courses_status ON courses(status);
CREATE INDEX IF NOT EXISTS idx_course_modules_course_id ON course_modules(course_id);
CREATE INDEX IF NOT EXISTS idx_course_lessons_module_id ON course_lessons(module_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_course_id ON course_quiz_questions(course_id);
CREATE INDEX IF NOT EXISTS idx_quiz_options_question_id ON course_quiz_options(question_id);
CREATE INDEX IF NOT EXISTS idx_user_lesson_progress_user_id ON user_lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_quiz_attempts_user_id ON user_quiz_attempts(user_id);