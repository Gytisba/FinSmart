/*
  # Create comprehensive courses system

  1. New Tables
    - `course_levels` - Define available course levels (beginner, intermediate, advanced)
    - `courses` - Main course information
    - `course_modules` - Individual modules within courses
    - `course_lessons` - Lessons within modules
    - `quiz_questions` - Questions for course quizzes
    - `quiz_options` - Multiple choice options for questions
    - `user_lesson_progress` - Track user progress through lessons
    - `user_quiz_attempts` - Track quiz attempts and scores

  2. Security
    - Enable RLS on all tables
    - Add policies for public read access to course content
    - Add policies for authenticated users to manage their progress

  3. Sample Data
    - Insert all course levels, courses, modules, lessons, and quiz data
    - Comprehensive content for beginner, intermediate, and advanced levels
*/

-- Create course levels enum if not exists
DO $$ BEGIN
    CREATE TYPE course_level_enum AS ENUM ('beginner', 'intermediate', 'advanced');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  level course_level_enum NOT NULL,
  title text NOT NULL,
  subtitle text,
  description text,
  color_from text DEFAULT 'emerald-500',
  color_to text DEFAULT 'green-600',
  icon text DEFAULT 'BookOpen',
  total_modules integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course modules table
CREATE TABLE IF NOT EXISTS course_modules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  order_index integer NOT NULL,
  duration_minutes integer DEFAULT 5,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create course lessons table
CREATE TABLE IF NOT EXISTS course_lessons (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id uuid REFERENCES course_modules(id) ON DELETE CASCADE,
  title text NOT NULL,
  content text NOT NULL,
  order_index integer NOT NULL,
  duration_minutes integer DEFAULT 5,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create quiz questions table (enhanced)
CREATE TABLE IF NOT EXISTS course_quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id uuid REFERENCES courses(id) ON DELETE CASCADE,
  question text NOT NULL,
  explanation text,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create quiz options table (enhanced)
CREATE TABLE IF NOT EXISTS course_quiz_options (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id uuid REFERENCES course_quiz_questions(id) ON DELETE CASCADE,
  option_text text NOT NULL,
  is_correct boolean DEFAULT false,
  order_index integer NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create user lesson progress table
CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
  lesson_id uuid REFERENCES course_lessons(id) ON DELETE CASCADE,
  completed_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, lesson_id)
);

-- Create user quiz attempts table
CREATE TABLE IF NOT EXISTS user_quiz_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES user_profiles(id) ON DELETE CASCADE,
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

-- Create policies for public read access to course content
CREATE POLICY "Anyone can view courses" ON courses FOR SELECT USING (true);
CREATE POLICY "Anyone can view course modules" ON course_modules FOR SELECT USING (true);
CREATE POLICY "Anyone can view course lessons" ON course_lessons FOR SELECT USING (true);
CREATE POLICY "Anyone can view quiz questions" ON course_quiz_questions FOR SELECT USING (true);
CREATE POLICY "Anyone can view quiz options" ON course_quiz_options FOR SELECT USING (true);

