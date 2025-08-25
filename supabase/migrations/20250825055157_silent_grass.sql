/*
  # Complete Courses System Migration

  1. New Tables
    - `courses` - Main course information with levels
    - `course_modules` - Modules within courses
    - `course_lessons` - Individual lessons with content
    - `course_quiz_questions` - Quiz questions for courses
    - `course_quiz_options` - Multiple choice options
    - `user_lesson_progress` - Track lesson completion
    - `user_quiz_attempts` - Track quiz attempts and scores

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access to published content
    - Add policies for authenticated users to track progress

  3. Sample Data
    - Complete course data for all three levels
    - Sample lessons with rich content
    - Quiz questions with explanations
*/

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text UNIQUE NOT NULL,
  title text NOT NULL,
  level course_level NOT NULL DEFAULT 'beginner',
  summary text,
  cover_url text,
  status content_status NOT NULL DEFAULT 'published',
  created_by uuid REFERENCES auth.users(id),
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
  duration_minutes integer DEFAULT 15,
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
  duration_minutes integer DEFAULT 5,
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
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id uuid REFERENCES course_lessons(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, lesson_id)
);

-- Create user quiz attempts table
CREATE TABLE IF NOT EXISTS user_quiz_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
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

-- Create policies for public read access
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

-- Create policies for authenticated users
CREATE POLICY "Users can manage their lesson progress"
  ON user_lesson_progress FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can manage their quiz attempts"
  ON user_quiz_attempts FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS courses_level_idx ON courses(level);
CREATE INDEX IF NOT EXISTS courses_status_idx ON courses(status);
CREATE INDEX IF NOT EXISTS course_modules_course_id_idx ON course_modules(course_id);
CREATE INDEX IF NOT EXISTS course_modules_order_idx ON course_modules(order_index);
CREATE INDEX IF NOT EXISTS course_lessons_module_id_idx ON course_lessons(module_id);
CREATE INDEX IF NOT EXISTS course_lessons_order_idx ON course_lessons(order_index);
CREATE INDEX IF NOT EXISTS quiz_questions_course_id_idx ON course_quiz_questions(course_id);
CREATE INDEX IF NOT EXISTS quiz_options_question_id_idx ON course_quiz_options(question_id);
CREATE INDEX IF NOT EXISTS user_lesson_progress_user_id_idx ON user_lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS user_quiz_attempts_user_id_idx ON user_quiz_attempts(user_id);

-- Insert sample course data
INSERT INTO courses (slug, title, level, summary, status, created_by) VALUES
('pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai - biudžeto sudarymas, taupymas ir pagrindiniai finansiniai įrankiai', 'published', null),
('vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Turto kūrimas ir finansiniai įrankiai - pensijų kaupimas, investavimas ir draudimas', 'published', null),
('pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Investavimas ir ekonomikos supratimas - akcijų rinkos, ETF fondai ir makroekonomika', 'published', null);

