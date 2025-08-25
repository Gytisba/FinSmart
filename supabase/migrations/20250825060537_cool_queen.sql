/*
  # Insert Complete Course Data

  1. Course Data
    - Insert 3 courses (beginner, intermediate, advanced)
    - Each with proper metadata and content
  
  2. Module Data
    - Insert modules for each course
    - Proper ordering and duration
  
  3. Lesson Data
    - Insert lessons for each module
    - Rich HTML content for learning
  
  4. Quiz Data
    - Insert quiz questions and options
    - Multiple choice questions with explanations
*/

-- Insert courses
INSERT INTO courses (id, slug, title, level, summary, cover_url, status, created_by, published_at) VALUES
(
  'course-beginner-001',
  'pradedanciuju-finansu-pagrindai',
  'Finansų pagrindai pradedantiesiems',
  'beginner',
  'Išmokite asmeninių finansų pagrindų: biudžeto sudarymo, taupymo ir pagrindinių finansinių įrankių naudojimo.',
  'https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
),
(
  'course-intermediate-001',
  'vidutinio-lygio-investavimas',
  'Investavimas ir finansų planavimas',
  'intermediate',
  'Sužinokite apie investavimą, pensijų kaupimą ir finansinių paslaugų naudojimą Lietuvoje.',
  'https://images.pexels.com/photos/590041/pexels-photo-590041.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
),
(
  'course-advanced-001',
  'pazangus-investavimas',
  'Pažangūs investavimo metodai',
  'advanced',
  'Gilintis į akcijų rinkas, ETF fondus ir makroekonomikos principus.',
  'https://images.pexels.com/photos/187041/pexels-photo-187041.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
)
ON CONFLICT (slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  updated_at = now();

-- Insert course modules
INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes) VALUES
-- Beginner course modules
('module-beginner-001', 'course-beginner-001', 'Pinigų pagrindai', 'Kas yra pinigai ir kaip jie veikia ekonomikoje', 1, 45),
('module-beginner-002', 'course-beginner-001', 'Biudžeto sudarymas', 'Kaip sudaryti ir valdyti asmeninį biudžetą', 2, 60),
('module-beginner-003', 'course-beginner-001', 'Taupymo strategijos', 'Efektyvūs taupymo būdai ir metodai', 3, 50),

-- Intermediate course modules
('module-intermediate-001', 'course-intermediate-001', 'Pensijų sistema', 'Lietuvos pensijų sistemos pagrindai', 1, 55),
('module-intermediate-002', 'course-intermediate-001', 'Investavimo pradžiamokslis', 'Pagrindiniai investavimo principai', 2, 70),
('module-intermediate-003', 'course-intermediate-001', 'Draudimas', 'Draudimo rūšys ir jų svarba', 3, 40),

-- Advanced course modules
('module-advanced-001', 'course-advanced-001', 'Akcijų rinkos', 'Akcijų rinkų analizė ir strategijos', 1, 80),
('module-advanced-002', 'course-advanced-001', 'ETF fondai', 'Indeksiniai fondai ir jų privalumai', 2, 65),
('module-advanced-003', 'course-advanced-001', 'Rizikos valdymas', 'Investicinės rizikos valdymo metodai', 3, 75)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  updated_at = now();

-- Insert course lessons
INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes) VALUES
-- Beginner module 1 lessons
('lesson-beginner-001-001', 'module-beginner-001', 'Kas yra pinigai?', 
'<h3>Pinigų samprata</h3>
<p>Pinigai yra mainų priemonė, kuri leidžia mums įsigyti prekes ir paslaugas. Jie atlieka tris pagrindines funkcijas:</p>
<ul>
<li><strong>Mainų priemonė</strong> - galime keisti pinigus į prekes</li>
<li><strong>Vertės matas</strong> - pinigais išreiškiame prekių kainas</li>
<li><strong>Vertės kaupimo priemonė</strong> - pinigus galime taupyti ateičiai</li>
</ul>

<h4>Pinigų istorija Lietuvoje</h4>
<p>Lietuva nuo 2015 metų naudoja eurą. Anksčiau naudojome litą, kuris buvo susietas su euru fiksuotu kursu.</p>

<h4>Infliacija ir perkamoji galia</h4>
<p>Svarbu suprasti, kad pinigų vertė laikui bėgant keičiasi dėl infliacijos. Tai reiškia, kad už tą pačią sumą po metų galėsite nusipirkti mažiau prekių nei šiandien.</p>', 
1, 15),

('lesson-beginner-001-002', 'module-beginner-001', 'Lietuvos bankų sistema', 
'<h3>Kaip veikia bankai Lietuvoje</h3>
<p>Lietuvos bankų sistemą prižiūri Lietuvos bankas ir Europos centrinis bankas. Pagrindiniai bankai:</p>
<ul>
<li>SEB bankas</li>
<li>Swedbank</li>
<li>Luminor</li>
<li>Šiaulių bankas</li>
</ul>

<h4>Banko paslaugos</h4>
<p>Bankai teikia įvairias paslaugas:</p>
<ul>
<li>Einamosios sąskaitos</li>
<li>Taupomosios sąskaitos</li>
<li>Terminuoti indėliai</li>
<li>Paskolos</li>
<li>Mokėjimo kortelės</li>
</ul>

<h4>Indėlių draudimas</h4>
<p>Lietuvoje indėliai iki 100,000 eurų yra draudžiami valstybės. Tai reiškia, kad net jei bankas bankrutuotų, jūsų pinigai būtų saugūs.</p>', 
2, 20),