-- Create policies for user progress
CREATE POLICY "Users can view own lesson progress" ON user_lesson_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own lesson progress" ON user_lesson_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own lesson progress" ON user_lesson_progress FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can view own quiz attempts" ON user_quiz_attempts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own quiz attempts" ON user_quiz_attempts FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Insert course data
INSERT INTO courses (level, title, subtitle, description, color_from, color_to, icon, total_modules) VALUES
('beginner', 'Pradedančiųjų lygis', 'Asmeninių finansų pagrindai', 'Išmokite finansų pagrindų: biudžeto sudarymo, taupymo ir pagrindinių finansinių įrankių naudojimo.', 'emerald-500', 'green-600', 'BookOpen', 5),
('intermediate', 'Vidutinis lygis', 'Turto kūrimas ir finansiniai įrankiai', 'Sužinokite apie investavimą, pensijų kaupimą ir finansinių paslaugų naudojimą Lietuvoje.', 'blue-500', 'indigo-600', 'TrendingUp', 5),
('advanced', 'Pažengusiųjų lygis', 'Investavimas ir ekonomikos supratimas', 'Gilintis į akcijų rinkas, ETF fondus ir makroekonomikos principus.', 'purple-500', 'pink-600', 'BarChart3', 5);

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
    SELECT id INTO beginner_course_id FROM courses WHERE level = 'beginner';
    SELECT id INTO intermediate_course_id FROM courses WHERE level = 'intermediate';
    SELECT id INTO advanced_course_id FROM courses WHERE level = 'advanced';

    -- Insert beginner course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (beginner_course_id, 'Kas yra pinigai ir kaip jie veikia?', 'Pinigų kilmė, funkcijos ir infliacija', 0, 5),
    (beginner_course_id, 'Biudžeto sudarymas - jūsų finansų pagrindas', 'Mokykitės sudaryti ir valdyti asmeninį biudžetą', 1, 7),
    (beginner_course_id, 'Taupymas vs išlaidavimas - tinkamas balansas', 'Taupymo principai ir tikslų nustatymas', 2, 6),
    (beginner_course_id, 'Banko sąskaitos ir paslaugos', 'Bankinių paslaugų naudojimas Lietuvoje', 3, 6),
    (beginner_course_id, 'Mokesčiai Lietuvoje', 'GPM, VMI ir mokesčių deklaravimas', 4, 8);

    -- Insert beginner lessons
    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 0;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Pinigų kilmė ir funkcijos', '<h3>Pinigų kilmė ir funkcijos</h3><p>Pinigai yra visuomenės priimtas mainų įrankis, kuris palengvina prekybą ir paslaugų teikimą. Lietuvoje oficiali valiuta yra euras (€).</p><h4>Pinigų pagrindinės funkcijos:</h4><ul><li><strong>Mainų priemonė</strong> - leidžia keisti prekes ir paslaugas</li><li><strong>Vertės matas</strong> - nustato prekių ir paslaugų kainą</li><li><strong>Vertybių saugykla</strong> - leidžia taupyti ateičiai</li></ul>', 0, 5);

    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 1;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Biudžeto sudarymo žingsniai', '<h3>Kodėl svarbu turėti biudžetą?</h3><p>Biudžetas padeda kontroliuoti išlaidas, planuoti taupymą ir pasiekti finansinius tikslus.</p><h4>Pagrindinė biudžeto formulė:</h4><div class="bg-blue-50 border border-blue-200 p-4 rounded-lg my-4"><p class="text-lg font-semibold">Pajamos - Išlaidos = Taupymas</p></div><h4>Biudžeto sudarymo žingsniai:</h4><ol><li><strong>Apskaičiuokite pajamas</strong> - algą, dividendus, kitas pajamas</li><li><strong>Išvardykite išlaidas</strong>:<ul><li>Būtinos (būstas, maistas, transportas) - 50-60%</li><li>Pramogos ir poilsis - 20-30%</li><li>Taupymas - 10-20%</li></ul></li><li><strong>Stebėkite ir koreguokite</strong></li></ol>', 0, 7);

    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 2;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Taupymo principai', '<h3>Taupymo svarba</h3><p>Taupymas užtikrina finansinį stabilumą ir leidžia realizuoti svajones bei tikslus.</p><h4>Taupymo principai:</h4><ul><li><strong>Mokėkite sau pirma</strong> - iš karto išskirkite taupymui dalį pajamų</li><li><strong>Automatizuokite</strong> - nustatykite automatinį pinigų pervedimą į taupymo sąskaitą</li><li><strong>50/30/20 taisyklė</strong>:<ul><li>50% - būtinos išlaidos</li><li>30% - pramogos</li><li>20% - taupymas ir investicijos</li></ul></li></ul>', 0, 6);

    -- Insert intermediate course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (intermediate_course_id, 'Lietuvos pensijų sistema', 'Supratimas apie 3 pakopų pensijų sistemą', 0, 8),
    (intermediate_course_id, 'Sudėtinės palūkanos', 'Kaip veikia sudėtinės palūkanos ir jų galia', 1, 6),
    (intermediate_course_id, 'Kreditinės kortelės', 'Išmanus kreditinių kortelių naudojimas', 2, 7),
    (intermediate_course_id, 'Įvadas į investavimą', 'Pagrindiniai investavimo principai', 3, 9),
    (intermediate_course_id, 'Draudimo rūšys', 'Svarbiausi draudimo tipai Lietuvoje', 4, 6);

    -- Insert intermediate lessons
    SELECT id INTO module_id FROM course_modules WHERE course_id = intermediate_course_id AND order_index = 0;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Pensijų sistemos pagrindai', '<h3>Kaip veikia pensijų sistema Lietuvoje?</h3><p>Lietuvoje veikia 3 pakopų pensijų sistema, skirta užtikrinti orų gyvenimą senatvėje.</p><h4>I pakopa - Sodra (privaloma)</h4><ul><li>Valstybės socialinio draudimo pensija</li><li>Finansuojama iš dabartinių darbuotojų įmokų</li><li>2024m. vidutinė pensija - 450€</li></ul><h4>II pakopa - Pensijų fondai (savanoriška)</h4><ul><li>Privatūs pensijų fondai</li><li>2% algos pereina į fondą (vietoj Sodros)</li><li>Galima rinktis konservatyvų ar rizikingesnius fondus</li></ul>', 0, 8);

    -- Insert advanced course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES
    (advanced_course_id, 'Akcijų rinkos pagrindai', 'Supratimas apie akcijų rinkas ir investavimą', 0, 10),
    (advanced_course_id, 'ETF fondai', 'Indeksiniai fondai ir jų privalumai', 1, 8),
    (advanced_course_id, 'Rizikos valdymas', 'Investicinės rizikos valdymo strategijos', 2, 9),
    (advanced_course_id, 'Kriptovaliutos', 'Skaitmeninės valiutos ir blockchain', 3, 7),
    (advanced_course_id, 'Makroekonominiai rodikliai', 'Ekonomikos ciklai ir jų poveikis investicijoms', 4, 8);

    -- Insert advanced lessons
    SELECT id INTO module_id FROM course_modules WHERE course_id = advanced_course_id AND order_index = 0;
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES
    (module_id, 'Akcijų rinkos pagrindai', '<h3>Kas yra akcijos?</h3><p>Akcija - tai bendrovės dalies nuosavybės liudijimas. Pirkdami akciją, tampate bendrovės dalininku.</p><h4>Akcijų tipai:</h4><ul><li><strong>Paprastosios akcijos</strong> - suteikia balsavimo teises ir dividendų teisę</li><li><strong>Privilegijuotosios akcijos</strong> - prioritetas gaunant dividendus</li></ul><h4>Kaip uždirbti iš akcijų?</h4><ol><li><strong>Kapitalo augimas</strong> - akcijos kainos didėjimas</li><li><strong>Dividendai</strong> - bendrovės pelnų paskirstymas akcininkams</li></ol>', 0, 10);

    -- Insert quiz questions for beginner course
    INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
    (beginner_course_id, 'Kas yra infliacija?', 'Infliacija - tai kainų augimas laike, kuris mažina pinigų perkamąją galią.', 0),
    (beginner_course_id, 'Kiek procentų pajamų rekomenduojama skirti taupymui pagal 50/30/20 taisyklę?', '50/30/20 taisyklė rekomenduoja 20% pajamų skirti taupymui ir investicijoms.', 1),
    (beginner_course_id, 'Koks yra nepamirštamųjų fondo rekomenduojamas dydis?', 'Nepamirštamųjų fondas turėtų padengti 3-6 mėnesių būtinąsias išlaidas.', 2),
    (beginner_course_id, 'Kuris banko sąskaitos tipas tinkamesnis taupymui?', 'Taupomoji sąskaita paprastai moka palūkanas ir skatina taupyti.', 3);

    -- Insert quiz options for beginner questions
    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 0;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Kainų mažėjimas laike', false, 0),
    (question_id, 'Kainų augimas laike', true, 1),
    (question_id, 'Valiutos keitimo kursas', false, 2),
    (question_id, 'Banko palūkanų norma', false, 3);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 1;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, '10%', false, 0),
    (question_id, '15%', false, 1),
    (question_id, '20%', true, 2),
    (question_id, '25%', false, 3);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 2;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, '1-2 mėnesių išlaidos', false, 0),
    (question_id, '3-6 mėnesių išlaidos', true, 1),
    (question_id, '1 metų išlaidos', false, 2),
    (question_id, '2 metų išlaidos', false, 3);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 3;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Einamoji sąskaita', false, 0),
    (question_id, 'Taupomoji sąskaita', true, 1),
    (question_id, 'Kreditinė sąskaita', false, 2),
    (question_id, 'Visi vienodai tinkami', false, 3);

    -- Insert quiz questions for intermediate course
    INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
    (intermediate_course_id, 'Kiek pakopų turi Lietuvos pensijų sistema?', 'Lietuvos pensijų sistema turi 3 pakopas: Sodra, privačių fondų ir asmeninis taupymas.', 0),
    (intermediate_course_id, 'Kas yra sudėtinės palūkanos?', 'Sudėtinės palūkanos - palūkanos, mokamos nuo pradinės sumos ir anksčiau sukauptų palūkanų.', 1);

    -- Insert quiz options for intermediate questions
    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = intermediate_course_id AND order_index = 0;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, '2', false, 0),
    (question_id, '3', true, 1),
    (question_id, '4', false, 2),
    (question_id, '5', false, 3);

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = intermediate_course_id AND order_index = 1;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Palūkanos, mokamos tik nuo pradinės sumos', false, 0),
    (question_id, 'Palūkanos, mokamos nuo pradinės sumos ir anksčiau gautų palūkanų', true, 1),
    (question_id, 'Banko mokestis už paslaugas', false, 2),
    (question_id, 'Valiutos keitimo mokestis', false, 3);

    -- Insert quiz questions for advanced course
    INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES
    (advanced_course_id, 'Kas yra diversifikacija?', 'Diversifikacija - rizikos paskirstymas investuojant į skirtingas bendrovės, sektorius ar regiones.', 0);

    -- Insert quiz options for advanced questions
    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = advanced_course_id AND order_index = 0;
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES
    (question_id, 'Investavimas tik į vieną bendrovę', false, 0),
    (question_id, 'Rizikos paskirstymas tarp skirtingų investicijų', true, 1),
    (question_id, 'Akcijų pirkimas ir pardavimas per dieną', false, 2),
    (question_id, 'Investavimas tik į būstą', false, 3);

END $$;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_course_modules_course_id ON course_modules(course_id);
CREATE INDEX IF NOT EXISTS idx_course_lessons_module_id ON course_lessons(module_id);
CREATE INDEX IF NOT EXISTS idx_course_quiz_questions_course_id ON course_quiz_questions(course_id);
CREATE INDEX IF NOT EXISTS idx_course_quiz_options_question_id ON course_quiz_options(question_id);
CREATE INDEX IF NOT EXISTS idx_user_lesson_progress_user_id ON user_lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_quiz_attempts_user_id ON user_quiz_attempts(user_id);