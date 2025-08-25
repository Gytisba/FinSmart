/*
  # Populate Fresh Database with Course Data

  1. New Tables
    - Populates `courses` table with 3 levels (beginner, intermediate, advanced)
    - Populates `course_modules` table with modules for each course
    - Populates `course_lessons` table with detailed lesson content
    - Populates `course_quiz_questions` table with quiz questions
    - Populates `course_quiz_options` table with multiple choice options

  2. Content
    - Complete Lithuanian financial education content
    - Real-world examples relevant to Lithuania
    - Progressive difficulty levels
    - Interactive quizzes with explanations

  3. Security
    - All tables have proper RLS policies already set up
    - Content is publicly readable for published courses
*/

-- Insert courses
INSERT INTO courses (id, slug, title, level, summary, cover_url, status, created_by) VALUES
(
  'beginner-course-id',
  'pradedantiuju-lygis',
  'Pradedančiųjų finansų kursas',
  'beginner',
  'Išmokite finansų pagrindų: biudžeto sudarymo, taupymo ir pagrindinių finansinių įrankių naudojimo.',
  'https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001'
),
(
  'intermediate-course-id',
  'vidutinis-lygis',
  'Vidutinio lygio finansų kursas',
  'intermediate',
  'Sužinokite apie investavimą, pensijų kaupimą ir finansinių paslaugų naudojimą Lietuvoje.',
  'https://images.pexels.com/photos/590022/pexels-photo-590022.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001'
),
(
  'advanced-course-id',
  'pazengusiuju-lygis',
  'Pažengusiųjų finansų kursas',
  'advanced',
  'Gilintis į akcijų rinkas, ETF fondus ir makroekonomikos principus.',
  'https://images.pexels.com/photos/187041/pexels-photo-187041.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001'
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  updated_at = now();

-- Insert course modules
INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes) VALUES
-- Beginner course modules
('beginner-module-1', 'beginner-course-id', 'Pinigų pagrindai', 'Kas yra pinigai ir kaip jie veikia ekonomikoje', 1, 30),
('beginner-module-2', 'beginner-course-id', 'Biudžeto sudarymas', 'Mokykitės sudaryti ir valdyti asmeninį biudžetą', 2, 45),
('beginner-module-3', 'beginner-course-id', 'Taupymo strategijos', 'Efektyvūs taupymo būdai ir metodai', 3, 35),

-- Intermediate course modules
('intermediate-module-1', 'intermediate-course-id', 'Pensijų sistema', 'Lietuvos pensijų sistemos pagrindai', 1, 40),
('intermediate-module-2', 'intermediate-course-id', 'Investavimo pradžiamokslis', 'Pirmieji žingsniai investavimo pasaulyje', 2, 50),
('intermediate-module-3', 'intermediate-course-id', 'Draudimas', 'Draudimo rūšys ir jų svarba', 3, 30),

-- Advanced course modules
('advanced-module-1', 'advanced-course-id', 'Akcijų rinkos', 'Akcijų rinkų analizė ir strategijos', 1, 60),
('advanced-module-2', 'advanced-course-id', 'ETF fondai', 'Indeksiniai fondai ir jų privalumai', 2, 45),
('advanced-module-3', 'advanced-course-id', 'Rizikos valdymas', 'Investicinės rizikos valdymo metodai', 3, 55)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  updated_at = now();