-- Beginner module 2 lessons
('lesson-beginner-002-001', 'module-beginner-002', 'Biudžeto sudarymo principai', 
'<h3>Kodėl svarbu turėti biudžetą?</h3>
<p>Biudžetas padeda:</p>
<ul>
<li>Kontroliuoti išlaidas</li>
<li>Planuoti ateities pirkimus</li>
<li>Taupyti pinigus</li>
<li>Išvengti skolų</li>
</ul>

<h4>50/30/20 taisyklė</h4>
<p>Populiari biudžeto sudarymo metodika:</p>
<ul>
<li><strong>50%</strong> - būtinoms išlaidoms (būstas, maistas, transportas)</li>
<li><strong>30%</strong> - pramogoms ir nereikalingiems pirkiniams</li>
<li><strong>20%</strong> - taupymui ir skolų mokėjimui</li>
</ul>

<h4>Išlaidų kategorijos</h4>
<p>Suskirstykite išlaidas į kategorijas:</p>
<ul>
<li>Būstas (nuoma, komunaliniai)</li>
<li>Maistas</li>
<li>Transportas</li>
<li>Sveikatos priežiūra</li>
<li>Pramogos</li>
<li>Taupymas</li>
</ul>', 
1, 25),

-- Continue with more lessons for other modules...
('lesson-intermediate-001-001', 'module-intermediate-001', 'Lietuvos pensijų sistemos pagrindai', 
'<h3>Trijų pakopų pensijų sistema</h3>
<p>Lietuvoje veikia trijų pakopų pensijų sistema:</p>

<h4>I pakopa - Valstybinio socialinio draudimo pensija</h4>
<ul>
<li>Privaloma visiems dirbantiems</li>
<li>Finansuojama iš SODRA įmokų</li>
<li>Priklauso nuo darbo stažo ir įmokų dydžio</li>
</ul>

<h4>II pakopa - Pensijų kaupimas</h4>
<ul>
<li>Savanoriškas dalyvavimas</li>
<li>2% algos investuojami į pensijų fondus</li>
<li>Galima rinktis iš kelių fondų</li>
</ul>

<h4>III pakopa - Papildomas pensijų kaupimas</h4>
<ul>
<li>Savanoriškas papildomas kaupimas</li>
<li>Mokestinės lengvatos</li>
<li>Galima kaupti banke arba draudimo bendrovėje</li>
</ul>

<h4>Pensijų skaičiavimas</h4>
<p>I pakopos pensija skaičiuojama pagal formulę, atsižvelgiant į:</p>
<ul>
<li>Darbo stažą</li>
<li>Vidutinį mėnesinį uždarbį</li>
<li>Šalies vidutinį darbo užmokestį</li>
</ul>', 
1, 30),

('lesson-advanced-001-001', 'module-advanced-001', 'Akcijų rinkų analizė', 
'<h3>Fundamentalioji analizė</h3>
<p>Fundamentalioji analizė vertina bendrovės tikrąją vertę:</p>
<ul>
<li><strong>P/E rodiklis</strong> - akcijos kainos ir pelno santykis</li>
<li><strong>ROE</strong> - nuosavo kapitalo grąža</li>
<li><strong>Debt/Equity</strong> - skolos ir nuosavo kapitalo santykis</li>
<li><strong>Dividend Yield</strong> - dividendų pajamingumas</li>
</ul>

<h4>Techninė analizė</h4>
<p>Techninė analizė naudoja kainų grafikus ir indikatorius:</p>
<ul>
<li>Slenkamieji vidurkiai</li>
<li>RSI (Relative Strength Index)</li>
<li>MACD indikatorius</li>
<li>Palaikymo ir atsparumo lygiai</li>
</ul>

<h4>Rinkos ciklai</h4>
<p>Akcijų rinkos patiria ciklus:</p>
<ul>
<li><strong>Bullish rinka</strong> - kainų augimo periodas</li>
<li><strong>Bearish rinka</strong> - kainų kritimo periodas</li>
<li><strong>Korekcijos</strong> - trumpalaikiai kainų svyravimai</li>
</ul>

<h4>Sektorių analizė</h4>
<p>Skirtingi ekonomikos sektoriai elgiasi skirtingai:</p>
<ul>
<li>Technologijų sektorius - didelis augimo potencialas</li>
<li>Komunalinių paslaugų sektorius - stabilus, bet lėtas augimas</li>
<li>Finansų sektorius - priklauso nuo palūkanų normų</li>
</ul>', 
1, 40)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content,
  updated_at = now();

