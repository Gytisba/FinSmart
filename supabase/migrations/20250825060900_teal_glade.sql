/*
  # Complete Course Data Population

  1. New Tables
    - Populates `courses` table with 3 courses (beginner, intermediate, advanced)
    - Populates `course_modules` table with modules for each course
    - Populates `course_lessons` table with detailed lesson content
    - Populates `course_quiz_questions` and `course_quiz_options` with quiz data

  2. Security
    - All tables already have RLS enabled
    - Uses dummy user ID to avoid foreign key issues

  3. Content
    - Complete Lithuanian financial education content
    - Real-world examples and practical advice
    - Progressive difficulty levels
*/

-- Insert courses
INSERT INTO courses (id, slug, title, level, summary, cover_url, status, created_by, published_at) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai lietuviams', 'https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg', 'published', '550e8400-e29b-41d4-a716-446655440000', now()),
('550e8400-e29b-41d4-a716-446655440002', 'vidutinis-lygis', 'Vidutinis lygis', 'intermediate', 'Investavimas ir finansų planavimas', 'https://images.pexels.com/photos/590022/pexels-photo-590022.jpeg', 'published', '550e8400-e29b-41d4-a716-446655440000', now()),
('550e8400-e29b-41d4-a716-446655440003', 'pazengusiuju-lygis', 'Pažengusiųjų lygis', 'advanced', 'Pažangūs investavimo metodai', 'https://images.pexels.com/photos/187041/pexels-photo-187041.jpeg', 'published', '550e8400-e29b-41d4-a716-446655440000', now())
ON CONFLICT (slug) DO NOTHING;

-- Insert course modules
INSERT INTO course_modules (id, course_id, title, description, order_index, duration_minutes) VALUES
-- Beginner course modules
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', 'Pinigų pagrindai', 'Kas yra pinigai ir kaip jie veikia ekonomikoje', 1, 45),
('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440001', 'Biudžeto sudarymas', 'Kaip sudaryti ir valdyti asmeninį biudžetą', 2, 60),
('550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440001', 'Taupymo strategijos', 'Efektyvūs taupymo būdai ir metodai', 3, 50),

-- Intermediate course modules
('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440002', 'Pensijų sistema', 'Lietuvos pensijų sistemos pagrindai', 1, 55),
('550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440002', 'Investavimo pradžiamokslis', 'Pagrindiniai investavimo principai', 2, 65),
('550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440002', 'Draudimas', 'Draudimo rūšys ir jų svarba', 3, 40),

-- Advanced course modules
('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440003', 'Akcijų rinkos', 'Akcijų rinkų analizė ir strategijos', 1, 70),
('550e8400-e29b-41d4-a716-446655440032', '550e8400-e29b-41d4-a716-446655440003', 'ETF fondai', 'Exchange-traded fondų investavimas', 2, 60),
('550e8400-e29b-41d4-a716-446655440033', '550e8400-e29b-41d4-a716-446655440003', 'Rizikos valdymas', 'Investicinės rizikos valdymo metodai', 3, 55)
ON CONFLICT (id) DO NOTHING;