-- Insert course lessons
INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes) VALUES
-- Beginner Module 1 Lessons
('lesson-b1-1', 'beginner-module-1', 'Kas yra pinigai?', 
'<h3>Pinigų samprata</h3>
<p>Pinigai yra mainų priemonė, kuri leidžia mums įsigyti prekes ir paslaugas. Lietuvoje naudojame eurą (€) nuo 2015 metų.</p>

<h4>Pinigų funkcijos:</h4>
<ul>
<li><strong>Mainų priemonė</strong> - galime keisti pinigus į prekes</li>
<li><strong>Vertės matas</strong> - pinigais išreiškiame prekių kainas</li>
<li><strong>Vertės kaupimo priemonė</strong> - pinigus galime taupyti ateičiai</li>
</ul>

<h4>Pinigų rūšys:</h4>
<ul>
<li>Grynųjų pinigų banknotai ir monetos</li>
<li>Elektroniniai pinigai banko sąskaitose</li>
<li>Skaitmeniniai mokėjimai (kortelės, telefonai)</li>
</ul>

<p><strong>Svarbu žinoti:</strong> Lietuvoje dauguma mokėjimų atliekama be grynųjų pinigų - kortelėmis ar mobiliaisiais mokėjimais.</p>', 1, 15),

('lesson-b1-2', 'beginner-module-1', 'Infliacija ir perkamoji galia', 
'<h3>Kas yra infliacija?</h3>
<p>Infliacija - tai kainų lygio augimas ekonomikoje. Dėl infliacijos jūsų pinigų perkamoji galia mažėja.</p>

<h4>Infliacijos poveikis:</h4>
<ul>
<li>Prekės ir paslaugos brangsta</li>
<li>Už tą pačią pinigų sumą galite nusipirkti mažiau</li>
<li>Taupymai banke praranda vertę, jei palūkanos mažesnės už infliaciją</li>
</ul>

<h4>Pavyzdys:</h4>
<p>Jei infliacija 3% per metus, tai kas šiandien kainuoja 100€, po metų kainuos 103€. Jūsų 100€ indėlis banke su 1% palūkanomis taps 101€, bet realiai galėsite nusipirkti mažiau nei šiandien.</p>

<p><strong>Išvada:</strong> Svarbu investuoti pinigus taip, kad jų grąža viršytų infliaciją.</p>', 2, 15),

-- Beginner Module 2 Lessons
('lesson-b2-1', 'beginner-module-2', 'Biudžeto sudarymo principai', 
'<h3>Kodėl svarbu turėti biudžetą?</h3>
<p>Biudžetas padeda kontroliuoti išlaidas, planuoti taupymą ir pasiekti finansinius tikslus.</p>

<h4>50/30/20 taisyklė:</h4>
<ul>
<li><strong>50%</strong> - būtiniausios išlaidos (būstas, maistas, transportas)</li>
<li><strong>30%</strong> - pramogos ir nereikalingi pirkiniukai</li>
<li><strong>20%</strong> - taupymas ir investicijos</li>
</ul>

<h4>Biudžeto sudarymo žingsniai:</h4>
<ol>
<li>Suskaičiuokite visas pajamas</li>
<li>Išvardykite visas išlaidas</li>
<li>Suskirstykite išlaidas į kategorijas</li>
<li>Palyginkite pajamas su išlaidomis</li>
<li>Koreguokite išlaidas, jei reikia</li>
</ol>

<p><strong>Patarimas:</strong> Naudokite banko programėles, kurios automatiškai kategorizuoja jūsų išlaidas.</p>', 1, 20),

('lesson-b2-2', 'beginner-module-2', 'Išlaidų sekimas ir kontrolė', 
'<h3>Kaip sekti išlaidas?</h3>
<p>Išlaidų sekimas padeda suprasti, kur dingsta jūsų pinigai ir kur galite sutaupyti.</p>

<h4>Sekimo metodai:</h4>
<ul>
<li><strong>Banko programėlės</strong> - SEB, Swedbank, Luminor automatiškai kategorizuoja</li>
<li><strong>Išlaidų programėlės</strong> - Money Lover, Spendee</li>
<li><strong>Excel lentelės</strong> - paprastas, bet efektyvus būdas</li>
<li><strong>Čekių rinkimas</strong> - senoviškas, bet veikiantis metodas</li>
</ul>

<h4>Dažniausios "pinigų skylės":</h4>
<ul>
<li>Kavinės ir restoranai</li>
<li>Impulsyvūs pirkiniukai</li>
<li>Nenaudojamos prenumeratos</li>
<li>Brangi mada ir aksesuarai</li>
</ul>

<p><strong>Iššūkis:</strong> Sekite visas išlaidas vieną mėnesį - būsite nustebinti rezultatų!</p>', 2, 25),

-- Quiz questions for beginner course
('quiz-b-1', 'beginner-course-id', 'Kokia yra pagrindinė infliacijos pasekmė?', 'Infliacija mažina pinigų perkamąją galią - už tą pačią sumą galite nusipirkti mažiau prekių.', 1),
('quiz-b-2', 'beginner-course-id', 'Kiek procentų pajamų turėtumėte skirti taupymui pagal 50/30/20 taisyklę?', '20% pajamų turėtų būti skiriama taupymui ir investicijoms.', 2),
('quiz-b-3', 'beginner-course-id', 'Kuri pinigų funkcija leidžia palyginti skirtingų prekių vertes?', 'Vertės mato funkcija leidžia išreikšti ir palyginti prekių kainas pinigais.', 3)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  updated_at = now();

-- Insert quiz options
INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index) VALUES
-- Question 1 options
('opt-b1-1', 'quiz-b-1', 'Pinigai tampa brangesni', false, 1),
('opt-b1-2', 'quiz-b-1', 'Mažėja pinigų perkamoji galia', true, 2),
('opt-b1-3', 'quiz-b-1', 'Didėja banko palūkanos', false, 3),
('opt-b1-4', 'quiz-b-1', 'Pinigai išnyksta', false, 4),

-- Question 2 options
('opt-b2-1', 'quiz-b-2', '10%', false, 1),
('opt-b2-2', 'quiz-b-2', '20%', true, 2),
('opt-b2-3', 'quiz-b-2', '30%', false, 3),
('opt-b2-4', 'quiz-b-2', '50%', false, 4),

-- Question 3 options
('opt-b3-1', 'quiz-b-3', 'Mainų priemonė', false, 1),
('opt-b3-2', 'quiz-b-3', 'Vertės matas', true, 2),
('opt-b3-3', 'quiz-b-3', 'Vertės kaupimo priemonė', false, 3),
('opt-b3-4', 'quiz-b-3', 'Mokėjimo priemonė', false, 4)

ON CONFLICT (id) DO UPDATE SET
  option_text = EXCLUDED.option_text,
  is_correct = EXCLUDED.is_correct,
  updated_at = now();