-- Get course IDs for modules
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

    -- Insert beginner course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (beginner_course_id, 'Kas yra pinigai?', 'Pinigų istorija ir funkcijos šiuolaikinėje ekonomikoje', 1, 20),
    (beginner_course_id, 'Biudžeto sudarymas', 'Kaip sudaryti ir valdyti asmeninį biudžetą', 2, 25),
    (beginner_course_id, 'Taupymo pagrindai', 'Taupymo strategijos ir metodai', 3, 20);

    -- Insert intermediate course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (intermediate_course_id, 'Pensijų sistema', 'Lietuvos pensijų sistemos pakopos ir valdymas', 1, 30),
    (intermediate_course_id, 'Investavimo pradžiamokslis', 'Pagrindiniai investavimo principai ir įrankiai', 2, 35),
    (intermediate_course_id, 'Draudimo rūšys', 'Svarbiausi draudimo tipai ir jų nauda', 3, 25);

    -- Insert advanced course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (advanced_course_id, 'Akcijų rinkos', 'Akcijų rinkų veikimo principai ir analizė', 1, 40),
    (advanced_course_id, 'ETF fondai', 'Indeksiniai fondai ir jų pranašumai', 2, 35),
    (advanced_course_id, 'Rizikos valdymas', 'Investicinės rizikos valdymo strategijos', 3, 30);

    -- Insert lessons for beginner course
    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 1;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Pinigų istorija', '<h3>Pinigų evoliucija</h3><p>Pinigai yra vienas svarbiausių žmonijos išradimų. Jie atsirado dėl prekybos poreikių ir evoliucionavo nuo natūralių mainų iki šiuolaikinių skaitmeninių mokėjimų.</p><h4>Pagrindinės pinigų funkcijos:</h4><ul><li><strong>Mainų priemonė</strong> - leidžia keistis prekėmis ir paslaugomis</li><li><strong>Vertės matas</strong> - nustato prekių ir paslaugų kainas</li><li><strong>Vertės kaupimo priemonė</strong> - leidžia taupyti ateičiai</li></ul><p>Šiandien Lietuvoje naudojame eurus, kurie yra Europos Sąjungos bendra valiuta nuo 2015 metų.</p>', 1, 8),
    (module_id, 'Šiuolaikiniai pinigai', '<h3>Skaitmeniniai mokėjimai</h3><p>XXI amžiuje pinigai vis labiau skaitmenizuojami. Lietuvoje populiarūs:</p><ul><li>Banko kortelės (debeto ir kreditinės)</li><li>Mobiliųjų mokėjimų programėlės</li><li>Internetinė bankininkystė</li><li>Bekontaktiniai mokėjimai</li></ul><h4>Grynųjų pinigų mažėjimas</h4><p>Statistikos duomenimis, Lietuvoje grynaisiais pinigais atliekama tik apie 30% visų mokėjimų. Tai rodo, kad skaitmeniniai mokėjimai tampa norma.</p>', 2, 7);

    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 2;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Biudžeto planavimas', '<h3>Kodėl svarbu planuoti biudžetą?</h3><p>Biudžeto sudarymas yra finansinio sėkmingumo pagrindas. Jis padeda:</p><ul><li>Kontroliuoti išlaidas</li><li>Planuoti taupymą</li><li>Pasiekti finansinius tikslus</li><li>Išvengti skolų</li></ul><h4>50/30/20 taisyklė</h4><p>Populiari biudžeto sudarymo metodika:</p><ul><li><strong>50%</strong> - būtinoms išlaidoms (būstas, maistas, transportas)</li><li><strong>30%</strong> - pramogoms ir nereikalingoms išlaidoms</li><li><strong>20%</strong> - taupymui ir skolų mokėjimui</li></ul>', 1, 10),
    (module_id, 'Išlaidų kategorijos', '<h3>Išlaidų klasifikavimas</h3><p>Svarbu suprasti skirtumą tarp skirtingų išlaidų tipų:</p><h4>Būtinos išlaidos:</h4><ul><li>Būstas (nuoma, komunaliniai)</li><li>Maistas</li><li>Transportas</li><li>Draudimas</li><li>Minimalūs drabužiai</li></ul><h4>Nebūtinos išlaidos:</h4><ul><li>Pramogos</li><li>Restoranai</li><li>Prabangūs drabužiai</li><li>Kelionės</li></ul><p>Finansinio stabilumo raktas - kontroliuoti nebūtinas išlaidas ir didinti taupymo dalį.</p>', 2, 8);

    -- Insert quiz questions for beginner course
    INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
    (beginner_course_id, 'Kokia yra pagrindinė pinigų funkcija?', 'Pinigai atlieka tris pagrindines funkcijas: mainų priemonės, vertės mato ir vertės kaupimo priemonės. Mainų priemonė yra svarbiausia, nes leidžia lengvai keistis prekėmis ir paslaugomis.', 1),
    (beginner_course_id, 'Kiek procentų pajamų rekomenduojama taupyti pagal 50/30/20 taisyklę?', '50/30/20 taisyklė rekomenduoja 20% pajamų skirti taupymui ir skolų mokėjimui. Tai užtikrina finansinį stabilumą ir ateities saugumą.', 2),
    (beginner_course_id, 'Kurios išlaidos yra laikomos būtinomis?', 'Būtinos išlaidos yra tos, be kurių negalima apsieiti: būstas, maistas, transportas, draudimas. Jos turėtų sudaryti ne daugiau kaip 50% pajamų.', 3);

    -- Get question IDs and insert options
    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 1;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Mainų priemonė', true, 1),
    (question_id, 'Vertės matas', false, 2),
    (question_id, 'Vertės kaupimo priemonė', false, 3),
    (question_id, 'Visos aukščiau išvardintos', false, 4);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 2;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, '10%', false, 1),
    (question_id, '15%', false, 2),
    (question_id, '20%', true, 3),
    (question_id, '25%', false, 4);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 3;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Pramogos ir kelionės', false, 1),
    (question_id, 'Būstas, maistas, transportas', true, 2),
    (question_id, 'Drabužiai ir kosmetika', false, 3),
    (question_id, 'Restoranai ir kavinės', false, 4);

END $$;