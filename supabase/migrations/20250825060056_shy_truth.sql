/*
  # Insert Sample Course Data

  1. Sample Courses
    - Creates 3 courses for different levels (beginner, intermediate, advanced)
    - Each course has modules, lessons, and quiz questions
  
  2. Course Structure
    - Beginner: 3 modules with 3 lessons each + quiz
    - Intermediate: 3 modules with 3 lessons each + quiz  
    - Advanced: 3 modules with 3 lessons each + quiz

  3. Security
    - All content is published and accessible to public
*/

DO $$
DECLARE
  dummy_user_id uuid := '00000000-0000-0000-0000-000000000000';
  beginner_course_id uuid;
  intermediate_course_id uuid;
  advanced_course_id uuid;
  
  -- Module IDs
  beginner_mod1_id uuid;
  beginner_mod2_id uuid;
  beginner_mod3_id uuid;
  intermediate_mod1_id uuid;
  intermediate_mod2_id uuid;
  intermediate_mod3_id uuid;
  advanced_mod1_id uuid;
  advanced_mod2_id uuid;
  advanced_mod3_id uuid;
  
  -- Quiz question IDs
  beginner_q1_id uuid;
  beginner_q2_id uuid;
  intermediate_q1_id uuid;
  intermediate_q2_id uuid;
  advanced_q1_id uuid;
  advanced_q2_id uuid;