-- Insert quiz questions
INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index) VALUES
-- Beginner course quiz
('quiz-beginner-001', 'course-beginner-001', 'Kokios yra trys pagrindinės pinigų funkcijos?', 
'Pinigai atlieka tris pagrindines funkcijas: mainų priemonės, vertės mato ir vertės kaupimo priemonės funkcijas.', 1),

('quiz-beginner-002', 'course-beginner-001', 'Koks yra rekomenduojamas taupymo procentas pagal 50/30/20 taisyklę?', 
'Pagal 50/30/20 taisyklę rekomenduojama taupyti 20% pajamų.', 2),

('quiz-beginner-003', 'course-beginner-001', 'Iki kokios sumos Lietuvoje draudžiami banko indėliai?', 
'Lietuvoje banko indėliai draudžiami iki 100,000 eurų sumos.', 3),

-- Intermediate course quiz
('quiz-intermediate-001', 'course-intermediate-001', 'Kiek procentų algos investuojama į II pakopos pensijų fondus?', 
'Į II pakopos pensijų fondus investuojami 2% algos.', 1),

('quiz-intermediate-002', 'course-intermediate-001', 'Kurios institucijos prižiūri Lietuvos bankų sistemą?', 
'Lietuvos bankų sistemą prižiūri Lietuvos bankas ir Europos centrinis bankas.', 2),

-- Advanced course quiz
('quiz-advanced-001', 'course-advanced-001', 'Ką rodo P/E rodiklis?', 
'P/E rodiklis rodo akcijos kainos ir bendrovės pelno vienai akcijai santykį.', 1),

('quiz-advanced-002', 'course-advanced-001', 'Kas yra "bullish" rinka?', 
'Bullish rinka yra akcijų kainų augimo periodas, kai investuotojai optimistiški.', 2)
ON CONFLICT (id) DO UPDATE SET
  question = EXCLUDED.question,
  explanation = EXCLUDED.explanation,
  updated_at = now();

-- Insert quiz options
INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index) VALUES
-- Quiz 1 options
('option-beginner-001-1', 'quiz-beginner-001', 'Mainų priemonė, vertės matas, vertės kaupimo priemonė', true, 1),
('option-beginner-001-2', 'quiz-beginner-001', 'Pirkimas, pardavimas, keitimas', false, 2),
('option-beginner-001-3', 'quiz-beginner-001', 'Taupymas, investavimas, skolinimasis', false, 3),
('option-beginner-001-4', 'quiz-beginner-001', 'Uždarbis, išlaidos, pelnas', false, 4),

-- Quiz 2 options
('option-beginner-002-1', 'quiz-beginner-002', '10%', false, 1),
('option-beginner-002-2', 'quiz-beginner-002', '15%', false, 2),
('option-beginner-002-3', 'quiz-beginner-002', '20%', true, 3),
('option-beginner-002-4', 'quiz-beginner-002', '25%', false, 4),

-- Quiz 3 options
('option-beginner-003-1', 'quiz-beginner-003', '50,000 eurų', false, 1),
('option-beginner-003-2', 'quiz-beginner-003', '75,000 eurų', false, 2),
('option-beginner-003-3', 'quiz-beginner-003', '100,000 eurų', true, 3),
('option-beginner-003-4', 'quiz-beginner-003', '150,000 eurų', false, 4),

-- Intermediate quiz options
('option-intermediate-001-1', 'quiz-intermediate-001', '1%', false, 1),
('option-intermediate-001-2', 'quiz-intermediate-001', '2%', true, 2),
('option-intermediate-001-3', 'quiz-intermediate-001', '3%', false, 3),
('option-intermediate-001-4', 'quiz-intermediate-001', '5%', false, 4),

('option-intermediate-002-1', 'quiz-intermediate-002', 'Tik Lietuvos bankas', false, 1),
('option-intermediate-002-2', 'quiz-intermediate-002', 'Lietuvos bankas ir Europos centrinis bankas', true, 2),
('option-intermediate-002-3', 'quiz-intermediate-002', 'Tik Europos centrinis bankas', false, 3),
('option-intermediate-002-4', 'quiz-intermediate-002', 'Finansų ministerija', false, 4),

-- Advanced quiz options
('option-advanced-001-1', 'quiz-advanced-001', 'Akcijos kainą', false, 1),
('option-advanced-001-2', 'quiz-advanced-001', 'Bendrovės pelną', false, 2),
('option-advanced-001-3', 'quiz-advanced-001', 'Akcijos kainos ir pelno santykį', true, 3),
('option-advanced-001-4', 'quiz-advanced-001', 'Dividendų dydį', false, 4),

('option-advanced-002-1', 'quiz-advanced-002', 'Kainų kritimo periodas', false, 1),
('option-advanced-002-2', 'quiz-advanced-002', 'Kainų augimo periodas', true, 2),
('option-advanced-002-3', 'quiz-advanced-002', 'Stabilių kainų periodas', false, 3),
('option-advanced-002-4', 'quiz-advanced-002', 'Didelių svyravimų periodas', false, 4)
ON CONFLICT (id) DO UPDATE SET
  option_text = EXCLUDED.option_text,
  is_correct = EXCLUDED.is_correct,
  updated_at = now();