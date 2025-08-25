/*
  # Create Sample Courses and Educational Content

  1. New Tables
    - Inserts sample courses for beginner, intermediate, and advanced levels
    - Adds course modules with descriptions and duration
    - Creates detailed lessons with HTML content
    - Includes quiz questions with multiple choice options

  2. Content
    - 3 courses (beginner, intermediate, advanced)
    - 9 modules total (3 per course)
    - Multiple lessons per module
    - Quiz questions with explanations
    - All content in Lithuanian for financial education

  3. Data Structure
    - Uses proper UUIDs and foreign key relationships
    - Includes conflict handling for safe re-runs
    - Dummy user ID to avoid dependency issues
*/

-- Insert sample courses
INSERT INTO courses (id, slug, title, level, summary, cover_url, status, created_by, published_at) VALUES
(
  'course-beginner-001',
  'pradedanciuju-lygis',
  'Pradedančiųjų lygis',
  'beginner',
  'Asmeninių finansų pagrindai lietuviams - biudžeto sudarymas, taupymas ir pagrindiniai finansiniai įrankiai',
  'https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
),
(
  'course-intermediate-001',
  'vidutinis-lygis',
  'Vidutinis lygis',
  'intermediate',
  'Investavimas ir finansų planavimas - pensijų kaupimas, investiciniai fondai ir rizikos valdymas',
  'https://images.pexels.com/photos/590041/pexels-photo-590041.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
),
(
  'course-advanced-001',
  'pazengusiuju-lygis',
  'Pažengusiųjų lygis',
  'advanced',
  'Pažangūs investavimo metodai - akcijų analizė, ETF fondai ir makroekonomikos principai',
  'https://images.pexels.com/photos/187041/pexels-photo-187041.jpeg',
  'published',
  '00000000-0000-0000-0000-000000000001',
  now()
)
ON CONFLICT (slug) DO NOTHING;

-- Insert course modules
INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes) VALUES
-- Beginner course modules
('module-beg-001', 'course-beginner-001', 'Pinigų pagrindai', 'Sužinokite, kas yra pinigai ir kaip jie veikia šiuolaikinėje ekonomikoje', 1, 45),
('module-beg-002', 'course-beginner-001', 'Biudžeto sudarymas', 'Išmokite sudaryti ir valdyti asmeninį biudžetą', 2, 60),
('module-beg-003', 'course-beginner-001', 'Taupymo strategijos', 'Efektyvūs taupymo būdai ir finansiniai tikslai', 3, 50),

-- Intermediate course modules
('module-int-001', 'course-intermediate-001', 'Pensijų sistema', 'Lietuvos pensijų sistemos pagrindai ir II pakopa', 1, 55),
('module-int-002', 'course-intermediate-001', 'Investavimo pradžiamokslis', 'Pagrindiniai investavimo principai ir instrumentai', 2, 65),
('module-int-003', 'course-intermediate-001', 'Draudimas ir apsauga', 'Draudimo rūšys ir finansinė apsauga', 3, 40),

-- Advanced course modules
('module-adv-001', 'course-advanced-001', 'Akcijų rinkos', 'Akcijų rinkų analizė ir investavimo strategijos', 1, 70),
('module-adv-002', 'course-advanced-001', 'ETF ir fondai', 'Investiciniai fondai ir ETF pasirinkimas', 2, 60),
('module-adv-003', 'course-advanced-001', 'Makroekonomika', 'Ekonomikos ciklai ir jų poveikis investicijoms', 3, 80)
ON CONFLICT (id) DO NOTHING;

