/*
  # Populate Courses Data

  1. Sample Data
    - Creates 3 courses (beginner, intermediate, advanced)
    - Adds modules and lessons for each course
    - Includes quiz questions and options
    - All content in Lithuanian for financial education

  2. Security
    - Uses dummy user ID to avoid dependency on users table
    - Maintains proper foreign key relationships
*/

DO $$
DECLARE
    dummy_user_id uuid := '00000000-0000-0000-0000-000000000000';
    beginner_course_id uuid;
    intermediate_course_id uuid;
    advanced_course_id uuid;
    module_id uuid;
    lesson_id uuid;
    question_id uuid;
BEGIN
    -- Insert courses
    INSERT INTO courses (id, slug, title, level, summary, status, created_by, published_at)
    VALUES 
        (gen_random_uuid(), 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'published', dummy_user_id, now()),
        (gen_random_uuid(), 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'published', dummy_user_id, now()),
        (gen_random_uuid(), 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'published', dummy_user_id, now())
    ON CONFLICT (slug) DO NOTHING;

    -- Get course IDs
    SELECT id INTO beginner_course_id FROM courses WHERE slug = 'pradedanciuju-lygis';
    SELECT id INTO intermediate_course_id FROM courses WHERE slug = 'vidutinis-lygis';
    SELECT id INTO advanced_course_id FROM courses WHERE slug = 'pazengusiuju-lygis';

    -- Insert modules for beginner course
    INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes)
    VALUES (gen_random_uuid(), beginner_course_id, 'Finansų pagrindai', 'Sužinokite apie pinigų prigimtį ir finansų svarbą', 1, 45)
    ON CONFLICT DO NOTHING;

    SELECT id INTO module_id FROM course_modules WHERE course_id = beginner_course_id AND order_index = 1;

    -- Insert lessons for beginner module
    INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes)
    VALUES 
        (gen_random_uuid(), module_id, 'Kas yra pinigai?', '<h3>Pinigų istorija ir funkcijos</h3><p>Pinigai yra mainų priemonė, kuri palengvina prekybą ir paslaugų teikimą. Lietuvoje naudojame eurus nuo 2015 metų.</p><h4>Pagrindinės pinigų funkcijos:</h4><ul><li>Mainų priemonė</li><li>Vertės matas</li><li>Vertės kaupimo priemonė</li></ul>', 1, 15),
        (gen_random_uuid(), module_id, 'Biudžeto sudarymas', '<h3>Kaip sudaryti asmeninį biudžetą</h3><p>Biudžetas - tai jūsų pajamų ir išlaidų planas. Svarbu žinoti, kiek uždirbate ir kiek išleidžiate.</p><h4>Biudžeto sudarymo žingsniai:</h4><ol><li>Suskaičiuokite visas pajamas</li><li>Išvardykite visas išlaidas</li><li>Palyginkite pajamas su išlaidomis</li><li>Planuokite taupymą</li></ol>', 2, 20),
        (gen_random_uuid(), module_id, 'Taupymo principai', '<h3>Kodėl svarbu taupyti?</h3><p>Taupymas padeda pasirengti nenumatytiems atvejams ir pasiekti finansinius tikslus.</p><h4>Taupymo taisyklės:</h4><ul><li>Taupykite bent 10% pajamų</li><li>Sukurkite avarinį fondą</li><li>Nustatykite aiškius tikslus</li></ul>', 3, 10)
    ON CONFLICT DO NOTHING;

    -- Insert quiz questions for beginner course
    INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index)
    VALUES 
        (gen_random_uuid(), beginner_course_id, 'Kiek procentų pajamų rekomenduojama taupyti?', 'Finansų ekspertai rekomenduoja taupyti bent 10-20% pajamų.', 1),
        (gen_random_uuid(), beginner_course_id, 'Kas yra biudžetas?', 'Biudžetas yra pajamų ir išlaidų planas tam tikram laikotarpiui.', 2)
    ON CONFLICT DO NOTHING;

    -- Get question IDs and insert options
    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 1;
    INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index)
    VALUES 
        (gen_random_uuid(), question_id, '5%', false, 1),
        (gen_random_uuid(), question_id, '10-20%', true, 2),
        (gen_random_uuid(), question_id, '50%', false, 3),
        (gen_random_uuid(), question_id, 'Nereikia taupyti', false, 4)
    ON CONFLICT DO NOTHING;

    SELECT id INTO question_id FROM course_quiz_questions WHERE course_id = beginner_course_id AND order_index = 2;
    INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index)
    VALUES 
        (gen_random_uuid(), question_id, 'Pajamų ir išlaidų planas', true, 1),
        (gen_random_uuid(), question_id, 'Banko sąskaita', false, 2),
        (gen_random_uuid(), question_id, 'Mokesčių deklaracija', false, 3),
        (gen_random_uuid(), question_id, 'Investicijų portfelis', false, 4)
    ON CONFLICT DO NOTHING;

    -- Insert modules for intermediate course
    INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes)
    VALUES (gen_random_uuid(), intermediate_course_id, 'Investavimo pagrindai', 'Sužinokite apie investavimo galimybes Lietuvoje', 1, 60)
    ON CONFLICT DO NOTHING;

    SELECT id INTO module_id FROM course_modules WHERE course_id = intermediate_course_id AND order_index = 1;

    -- Insert lessons for intermediate module
    INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes)
    VALUES 
        (gen_random_uuid(), module_id, 'Pensijų sistema Lietuvoje', '<h3>Lietuvos pensijų sistemos pakopos</h3><p>Lietuvoje veikia 3 pakopų pensijų sistema:</p><h4>I pakopa - valstybinės pensijos</h4><p>Privalomas socialinis draudimas, administruojamas SODROS.</p><h4>II pakopa - pensijų fondai</h4><p>Savanoriškas kaupimas pensijų fonduose.</p><h4>III pakopa - papildomas kaupimas</h4><p>Individualus pensijų kaupimas.</p>', 1, 20),
        (gen_random_uuid(), module_id, 'Sudėtinės palūkanos', '<h3>Sudėtinių palūkanų galia</h3><p>Sudėtinės palūkanos - tai palūkanos, skaičiuojamos ne tik nuo pradinės sumos, bet ir nuo anksčiau sukauptų palūkanų.</p><h4>Pavyzdys:</h4><p>Investavus 1000€ su 7% metinėmis palūkanomis:</p><ul><li>Po 10 metų: 1967€</li><li>Po 20 metų: 3870€</li><li>Po 30 metų: 7612€</li></ul>', 2, 25),
        (gen_random_uuid(), module_id, 'Investavimo rizikos', '<h3>Rizikos ir pelningumo ryšys</h3><p>Didesnė rizika paprastai reiškia didesnį potencialų pelną, bet ir didesnius galimus nuostolius.</p><h4>Rizikos lygiai:</h4><ul><li>Žema rizika: indėliai, obligacijos</li><li>Vidutinė rizika: mišrūs fondai</li><li>Aukšta rizika: akcijos, kriptovaliutos</li></ul>', 3, 15)
    ON CONFLICT DO NOTHING;

    -- Insert quiz questions for intermediate course
    INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index)
    VALUES 
        (gen_random_uuid(), intermediate_course_id, 'Kiek pakopų turi Lietuvos pensijų sistema?', 'Lietuvos pensijų sistema turi 3 pakopos: valstybinės pensijos, pensijų fondai ir papildomas kaupimas.', 1),
        (gen_random_uuid(), intermediate_course_id, 'Kas yra sudėtinės palūkanos?', 'Sudėtinės palūkanos skaičiuojamos nuo pradinės sumos ir anksčiau sukauptų palūkanų.', 2)
    ON CONFLICT DO NOTHING;

    -- Insert modules for advanced course
    INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes)
    VALUES (gen_random_uuid(), advanced_course_id, 'Pažangūs investavimo metodai', 'Gilintis į akcijų rinkas ir portfelio valdymą', 1, 90)
    ON CONFLICT DO NOTHING;

    SELECT id INTO module_id FROM course_modules WHERE course_id = advanced_course_id AND order_index = 1;

    -- Insert lessons for advanced module
    INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes)
    VALUES 
        (gen_random_uuid(), module_id, 'Akcijų rinkos analizė', '<h3>Fundamentalioji ir techninė analizė</h3><p>Akcijų vertinimui naudojami du pagrindiniai metodai:</p><h4>Fundamentalioji analizė</h4><p>Bendrovės finansinių rodiklių tyrimas: pajamos, pelnas, skolos.</p><h4>Techninė analizė</h4><p>Kainų grafikai ir trendai, prekybos apimtys.</p><h4>Svarbūs rodikliai:</h4><ul><li>P/E santykis</li><li>ROE (Return on Equity)</li><li>Debt-to-Equity</li></ul>', 1, 30),
        (gen_random_uuid(), module_id, 'ETF fondai', '<h3>Exchange-Traded Funds</h3><p>ETF - tai investiciniai fondai, prekiaujami biržoje kaip akcijos.</p><h4>ETF privalumai:</h4><ul><li>Diversifikacija</li><li>Žemi mokesčiai</li><li>Likvidumas</li><li>Skaidrumas</li></ul><h4>Populiarūs ETF:</h4><ul><li>S&P 500 ETF</li><li>MSCI World ETF</li><li>Emerging Markets ETF</li></ul>', 2, 25),
        (gen_random_uuid(), module_id, 'Portfelio valdymas', '<h3>Diversifikuoto portfelio kūrimas</h3><p>Sėkmingas investavimas reikalauja tinkamo turto paskirstymo.</p><h4>Portfelio struktūra pagal amžių:</h4><ul><li>20-30 metų: 80% akcijos, 20% obligacijos</li><li>40-50 metų: 60% akcijos, 40% obligacijos</li><li>60+ metų: 40% akcijos, 60% obligacijos</li></ul>', 3, 35)
    ON CONFLICT DO NOTHING;

    -- Insert quiz questions for advanced course
    INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index)
    VALUES 
        (gen_random_uuid(), advanced_course_id, 'Kas yra ETF?', 'ETF (Exchange-Traded Fund) yra investicinis fondas, prekiaujamas biržoje kaip akcijos.', 1),
        (gen_random_uuid(), advanced_course_id, 'Koks turėtų būti akcijų procentas 30 metų amžiaus žmogaus portfelyje?', 'Jauniems investuotojams rekomenduojama turėti apie 80% akcijų portfelyje.', 2)
    ON CONFLICT DO NOTHING;

END $$;