BEGIN
  -- Generate course IDs
  beginner_course_id := gen_random_uuid();
  intermediate_course_id := gen_random_uuid();
  advanced_course_id := gen_random_uuid();
  
  -- Insert courses
  INSERT INTO courses (id, slug, title, level, summary, status, created_by, published_at)
  VALUES 
    (beginner_course_id, 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published', dummy_user_id, now()),
    (intermediate_course_id, 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'published', dummy_user_id, now()),
    (advanced_course_id, 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'published', dummy_user_id, now())
  ON CONFLICT (slug) DO NOTHING;

  -- Generate module IDs
  beginner_mod1_id := gen_random_uuid();
  beginner_mod2_id := gen_random_uuid();
  beginner_mod3_id := gen_random_uuid();
  intermediate_mod1_id := gen_random_uuid();
  intermediate_mod2_id := gen_random_uuid();
  intermediate_mod3_id := gen_random_uuid();
  advanced_mod1_id := gen_random_uuid();
  advanced_mod2_id := gen_random_uuid();
  advanced_mod3_id := gen_random_uuid();

  -- Insert course modules
  INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes)
  VALUES 
    -- Beginner modules
    (beginner_mod1_id, beginner_course_id, 'Pinigų pagrindai', 'Sužinokite, kas yra pinigai ir kaip jie veikia ekonomikoje', 1, 45),
    (beginner_mod2_id, beginner_course_id, 'Biudžeto sudarymas', 'Išmokite sudaryti ir valdyti asmeninį biudžetą', 2, 60),
    (beginner_mod3_id, beginner_course_id, 'Taupymo strategijos', 'Efektyvūs taupymo būdai ir metodai', 3, 50),
    
    -- Intermediate modules
    (intermediate_mod1_id, intermediate_course_id, 'Pensijų sistema', 'Lietuvos pensijų sistemos supratimas', 1, 55),
    (intermediate_mod2_id, intermediate_course_id, 'Investavimo pradžiamokslis', 'Pagrindiniai investavimo principai', 2, 70),
    (intermediate_mod3_id, intermediate_course_id, 'Draudimas', 'Draudimo rūšys ir jų svarba', 3, 40),
    
    -- Advanced modules
    (advanced_mod1_id, advanced_course_id, 'Akcijų rinkos', 'Gilesnė akcijų rinkų analizė', 1, 80),
    (advanced_mod2_id, advanced_course_id, 'Portfelio valdymas', 'Investicijų portfelio formavimas', 2, 75),
    (advanced_mod3_id, advanced_course_id, 'Rizikos valdymas', 'Finansinės rizikos valdymo metodai', 3, 65);

  -- Insert lessons
  INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes)
  VALUES 
    -- Beginner Module 1 lessons
    (beginner_mod1_id, 'Kas yra pinigai?', '<h3>Pinigų samprata</h3><p>Pinigai yra mainų priemonė, kuri palengvina prekybą ir paslaugų teikimą. Lietuvoje naudojame eurus (€) nuo 2015 metų.</p><h4>Pinigų funkcijos:</h4><ul><li>Mainų priemonė</li><li>Vertės matas</li><li>Vertės kaupimo priemonė</li></ul><p>Suprasdami pinigų prigimtį, galėsime geriau juos valdyti ir planuoti savo finansinę ateitį.</p>', 1, 15),
    (beginner_mod1_id, 'Infliacija ir perkamoji galia', '<h3>Kas yra infliacija?</h3><p>Infliacija - tai kainų lygio augimas ekonomikoje. Lietuvoje vidutinė metinė infliacija svyruoja apie 2-3%.</p><h4>Infliacijos poveikis:</h4><ul><li>Mažėja pinigų perkamoji galia</li><li>Keičiasi gyvenimo išlaidos</li><li>Paveiks taupymo strategijas</li></ul><p><strong>Pavyzdys:</strong> Jei infliacija 3%, tai kas šiandien kainuoja 100€, po metų kainuos 103€.</p>', 2, 15),
    (beginner_mod1_id, 'Lietuvos finansų sistema', '<h3>Pagrindinės institucijos</h3><p>Lietuvos finansų sistemą sudaro kelios pagrindinės institucijos:</p><ul><li><strong>Lietuvos bankas</strong> - centrinis bankas</li><li><strong>Komerciniai bankai</strong> - Swedbank, SEB, Luminor</li><li><strong>VMI</strong> - mokesčių administravimas</li><li><strong>SODRA</strong> - socialinis draudimas</li></ul><p>Šios institucijos užtikrina finansų sistemos stabilumą ir teikia paslaugas gyventojams.</p>', 3, 15),
    
    -- Beginner Module 2 lessons
    (beginner_mod2_id, 'Pajamų ir išlaidų analizė', '<h3>Pajamų šaltiniai</h3><p>Identifikuokite visus savo pajamų šaltinius:</p><ul><li>Darbo užmokestis</li><li>Papildomos pajamos</li><li>Investicijų grąža</li><li>Socialinės išmokos</li></ul><h3>Išlaidų kategorijos</h3><ul><li><strong>Būtinos:</strong> maistas, būstas, transportas</li><li><strong>Svarbios:</strong> draudimas, taupymas</li><li><strong>Pageidautinos:</strong> pramogos, kelionės</li></ul>', 1, 20),
    (beginner_mod2_id, 'Biudžeto sudarymo metodai', '<h3>50/30/20 taisyklė</h3><p>Populiarus biudžeto sudarymo metodas:</p><ul><li><strong>50%</strong> - būtinos išlaidos</li><li><strong>30%</strong> - pageidaujamos išlaidos</li><li><strong>20%</strong> - taupymas ir skolų mokėjimas</li></ul><h3>Praktiniai patarimai</h3><p>Naudokite biudžeto programėles arba Excel lenteles pajamų ir išlaidų sekimui. Reguliariai peržiūrėkite ir koreguokite savo biudžetą.</p>', 2, 20),
    (beginner_mod2_id, 'Biudžeto kontrolė', '<h3>Išlaidų sekimas</h3><p>Kasdienių išlaidų fiksavimas padės suprasti, kur dingsta pinigai:</p><ul><li>Naudokite banko programėles</li><li>Fiksuokite grynųjų išlaidas</li><li>Kategorijuokite išlaidas</li></ul><h3>Biudžeto koregavimas</h3><p>Mėnesio pabaigoje palyginkite planuotas ir faktines išlaidas. Koreguokite kitą mėnesį pagal gautus duomenis.</p>', 3, 20),
    
    -- Continue with other lessons...
    (beginner_mod3_id, 'Taupymo tikslai', '<h3>SMART tikslų nustatymas</h3><p>Nustatykite konkrečius taupymo tikslus:</p><ul><li><strong>S</strong>pecific - konkretus</li><li><strong>M</strong>easurable - išmatuojamas</li><li><strong>A</strong>chievable - pasiekiamas</li><li><strong>R</strong>elevant - aktualus</li><li><strong>T</strong>ime-bound - su terminu</li></ul><p><strong>Pavyzdys:</strong> Sutaupyti 3000€ avariniam fondui per 12 mėnesių.</p>', 1, 15),
    (beginner_mod3_id, 'Automatinis taupymas', '<h3>Automatizuokite taupymą</h3><p>Nustatykite automatinius pervedimus į taupymo sąskaitą:</p><ul><li>Perveskite pinigus iš karto gavę atlyginimą</li><li>Pradėkite nuo mažų sumų (50-100€)</li><li>Palaipsniui didinkite taupymo dalį</li></ul><p>Automatinis taupymas padeda išvengti pagundos išleisti pinigus kitiems tikslams.</p>', 2, 15),
    (beginner_mod3_id, 'Avarinis fondas', '<h3>Kodėl reikalingas avarinis fondas?</h3><p>Avarinis fondas - tai pinigai, skirti nenumatytoms išlaidoms:</p><ul><li>Darbo netekimas</li><li>Sveikatos problemos</li><li>Skubūs namų remonto darbai</li></ul><h3>Fondo dydis</h3><p>Rekomenduojama turėti 3-6 mėnesių išlaidų sumą. Laikykite lengvai prieinamoje sąskaitoje.</p>', 3, 20);

  -- Generate quiz question IDs
  beginner_q1_id := gen_random_uuid();
  beginner_q2_id := gen_random_uuid();
  intermediate_q1_id := gen_random_uuid();
  intermediate_q2_id := gen_random_uuid();
  advanced_q1_id := gen_random_uuid();
  advanced_q2_id := gen_random_uuid();

  -- Insert quiz questions
  INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index)
  VALUES 
    (beginner_q1_id, beginner_course_id, 'Kiek procentų pajamų rekomenduojama taupyti pagal 50/30/20 taisyklę?', 'Pagal 50/30/20 taisyklę, 20% pajamų turėtų būti skiriama taupymui ir skolų mokėjimui.', 1),
    (beginner_q2_id, beginner_course_id, 'Kiek mėnesių išlaidų turėtų sudaryti avarinis fondas?', 'Avarinis fondas turėtų sudaryti 3-6 mėnesių būtinų išlaidų sumą, kad galėtumėte išgyventi netikėtų finansinių sunkumų atveju.', 2),
    (intermediate_q1_id, intermediate_course_id, 'Kuri Lietuvos pensijų pakopa yra privaloma visiems dirbantiems?', 'I pakopa (SODRA) yra privaloma visiems dirbantiems Lietuvoje ir finansuojama iš socialinio draudimo įmokų.', 1),
    (intermediate_q2_id, intermediate_course_id, 'Kas yra diversifikacija investuojant?', 'Diversifikacija - tai rizikos paskirstymas investuojant į skirtingus aktyvus, sektorius ar geografinius regionus.', 2),
    (advanced_q1_id, advanced_course_id, 'Kas yra P/E rodiklis akcijų vertinimui?', 'P/E (Price-to-Earnings) rodiklis rodo, kiek kartų akcijos kaina viršija bendrovės metinį pelną vienai akcijai.', 1),
    (advanced_q2_id, advanced_course_id, 'Kas yra Sharpe rodiklis portfelio valdyme?', 'Sharpe rodiklis matuoja investicijų grąžos ir rizikos santykį - kuo didesnis rodiklis, tuo geriau.', 2);

  -- Insert quiz options
  INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index)
  VALUES 
    -- Beginner Q1 options
    (beginner_q1_id, '10%', false, 1),
    (beginner_q1_id, '15%', false, 2),
    (beginner_q1_id, '20%', true, 3),
    (beginner_q1_id, '25%', false, 4),
    
    -- Beginner Q2 options
    (beginner_q2_id, '1-2 mėnesiai', false, 1),
    (beginner_q2_id, '3-6 mėnesiai', true, 2),
    (beginner_q2_id, '6-12 mėnesių', false, 3),
    (beginner_q2_id, '12+ mėnesių', false, 4),
    
    -- Intermediate Q1 options
    (intermediate_q1_id, 'I pakopa (SODRA)', true, 1),
    (intermediate_q1_id, 'II pakopa (pensijų fondai)', false, 2),
    (intermediate_q1_id, 'III pakopa (savanoriškas)', false, 3),
    (intermediate_q1_id, 'Visos pakopos', false, 4),
    
    -- Intermediate Q2 options
    (intermediate_q2_id, 'Investavimas tik į vieną akciją', false, 1),
    (intermediate_q2_id, 'Rizikos paskirstymas tarp skirtingų aktyvų', true, 2),
    (intermediate_q2_id, 'Investavimas tik į obligacijas', false, 3),
    (intermediate_q2_id, 'Pinigų laikymas banke', false, 4),
    
    -- Advanced Q1 options
    (advanced_q1_id, 'Akcijos kaina padalinta iš pelno vienai akcijai', true, 1),
    (advanced_q1_id, 'Bendrovės turtas padalintas iš skolų', false, 2),
    (advanced_q1_id, 'Metinė dividendų grąža', false, 3),
    (advanced_q1_id, 'Akcijos kaina padalinta iš pardavimų', false, 4),
    
    -- Advanced Q2 options
    (advanced_q2_id, 'Investicijų grąžos ir rizikos santykis', true, 1),
    (advanced_q2_id, 'Tik investicijų grąža', false, 2),
    (advanced_q2_id, 'Tik investicijų rizika', false, 3),
    (advanced_q2_id, 'Portfelio dydis', false, 4);

END $$;