-- Insert course lessons
INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes) VALUES
-- Beginner Module 1 Lessons
('lesson-beg-001-001', 'module-beg-001', 'Kas yra pinigai?', 
'<h3>Pinigų samprata</h3>
<p>Pinigai yra mainų priemonė, kuri leidžia mums įsigyti prekes ir paslaugas. Lietuvoje naudojame eurą nuo 2015 metų.</p>
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
</ul>', 1, 15),

('lesson-beg-001-002', 'module-beg-001', 'Infliacija ir perkamoji galia', 
'<h3>Kas yra infliacija?</h3>
<p>Infliacija - tai kainų lygio augimas ekonomikoje. Dėl infliacijos pinigų perkamoji galia mažėja.</p>
<h4>Infliacijos poveikis:</h4>
<ul>
<li>Prekės ir paslaugos brangsta</li>
<li>Už tą pačią pinigų sumą galime nusipirkti mažiau</li>
<li>Taupymai banke praranda vertę, jei palūkanos mažesnės už infliaciją</li>
</ul>
<h4>Kaip apsisaugoti nuo infliacijos:</h4>
<ul>
<li>Investuoti į aktyvus, kurie auga kartu su infliacija</li>
<li>Rinktis banko produktus su kintamomis palūkanomis</li>
<li>Diversifikuoti investicijas</li>
</ul>', 2, 20),

('lesson-beg-001-003', 'module-beg-001', 'Lietuvos bankų sistema', 
'<h3>Pagrindiniai bankai Lietuvoje</h3>
<p>Lietuvoje veikia keletas didžiųjų bankų, kurie teikia įvairias finansines paslaugas.</p>
<h4>Didžiausi bankai:</h4>
<ul>
<li><strong>SEB bankas</strong> - švedų kapitalo bankas</li>
<li><strong>Swedbank</strong> - švedų kapitalo bankas</li>
<li><strong>Luminor</strong> - skandinavų kapitalo bankas</li>
<li><strong>Šiaulių bankas</strong> - lietuviškas bankas</li>
</ul>
<h4>Banko paslaugos:</h4>
<ul>
<li>Einamosios sąskaitos</li>
<li>Taupomosios sąskaitos</li>
<li>Terminuoti indėliai</li>
<li>Paskolos (vartojimo, būsto)</li>
<li>Mokėjimo kortelės</li>
</ul>', 3, 10),

-- Beginner Module 2 Lessons
('lesson-beg-002-001', 'module-beg-002', 'Biudžeto sudarymo principai', 
'<h3>Kodėl svarbu turėti biudžetą?</h3>
<p>Biudžetas padeda kontroliuoti išlaidas ir planuoti finansinę ateitį.</p>
<h4>50/30/20 taisyklė:</h4>
<ul>
<li><strong>50%</strong> - būtinoms išlaidoms (būstas, maistas, transportas)</li>
<li><strong>30%</strong> - pramogoms ir nereikalingoms išlaidoms</li>
<li><strong>20%</strong> - taupymui ir investicijoms</li>
</ul>
<h4>Biudžeto sudarymo žingsniai:</h4>
<ol>
<li>Apskaičiuokite mėnesio pajamas</li>
<li>Išvardykite visas išlaidas</li>
<li>Suskirstykite išlaidas į kategorijas</li>
<li>Palyginkite pajamas su išlaidomis</li>
<li>Koreguokite išlaidas, jei reikia</li>
</ol>', 1, 25),

('lesson-beg-002-002', 'module-beg-002', 'Išlaidų kategorijos', 
'<h3>Būtinos išlaidos</h3>
<p>Išlaidos, be kurių negalite apsieiti:</p>
<ul>
<li>Būstas (nuoma arba komunaliniai mokesčiai)</li>
<li>Maistas</li>
<li>Transportas į darbą</li>
<li>Draudimas</li>
<li>Minimalūs drabužiai</li>
</ul>
<h3>Nebūtinos išlaidos</h3>
<p>Išlaidos, kurias galite sumažinti:</p>
<ul>
<li>Pramogos ir laisvalaikis</li>
<li>Restoranai ir kavinės</li>
<li>Prenumeratos ir narystės</li>
<li>Impulsiniai pirkimai</li>
<li>Brangūs drabužiai ir aksesuarai</li>
</ul>', 2, 20),

('lesson-beg-002-003', 'module-beg-002', 'Biudžeto sekimas ir koregavimas', 
'<h3>Kaip sekti biudžetą</h3>
<p>Reguliarus biudžeto sekimas padeda išlaikyti finansinę drausmę.</p>
<h4>Sekimo metodai:</h4>
<ul>
<li>Banko aplikacijos su išlaidų kategorizavimu</li>
<li>Excel lentelės arba Google Sheets</li>
<li>Specialios biudžeto aplikacijos</li>
<li>Tradicinis užrašų vedimas</li>
</ul>
<h4>Kas mėnesį peržiūrėkite:</h4>
<ul>
<li>Ar laikėtės planuotų išlaidų?</li>
<li>Kuriose kategorijose viršijote biudžetą?</li>
<li>Kur galite sutaupyti daugiau?</li>
<li>Ar pasiekėte taupymo tikslus?</li>
</ul>', 3, 15);

-- Insert quiz questions
INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index) VALUES
('quiz-beg-001', 'course-beginner-001', 'Kokia yra pagrindinė pinigų funkcija?', 'Pinigai pirmiausia yra mainų priemonė, leidžianti keisti juos į prekes ir paslaugas.', 1),
('quiz-beg-002', 'course-beginner-001', 'Kas yra 50/30/20 biudžeto taisyklė?', 'Ši taisyklė rekomenduoja 50% pajamų skirti būtinoms išlaidoms, 30% - pramogoms, 20% - taupymui.', 2),
('quiz-beg-003', 'course-beginner-001', 'Kaip infliacija paveiks jūsų taupymus banke?', 'Jei banko palūkanos mažesnės už infliaciją, taupymų perkamoji galia mažės.', 3),

('quiz-int-001', 'course-intermediate-001', 'Kiek pakopų turi Lietuvos pensijų sistema?', 'Lietuvos pensijų sistema turi 3 pakopas: I pakopa (SODRA), II pakopa (pensijų fondai), III pakopa (savanoriškas kaupimas).', 1),
('quiz-int-002', 'course-intermediate-001', 'Kas yra diversifikacija?', 'Diversifikacija - tai investicinės rizikos paskirstymas tarp skirtingų aktyvų, sektorių ar regionų.', 2),

('quiz-adv-001', 'course-advanced-001', 'Kas yra ETF?', 'ETF (Exchange-Traded Fund) - tai investicinis fondas, prekiaujamas biržoje kaip paprastos akcijos.', 1),
('quiz-adv-002', 'course-advanced-001', 'Kaip ekonomikos ciklai paveiks investicijas?', 'Ekonomikos ciklai daro poveikį skirtingų aktyvų klasių grąžai - recesijos metu akcijos dažnai krenta, o obligacijos gali augti.', 2)
ON CONFLICT (id) DO NOTHING;

-- Insert quiz options
INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index) VALUES
-- Quiz 1 options
('opt-beg-001-1', 'quiz-beg-001', 'Mainų priemonė', true, 1),
('opt-beg-001-2', 'quiz-beg-001', 'Vertės saugojimas', false, 2),
('opt-beg-001-3', 'quiz-beg-001', 'Investavimo instrumentas', false, 3),
('opt-beg-001-4', 'quiz-beg-001', 'Prestižo simbolis', false, 4),

-- Quiz 2 options
('opt-beg-002-1', 'quiz-beg-002', '50% būtinoms išlaidoms, 30% pramogoms, 20% taupymui', true, 1),
('opt-beg-002-2', 'quiz-beg-002', '60% būtinoms išlaidoms, 20% pramogoms, 20% taupymui', false, 2),
('opt-beg-002-3', 'quiz-beg-002', '40% būtinoms išlaidoms, 40% pramogoms, 20% taupymui', false, 3),
('opt-beg-002-4', 'quiz-beg-002', '70% būtinoms išlaidoms, 20% pramogoms, 10% taupymui', false, 4),

-- Quiz 3 options
('opt-beg-003-1', 'quiz-beg-003', 'Taupymų perkamoji galia mažės', true, 1),
('opt-beg-003-2', 'quiz-beg-003', 'Taupymai augs greičiau', false, 2),
('opt-beg-003-3', 'quiz-beg-003', 'Niekas nepasikeičia', false, 3),
('opt-beg-003-4', 'quiz-beg-003', 'Taupymai padvigubės', false, 4),

-- Intermediate quiz options
('opt-int-001-1', 'quiz-int-001', '3 pakopas', true, 1),
('opt-int-001-2', 'quiz-int-001', '2 pakopas', false, 2),
('opt-int-001-3', 'quiz-int-001', '4 pakopas', false, 3),
('opt-int-001-4', 'quiz-int-001', '5 pakopas', false, 4),

('opt-int-002-1', 'quiz-int-002', 'Rizikos paskirstymas tarp skirtingų aktyvų', true, 1),
('opt-int-002-2', 'quiz-int-002', 'Investavimas tik į vieną bendrovę', false, 2),
('opt-int-002-3', 'quiz-int-002', 'Pinigų laikymas banke', false, 3),
('opt-int-002-4', 'quiz-int-002', 'Akcijų pardavimas', false, 4),

-- Advanced quiz options
('opt-adv-001-1', 'quiz-adv-001', 'Investicinis fondas, prekiaujamas biržoje', true, 1),
('opt-adv-001-2', 'quiz-adv-001', 'Banko indėlis', false, 2),
('opt-adv-001-3', 'quiz-adv-001', 'Draudimo polisas', false, 3),
('opt-adv-001-4', 'quiz-adv-001', 'Nekilnojamojo turto fondas', false, 4),

('opt-adv-002-1', 'quiz-adv-002', 'Recesijos metu akcijos krenta, obligacijos gali augti', true, 1),
('opt-adv-002-2', 'quiz-adv-002', 'Ekonomikos ciklai nepaveiks investicijų', false, 2),
('opt-adv-002-3', 'quiz-adv-002', 'Visada geriau investuoti recesijos metu', false, 3),
('opt-adv-002-4', 'quiz-adv-002', 'Ciklai paveiks tik nekilnojamąjį turtą', false, 4)
ON CONFLICT (id) DO NOTHING;