-- Insert course lessons
INSERT INTO course_lessons (id, module_id, title, content, order_index, duration_minutes) VALUES
-- Beginner lessons
('550e8400-e29b-41d4-a716-446655440111', '550e8400-e29b-41d4-a716-446655440011', 'Kas yra pinigai?', 
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

('550e8400-e29b-41d4-a716-446655440112', '550e8400-e29b-41d4-a716-446655440011', 'Infliacija ir perkamoji galia', 
'<h3>Kas yra infliacija?</h3>
<p>Infliacija - tai kainų lygio augimas ekonomikoje. Dėl infliacijos pinigų perkamoji galia mažėja.</p>
<h4>Infliacijos poveikis:</h4>
<ul>
<li>Prekės ir paslaugos brangsta</li>
<li>Pinigų vertė mažėja</li>
<li>Taupymai neša nuostolius, jei palūkanos mažesnės už infliaciją</li>
</ul>
<p><strong>Pavyzdys:</strong> Jei infliacija 3% per metus, tai kas šiandien kainuoja 100€, po metų kainuos 103€.</p>
<h4>Kaip apsisaugoti nuo infliacijos:</h4>
<ul>
<li>Investuoti į aktyvus, kurie auga greičiau nei infliacija</li>
<li>Naudoti indėlius su kintamomis palūkanomis</li>
<li>Investuoti į nekilnojamąjį turtą</li>
</ul>', 2, 20),

('550e8400-e29b-41d4-a716-446655440121', '550e8400-e29b-41d4-a716-446655440012', 'Pajamų ir išlaidų analizė', 
'<h3>Biudžeto sudarymo pagrindai</h3>
<p>Biudžetas - tai jūsų pajamų ir išlaidų planas. Tai finansinio sėkmingumo pagrindas.</p>
<h4>Pajamų rūšys:</h4>
<ul>
<li><strong>Pagrindinės pajamos</strong> - atlyginimas, pensija</li>
<li><strong>Papildomos pajamos</strong> - dividendai, nuoma, verslas</li>
<li><strong>Vienkartinės pajamos</strong> - premijos, dovanos</li>
</ul>
<h4>Išlaidų kategorijos:</h4>
<ul>
<li><strong>Būtinos išlaidos</strong> - maistas, būstas, transportas (50-60%)</li>
<li><strong>Pramogos</strong> - restoranai, kelionės, hobiai (20-30%)</li>
<li><strong>Taupymas</strong> - ateities tikslams (20%)</li>
</ul>
<p><strong>50/30/20 taisyklė:</strong> 50% būtinoms išlaidoms, 30% pramogoms, 20% taupymui.</p>', 1, 25),

-- Intermediate lessons
('550e8400-e29b-41d4-a716-446655440211', '550e8400-e29b-41d4-a716-446655440021', 'Lietuvos pensijų sistemos pakopos', 
'<h3>Lietuvos pensijų sistema</h3>
<p>Lietuvoje veikia 3 pakopų pensijų sistema, skirta užtikrinti pajamas senatvėje.</p>
<h4>I pakopa - Valstybinio socialinio draudimo pensija:</h4>
<ul>
<li>Privaloma visiems dirbantiems</li>
<li>Finansuojama iš SODRA įmokų (6,98% nuo atlyginimo)</li>
<li>Priklauso nuo stažo ir įmokų dydžio</li>
</ul>
<h4>II pakopa - Pensijų kaupimas:</h4>
<ul>
<li>Savanoriškas (galima išstoti)</li>
<li>2% nuo atlyginimo + 2% valstybės</li>
<li>Pinigai investuojami į pensijų fondus</li>
</ul>
<h4>III pakopa - Papildomas pensijų kaupimas:</h4>
<ul>
<li>Visiškai savanoriškas</li>
<li>Mokestinės lengvatos iki 2000€ per metus</li>
<li>Galima rinktis investavimo strategijas</li>
</ul>', 1, 30),

-- Advanced lessons
('550e8400-e29b-41d4-a716-446655440311', '550e8400-e29b-41d4-a716-446655440031', 'Akcijų vertinimas', 
'<h3>Akcijų fundamentalioji analizė</h3>
<p>Akcijų vertinimas padeda nustatyti, ar akcija yra per brangi, per pigi, ar teisingai įkainota.</p>
<h4>Pagrindiniai rodikliai:</h4>
<ul>
<li><strong>P/E (Price/Earnings)</strong> - kaina/pelnas santykis</li>
<li><strong>P/B (Price/Book)</strong> - kaina/knygos vertė</li>
<li><strong>ROE (Return on Equity)</strong> - nuosavo kapitalo grąža</li>
<li><strong>Dividend Yield</strong> - dividendų pajamingumas</li>
</ul>
<h4>Finansinių ataskaitų analizė:</h4>
<ul>
<li>Pelno (nuostolių) ataskaita</li>
<li>Balanso ataskaita</li>
<li>Pinigų srautų ataskaita</li>
</ul>
<p><strong>Pavyzdys:</strong> Jei bendrovės P/E = 15, tai reiškia, kad investuotojai moka 15€ už kiekvieną 1€ metinio pelno.</p>', 1, 35)
ON CONFLICT (id) DO NOTHING;

-- Insert quiz questions
INSERT INTO course_quiz_questions (id, course_id, question, explanation, order_index) VALUES
-- Beginner quiz
('550e8400-e29b-41d4-a716-446655440411', '550e8400-e29b-41d4-a716-446655440001', 'Kuri pinigų funkcija leidžia mums palyginti skirtingų prekių vertes?', 'Vertės mato funkcija leidžia išreikšti visų prekių ir paslaugų vertes vienodais vienetais - pinigais.', 1),
('550e8400-e29b-41d4-a716-446655440412', '550e8400-e29b-41d4-a716-446655440001', 'Kokia yra rekomenduojama taupymo dalis nuo pajamų?', '20% taisyklė yra plačiai pripažįstama kaip sveika taupymo norma, kuri leidžia kaupti ateičiai nepažeidžiant gyvenimo kokybės.', 2),

-- Intermediate quiz
('550e8400-e29b-41d4-a716-446655440421', '550e8400-e29b-41d4-a716-446655440002', 'Kiek procentų nuo atlyginimo sudaro II pakopos pensijų kaupimo įmokos?', 'II pakopoje darbuotojas moka 2% nuo atlyginimo, o valstybė prideda dar 2%, iš viso 4%.', 1),
('550e8400-e29b-41d4-a716-446655440422', '550e8400-e29b-41d4-a716-446655440002', 'Kas yra diversifikacija?', 'Diversifikacija - tai rizikos paskirstymas tarp skirtingų investicijų, sektorių ar geografinių regionų.', 2),

-- Advanced quiz
('550e8400-e29b-41d4-a716-446655440431', '550e8400-e29b-41d4-a716-446655440003', 'Ką rodo P/E rodiklis?', 'P/E rodiklis parodo, kiek kartų akcijos kaina viršija bendrovės metinį pelną vienai akcijai.', 1),
('550e8400-e29b-41d4-a716-446655440432', '550e8400-e29b-41d4-a716-446655440003', 'Kas yra ETF?', 'ETF (Exchange-Traded Fund) yra investicinis fondas, kuris prekiaujamas biržoje kaip paprastos akcijos.', 2)
ON CONFLICT (id) DO NOTHING;

-- Insert quiz options
INSERT INTO course_quiz_options (id, question_id, option_text, is_correct, order_index) VALUES
-- Question 1 options
('550e8400-e29b-41d4-a716-446655440511', '550e8400-e29b-41d4-a716-446655440411', 'Mainų priemonė', false, 1),
('550e8400-e29b-41d4-a716-446655440512', '550e8400-e29b-41d4-a716-446655440411', 'Vertės matas', true, 2),
('550e8400-e29b-41d4-a716-446655440513', '550e8400-e29b-41d4-a716-446655440411', 'Vertės kaupimo priemonė', false, 3),
('550e8400-e29b-41d4-a716-446655440514', '550e8400-e29b-41d4-a716-446655440411', 'Mokėjimo priemonė', false, 4),

-- Question 2 options
('550e8400-e29b-41d4-a716-446655440521', '550e8400-e29b-41d4-a716-446655440412', '10%', false, 1),
('550e8400-e29b-41d4-a716-446655440522', '550e8400-e29b-41d4-a716-446655440412', '15%', false, 2),
('550e8400-e29b-41d4-a716-446655440523', '550e8400-e29b-41d4-a716-446655440412', '20%', true, 3),
('550e8400-e29b-41d4-a716-446655440524', '550e8400-e29b-41d4-a716-446655440412', '25%', false, 4),

-- Question 3 options
('550e8400-e29b-41d4-a716-446655440531', '550e8400-e29b-41d4-a716-446655440421', '2%', false, 1),
('550e8400-e29b-41d4-a716-446655440532', '550e8400-e29b-41d4-a716-446655440421', '3%', false, 2),
('550e8400-e29b-41d4-a716-446655440533', '550e8400-e29b-41d4-a716-446655440421', '4%', true, 3),
('550e8400-e29b-41d4-a716-446655440534', '550e8400-e29b-41d4-a716-446655440421', '5%', false, 4),

-- Question 4 options
('550e8400-e29b-41d4-a716-446655440541', '550e8400-e29b-41d4-a716-446655440422', 'Investavimas tik į vieną sektorių', false, 1),
('550e8400-e29b-41d4-a716-446655440542', '550e8400-e29b-41d4-a716-446655440422', 'Rizikos paskirstymas tarp skirtingų investicijų', true, 2),
('550e8400-e29b-41d4-a716-446655440543', '550e8400-e29b-41d4-a716-446655440422', 'Investavimas tik į akcijas', false, 3),
('550e8400-e29b-41d4-a716-446655440544', '550e8400-e29b-41d4-a716-446655440422', 'Pinigų taupymas banke', false, 4),

-- Question 5 options
('550e8400-e29b-41d4-a716-446655440551', '550e8400-e29b-41d4-a716-446655440431', 'Akcijos kainą', false, 1),
('550e8400-e29b-41d4-a716-446655440552', '550e8400-e29b-41d4-a716-446655440431', 'Kiek kartų kaina viršija pelną', true, 2),
('550e8400-e29b-41d4-a716-446655440553', '550e8400-e29b-41d4-a716-446655440431', 'Bendrovės dydį', false, 3),
('550e8400-e29b-41d4-a716-446655440554', '550e8400-e29b-41d4-a716-446655440431', 'Dividendų dydį', false, 4),

-- Question 6 options
('550e8400-e29b-41d4-a716-446655440561', '550e8400-e29b-41d4-a716-446655440432', 'Banko indėlis', false, 1),
('550e8400-e29b-41d4-a716-446655440562', '550e8400-e29b-41d4-a716-446655440432', 'Investicinis fondas, prekiaujamas biržoje', true, 2),
('550e8400-e29b-41d4-a716-446655440563', '550e8400-e29b-41d4-a716-446655440432', 'Pensijų fondas', false, 3),
('550e8400-e29b-41d4-a716-446655440564', '550e8400-e29b-41d4-a716-446655440432', 'Draudimo polisas', false, 4)
ON CONFLICT (id) DO NOTHING;