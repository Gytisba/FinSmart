/*
  # Add sample data for beginner course

  1. New Data
    - `courses` table: Pradedančiųjų lygis course
    - `course_modules` table: 5 modules for beginner course
    - `course_lessons` table: Multiple lessons for each module
    - `course_quiz_questions` table: Quiz questions for the course
    - `course_quiz_options` table: Answer options for each question

  2. Course Structure
    - Module 1: Kas yra pinigai ir kaip jie veikia?
    - Module 2: Biudžeto sudarymas - jūsų finansų pagrindas
    - Module 3: Taupymas vs išlaidavimas - tinkamas balansas
    - Module 4: Banko sąskaitos ir paslaugos
    - Module 5: Mokesčiai Lietuvoje

  3. Features
    - Complete course with modules, lessons, and quiz
    - Rich HTML content for lessons
    - Multiple choice quiz questions with explanations
*/

-- Insert the beginner course
INSERT INTO courses (slug, title, level, summary, status, created_by) VALUES 
('pradedanciuju-lygis', 'Pradedančiųjų lygis', 'beginner', 'Asmeninių finansų pagrindai - mokykitės valdyti pinigus, sudaryti biudžetą ir taupyti ateičiai', 'published', (SELECT id FROM auth.users LIMIT 1));

-- Get the course ID for reference
DO $$
DECLARE
    course_uuid UUID;
    module1_uuid UUID;
    module2_uuid UUID;
    module3_uuid UUID;
    module4_uuid UUID;
    module5_uuid UUID;
    question1_uuid UUID;
    question2_uuid UUID;
    question3_uuid UUID;
    question4_uuid UUID;
    question5_uuid UUID;
BEGIN
    -- Get the course ID
    SELECT id INTO course_uuid FROM courses WHERE slug = 'pradedanciuju-lygis';
    
    -- Insert course modules
    INSERT INTO course_modules (course_id, title, description, order_index, duration_minutes) VALUES 
    (course_uuid, 'Kas yra pinigai ir kaip jie veikia?', 'Sužinokite apie pinigų kilmę, funkcijas ir šiuolaikinę finansų sistemą', 1, 45),
    (course_uuid, 'Biudžeto sudarymas - jūsų finansų pagrindas', 'Mokykitės sudaryti ir valdyti asmeninį biudžetą', 2, 60),
    (course_uuid, 'Taupymas vs išlaidavimas - tinkamas balansas', 'Raskite pusiausvyrą tarp dabartinių poreikių ir ateities tikslų', 3, 50),
    (course_uuid, 'Banko sąskaitos ir paslaugos', 'Išmokite naudotis banko paslaugomis efektyviai', 4, 40),
    (course_uuid, 'Mokesčiai Lietuvoje', 'Suprasite mokesčių sistemą ir kaip ją naudoti savo naudai', 5, 55)
    RETURNING id INTO module1_uuid, module2_uuid, module3_uuid, module4_uuid, module5_uuid;
    
    -- Get module IDs
    SELECT id INTO module1_uuid FROM course_modules WHERE course_id = course_uuid AND order_index = 1;
    SELECT id INTO module2_uuid FROM course_modules WHERE course_id = course_uuid AND order_index = 2;
    SELECT id INTO module3_uuid FROM course_modules WHERE course_id = course_uuid AND order_index = 3;
    SELECT id INTO module4_uuid FROM course_modules WHERE course_id = course_uuid AND order_index = 4;
    SELECT id INTO module5_uuid FROM course_modules WHERE course_id = course_uuid AND order_index = 5;
    
    -- Insert lessons for Module 1: Kas yra pinigai ir kaip jie veikia?
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES 
    (module1_uuid, 'Pinigų istorija ir kilmė', 
    '<h3>Pinigų kilmė</h3>
    <p>Pinigai atsirado dėl prekybos poreikių. Senovėje žmonės naudojo <strong>barterį</strong> - tiesiogiai keisdavo prekes.</p>
    
    <h4>Pagrindinės pinigų funkcijos:</h4>
    <ul>
        <li><strong>Mainų priemonė</strong> - leidžia lengvai keistis prekėmis ir paslaugomis</li>
        <li><strong>Vertės matas</strong> - padeda palyginti skirtingų prekių kainas</li>
        <li><strong>Vertės kaupimo priemonė</strong> - galima taupyti ateičiai</li>
        <li><strong>Mokėjimo priemonė</strong> - galima atsiskaityti už skolas</li>
    </ul>
    
    <h4>Pinigų evoliucija:</h4>
    <p>Nuo aukso ir sidabro monetų iki šiuolaikinių elektroninių pinigų - pinigai nuolat keičiasi kartu su technologijomis.</p>', 
    1, 15),
    
    (module1_uuid, 'Šiuolaikinė finansų sistema', 
    '<h3>Kaip veikia šiuolaikiniai pinigai?</h3>
    <p>Šiandien dauguma pinigų egzistuoja <strong>skaitmenine forma</strong> - tai skaičiai banko kompiuteriuose.</p>
    
    <h4>Pagrindiniai dalyviai:</h4>
    <ul>
        <li><strong>Lietuvos bankas</strong> - centrinis bankas, kontroliuoja pinigų kiekį</li>
        <li><strong>Komerciniai bankai</strong> - teikia paslaugas gyventojams</li>
        <li><strong>Mokėjimo sistemos</strong> - leidžia perduoti pinigus</li>
    </ul>
    
    <h4>Euro zona:</h4>
    <p>Lietuva naudoja <strong>eurą</strong> nuo 2015 metų. Europos centrinis bankas (ECB) kontroliuoja euro politiką.</p>', 
    2, 15),
    
    (module1_uuid, 'Infliacija ir perkamoji galia', 
    '<h3>Kas yra infliacija?</h3>
    <p><strong>Infliacija</strong> - tai kainų lygio augimas ekonomikoje. Dėl infliacijos pinigų perkamoji galia mažėja.</p>
    
    <h4>Infliacijos poveikis:</h4>
    <ul>
        <li>Kas šiandien kainuoja 100€, po metų gali kainuoti 103€ (3% infliacija)</li>
        <li>Taupymai banke be palūkanų realiai mažėja</li>
        <li>Skolos tampa "pigesnės" laiko bėgyje</li>
    </ul>
    
    <h4>Kaip apsisaugoti:</h4>
    <p>Investuokite į aktyvus, kurie auga greičiau nei infliacija - akcijas, nekilnojamąjį turtą ar indeksų fondus.</p>', 
    3, 15);
    
    -- Insert lessons for Module 2: Biudžeto sudarymas
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES 
    (module2_uuid, 'Pajamų ir išlaidų analizė', 
    '<h3>Pirmasis žingsnis - sužinokite, kur dingsta pinigai</h3>
    <p>Prieš sudarydami biudžetą, turite žinoti savo tikrąją finansinę situaciją.</p>
    
    <h4>Pajamų šaltiniai:</h4>
    <ul>
        <li><strong>Pagrindinės pajamos</strong> - atlyginimas, pensija</li>
        <li><strong>Papildomos pajamos</strong> - freelancing, nuoma, dividendai</li>
        <li><strong>Vienkartinės pajamos</strong> - premijos, dovanos</li>
    </ul>
    
    <h4>Išlaidų kategorijos:</h4>
    <ul>
        <li><strong>Būtinos išlaidos</strong> - būstas, maistas, transportas</li>
        <li><strong>Svarbios išlaidos</strong> - draudimas, sveikatos priežiūra</li>
        <li><strong>Pramogos</strong> - restoranai, kelionės, hobiai</li>
    </ul>', 
    1, 20),
    
    (module2_uuid, '50/30/20 taisyklė', 
    '<h3>Paprastas biudžeto sudarymo metodas</h3>
    <p><strong>50/30/20 taisyklė</strong> - tai populiarus būdas paskirstyti pajamas:</p>
    
    <h4>Paskirstymas:</h4>
    <ul>
        <li><strong>50% - būtinos išlaidos</strong> (būstas, maistas, transportas)</li>
        <li><strong>30% - pramogos ir norai</strong> (restoranai, kelionės, hobiai)</li>
        <li><strong>20% - taupymas ir investicijos</strong> (ateities fondas, pensija)</li>
    </ul>
    
    <h4>Pavyzdys su 1500€ pajamomis:</h4>
    <ul>
        <li>750€ - būtinos išlaidos</li>
        <li>450€ - pramogos</li>
        <li>300€ - taupymas</li>
    </ul>
    
    <p><strong>Patarimas:</strong> Jei negalite taupyti 20%, pradėkite nuo 10% ir palaipsniui didinkite.</p>', 
    2, 20),
    
    (module2_uuid, 'Biudžeto sekimas ir koregavimas', 
    '<h3>Kaip sekti ir koreguoti biudžetą</h3>
    <p>Biudžetas - tai ne vienkartinis veiksmas, o nuolatinis procesas.</p>
    
    <h4>Sekimo įrankiai:</h4>
    <ul>
        <li><strong>Mobilios aplikacijos</strong> - automatinis kategorijų atpažinimas</li>
        <li><strong>Excel lentelės</strong> - pilnas kontrolės lygis</li>
        <li><strong>Banko aplikacijos</strong> - išlaidų analizė</li>
    </ul>
    
    <h4>Mėnesio pabaigoje:</h4>
    <ol>
        <li>Palyginkite planuotas ir faktines išlaidas</li>
        <li>Identifikuokite problemas kategorijas</li>
        <li>Koreguokite kito mėnesio biudžetą</li>
        <li>Nustatykite realistiškus tikslus</li>
    </ol>
    
    <p><strong>Svarbu:</strong> Nepiktinkitės dėl klaidų - mokymasis trunka 3-6 mėnesius.</p>', 
    3, 20);
    
    -- Insert lessons for Module 3: Taupymas vs išlaidavimas
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES 
    (module3_uuid, 'Avarinės atsargos fondas', 
    '<h3>Pirmasis taupymo tikslas</h3>
    <p><strong>Avarinės atsargos fondas</strong> - tai pinigai nenumatytiems atvejams.</p>
    
    <h4>Kiek reikia taupyti:</h4>
    <ul>
        <li><strong>Minimalus tikslas:</strong> 3 mėnesių išlaidos</li>
        <li><strong>Optimalus tikslas:</strong> 6 mėnesių išlaidos</li>
        <li><strong>Maksimalus tikslas:</strong> 12 mėnesių išlaidos</li>
    </ul>
    
    <h4>Kada naudoti:</h4>
    <ul>
        <li>Darbo netekimas</li>
        <li>Netikėtos medicinos išlaidos</li>
        <li>Skubūs namų remonto darbai</li>
        <li>Automobilio gedimas</li>
    </ul>
    
    <h4>Kur laikyti:</h4>
    <p>Avarinės atsargos turi būti <strong>lengvai pasiekiamos</strong> - einamojoje sąskaitoje arba taupomojoje sąskaitoje.</p>', 
    1, 15),
    
    (module3_uuid, 'Trumpalaikiai ir ilgalaikiai tikslai', 
    '<h3>Tikslų nustatymas ir planavimas</h3>
    <p>Skirtingi tikslai reikalauja skirtingų taupymo strategijų.</p>
    
    <h4>Trumpalaikiai tikslai (iki 2 metų):</h4>
    <ul>
        <li>Atostogos - 2000€</li>
        <li>Naujas telefonas - 800€</li>
        <li>Automobilio įmoka - 5000€</li>
    </ul>
    <p><strong>Strategija:</strong> Taupomoji sąskaita arba trumpalaikiai indėliai</p>
    
    <h4>Vidutinės trukmės tikslai (2-10 metų):</h4>
    <ul>
        <li>Būsto įmoka - 30000€</li>
        <li>Vaikų švietimas - 15000€</li>
        <li>Verslo pradžia - 20000€</li>
    </ul>
    <p><strong>Strategija:</strong> Konservatyvūs investiciniai fondai</p>
    
    <h4>Ilgalaikiai tikslai (10+ metų):</h4>
    <ul>
        <li>Pensija</li>
        <li>Vaikų ateitis</li>
        <li>Finansinė nepriklausomybė</li>
    </ul>
    <p><strong>Strategija:</strong> Akcijų fondai, ETF, nekilnojamasis turtas</p>', 
    2, 20),
    
    (module3_uuid, 'Išlaidų optimizavimas', 
    '<h3>Kaip sumažinti išlaidas neprarandant gyvenimo kokybės</h3>
    <p>Išlaidų mažinimas - greičiausias būdas padidinti taupymus.</p>
    
    <h4>Didžiosios išlaidos:</h4>
    <ul>
        <li><strong>Būstas (30-40% pajamų)</strong> - apsvarstykit mažesnį būstą ar bendrabučius</li>
        <li><strong>Transportas (10-15%)</strong> - viešasis transportas vs automobilis</li>
        <li><strong>Maistas (10-15%)</strong> - namų maistas vs restoranai</li>
    </ul>
    
    <h4>Mažosios išlaidos, kurios kaupiasi:</h4>
    <ul>
        <li>Prenumeratos, kuriomis nenaudojatės</li>
        <li>Kasdienė kava kavinėje (100€/mėn)</li>
        <li>Impulsiniai pirkimai</li>
        <li>Brangiausios prekės be palyginimo</li>
    </ul>
    
    <h4>Praktiniai patarimai:</h4>
    <ol>
        <li>Palaukite 24 val. prieš pirkdami brangius daiktus</li>
        <li>Naudokite apsipirkimo sąrašus</li>
        <li>Lyginkite kainas skirtingose parduotuvėse</li>
        <li>Pirkite sezonines prekes ne sezono metu</li>
    </ol>', 
    3, 15);
    
    -- Insert lessons for Module 4: Banko sąskaitos ir paslaugos
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES 
    (module4_uuid, 'Sąskaitų tipai Lietuvoje', 
    '<h3>Pagrindiniai banko sąskaitų tipai</h3>
    <p>Skirtingos sąskaitos skirtingiems poreikiams.</p>
    
    <h4>Einamoji sąskaita:</h4>
    <ul>
        <li><strong>Paskirtis:</strong> Kasdieniai mokėjimai</li>
        <li><strong>Palūkanos:</strong> 0% arba labai mažos</li>
        <li><strong>Privalumai:</strong> Greitas pinigų prieinamumas</li>
        <li><strong>Mokesčiai:</strong> 0-5€/mėn (priklauso nuo banko)</li>
    </ul>
    
    <h4>Taupomoji sąskaita:</h4>
    <ul>
        <li><strong>Paskirtis:</strong> Trumpalaikis taupymas</li>
        <li><strong>Palūkanos:</strong> 0.1-2% metinės</li>
        <li><strong>Privalumai:</strong> Didesnes palūkanos nei einamojoje</li>
        <li><strong>Apribojimai:</strong> Riboti išėmimai per mėnesį</li>
    </ul>
    
    <h4>Terminuoti indėliai:</h4>
    <ul>
        <li><strong>Paskirtis:</strong> Fiksuotos trukmės taupymas</li>
        <li><strong>Palūkanos:</strong> 1-4% (priklauso nuo trukmės)</li>
        <li><strong>Privalumai:</strong> Garantuotos palūkanos</li>
        <li><strong>Trūkumai:</strong> Pinigai "užšaldyti" tam tikram laikui</li>
    </ul>', 
    1, 15),
    
    (module4_uuid, 'Mokėjimo kortelės ir jų naudojimas', 
    '<h3>Debeto vs kredito kortelės</h3>
    <p>Suprasite skirtumą ir išmoksite naudoti saugiai.</p>
    
    <h4>Debeto kortelė:</h4>
    <ul>
        <li><strong>Principas:</strong> Naudojate savo pinigus</li>
        <li><strong>Privalumai:</strong> Negalite išleisti daugiau nei turite</li>
        <li><strong>Mokesčiai:</strong> Paprastai nemokami arba maži</li>
        <li><strong>Saugumas:</strong> Mažesnė rizika skoloms</li>
    </ul>
    
    <h4>Kredito kortelė:</h4>
    <ul>
        <li><strong>Principas:</strong> Bankas skolina pinigus</li>
        <li><strong>Privalumai:</strong> Galite pirkti dabar, mokėti vėliau</li>
        <li><strong>Pavojai:</strong> Aukštos palūkanos (15-25% metinės)</li>
        <li><strong>Mokesčiai:</strong> Metinis mokestis, palūkanos už skolą</li>
    </ul>
    
    <h4>Saugus naudojimas:</h4>
    <ol>
        <li>Niekada neduokite PIN kodo kitiems</li>
        <li>Denkit klaviatūrą įvesdami PIN</li>
        <li>Reguliariai tikrinkite sąskaitos išrašus</li>
        <li>Praneškit bankui apie pamestu kortelę iš karto</li>
    </ol>', 
    2, 15),
    
    (module4_uuid, 'Internetinis bankininkystė ir saugumas', 
    '<h3>Saugus internetinio banko naudojimas</h3>
    <p>Internetinis bankas - patogus, bet reikia žinoti saugumo taisykles.</p>
    
    <h4>Saugumo principai:</h4>
    <ul>
        <li><strong>Stiprus slaptažodis:</strong> Bent 12 simbolių, skaičiai, raidės, simboliai</li>
        <li><strong>Dviejų veiksnių autentifikacija:</strong> SMS arba aplikacija</li>
        <li><strong>Oficialūs kanalai:</strong> Tik banko svetainė arba aplikacija</li>
        <li><strong>Saugus internetas:</strong> Naudokite tik saugius WiFi tinklus</li>
    </ul>
    
    <h4>Ką NIEKADA nedaryti:</h4>
    <ul>
        <li>Neatidaryti banko nuorodų el. pašte</li>
        <li>Neįvesti duomenų telefonu (bankai niekada neprašo)</li>
        <li>Nenaudoti viešo WiFi finansiniams veiksmams</li>
        <li>Nepalikti prisijungę viešame kompiuteryje</li>
    </ul>
    
    <h4>Jei įtariate sukčiavimą:</h4>
    <ol>
        <li>Iš karto pakeiskite slaptažodžius</li>
        <li>Paskambinkite į banką</li>
        <li>Užblokuokite korteles</li>
        <li>Praneškit policijai</li>
    </ol>', 
    3, 10);
    
    -- Insert lessons for Module 5: Mokesčiai Lietuvoje
    INSERT INTO course_lessons (module_id, title, content, order_index, duration_minutes) VALUES 
    (module5_uuid, 'GPM - Gyventojų pajamų mokestis', 
    '<h3>Pagrindinis mokestis nuo pajamų</h3>
    <p><strong>GPM</strong> - mokestis, kurį moka visi Lietuvos gyventojai nuo savo pajamų.</p>
    
    <h4>GPM tarifai 2024m:</h4>
    <ul>
        <li><strong>20%</strong> - standartinis tarifas</li>
        <li><strong>15%</strong> - mažesnėms pajamoms (iki tam tikros ribos)</li>
        <li><strong>32%</strong> - didesnėms pajamoms (virš 81,162€ per metus)</li>
    </ul>
    
    <h4>Neapmokestinamasis pajamų dydis (NPD):</h4>
    <p>2024m. NPD - <strong>540€ per mėnesį</strong>. Tai reiškia, kad nuo pirmųjų 540€ GPM nemokate.</p>
    
    <h4>Pavyzdys:</h4>
    <p>Jei uždirbate 1500€/mėn:</p>
    <ul>
        <li>Apmokestinamoji dalis: 1500€ - 540€ = 960€</li>
        <li>GPM: 960€ × 20% = 192€</li>
        <li>Į rankas: 1500€ - 192€ = 1308€</li>
    </ul>', 
    1, 20),
    
    (module5_uuid, 'Mokesčių lengvatos ir grąžinimai', 
    '<h3>Kaip sumažinti mokamus mokesčius</h3>
    <p>Lietuvoje galite gauti mokesčių lengvatų už tam tikras išlaidas.</p>
    
    <h4>Pagrindinės lengvatos:</h4>
    <ul>
        <li><strong>Gydymo išlaidos</strong> - iki 1,200€ per metus</li>
        <li><strong>Mokymosi išlaidos</strong> - iki 2,000€ per metus</li>
        <li><strong>Pensijų kaupimas</strong> - iki 2,000€ per metus</li>
        <li><strong>Draudimo įmokos</strong> - tam tikros ribos</li>
        <li><strong>Parama labdarai</strong> - iki 2% pajamų</li>
    </ul>
    
    <h4>Kaip gauti grąžinimą:</h4>
    <ol>
        <li>Rinkite visus kvitus ir sąskaitas</li>
        <li>Užpildykite deklaraciją VMI sistemoje</li>
        <li>Pateikite iki gegužės 31d.</li>
        <li>Grąžinimas - per 3 mėnesius</li>
    </ol>
    
    <h4>Pavyzdys:</h4>
    <p>Jei išleidote 1000€ gydymui:</p>
    <ul>
        <li>Mokesčių lengvata: 1000€ × 20% = 200€</li>
        <li>Tiek pinigų grąžins VMI</li>
    </ul>', 
    2, 20),
    
    (module5_uuid, 'Individualios veiklos mokesčiai', 
    '<h3>Jei dirbate sau arba turite papildomų pajamų</h3>
    <p>Individualios veiklos pažymėjimas (IVP) - būdas legaliai užsidirbti papildomai.</p>
    
    <h4>IVP privalumai:</h4>
    <ul>
        <li>Galite dirbti sau</li>
        <li>Papildomos pajamos prie pagrindinio darbo</li>
        <li>Lankstus darbo grafikas</li>
        <li>Galite atskaityti verslo išlaidas</li>
    </ul>
    
    <h4>Mokesčiai su IVP:</h4>
    <ul>
        <li><strong>GPM:</strong> 15% (iki 45,000€/metų)</li>
        <li><strong>VSD įmokos:</strong> 12.52% (pensijoms ir draudimui)</li>
        <li><strong>PVM:</strong> 21% (jei apyvarta > 45,000€)</li>
    </ul>
    
    <h4>Kada apsimoka:</h4>
    <p>IVP apsimoka, jei per metus uždirbsite daugiau nei 500-1000€ papildomai.</p>
    
    <h4>Verslo išlaidų atskaitymas:</h4>
    <ul>
        <li>Biuro nuoma</li>
        <li>Kompiuterio pirkimas</li>
        <li>Interneto mokestis</li>
        <li>Transporto išlaidos</li>
        <li>Mokymai ir kursai</li>
    </ul>', 
    3, 15);
    
    -- Insert quiz questions for the beginner course
    INSERT INTO course_quiz_questions (course_id, question, explanation, order_index) VALUES 
    (course_uuid, 'Kokios yra pagrindinės pinigų funkcijos?', 'Pinigai atlieka keturias pagrindines funkcijas: mainų priemonė, vertės matas, vertės kaupimo priemonė ir mokėjimo priemonė.', 1),
    (course_uuid, 'Kas yra 50/30/20 taisyklė biudžeto sudaryme?', '50/30/20 taisyklė rekomenduoja skirti 50% pajamų būtinoms išlaidoms, 30% pramogoms ir 20% taupymui.', 2),
    (course_uuid, 'Kiek mėnesių išlaidų turėtų sudaryti avarinės atsargos fondas?', 'Optimalus avarinės atsargos fondo dydis yra 6 mėnesių išlaidos, minimum - 3 mėnesiai.', 3),
    (course_uuid, 'Koks yra standartinis GPM tarifas Lietuvoje 2024m?', 'Standartinis GPM tarifas Lietuvoje 2024m. yra 20% nuo apmokestinamųjų pajamų.', 4),
    (course_uuid, 'Kuo skiriasi debeto ir kredito kortelės?', 'Debeto kortelė naudoja jūsų pinigus iš sąskaitos, o kredito kortelė - banko skolintus pinigus, už kuriuos reikia mokėti palūkanas.', 5);
    
    -- Get question IDs for options
    SELECT id INTO question1_uuid FROM course_quiz_questions WHERE course_id = course_uuid AND order_index = 1;
    SELECT id INTO question2_uuid FROM course_quiz_questions WHERE course_id = course_uuid AND order_index = 2;
    SELECT id INTO question3_uuid FROM course_quiz_questions WHERE course_id = course_uuid AND order_index = 3;
    SELECT id INTO question4_uuid FROM course_quiz_questions WHERE course_id = course_uuid AND order_index = 4;
    SELECT id INTO question5_uuid FROM course_quiz_questions WHERE course_id = course_uuid AND order_index = 5;
    
    -- Insert quiz options for question 1
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES 
    (question1_uuid, 'Tik mainų priemonė', false, 1),
    (question1_uuid, 'Mainų priemonė, vertės matas, vertės kaupimo priemonė, mokėjimo priemonė', true, 2),
    (question1_uuid, 'Tik vertės kaupimo priemonė', false, 3),
    (question1_uuid, 'Tik mokėjimo priemonė', false, 4);
    
    -- Insert quiz options for question 2
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES 
    (question2_uuid, '60% būtinoms išlaidoms, 20% pramogoms, 20% taupymui', false, 1),
    (question2_uuid, '50% būtinoms išlaidoms, 30% pramogoms, 20% taupymui', true, 2),
    (question2_uuid, '40% būtinoms išlaidoms, 40% pramogoms, 20% taupymui', false, 3),
    (question2_uuid, '70% būtinoms išlaidoms, 20% pramogoms, 10% taupymui', false, 4);
    
    -- Insert quiz options for question 3
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES 
    (question3_uuid, '1-2 mėnesiai', false, 1),
    (question3_uuid, '3-6 mėnesiai', true, 2),
    (question3_uuid, '12-24 mėnesiai', false, 3),
    (question3_uuid, 'Nereikia turėti avarinės atsargos', false, 4);
    
    -- Insert quiz options for question 4
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES 
    (question4_uuid, '15%', false, 1),
    (question4_uuid, '20%', true, 2),
    (question4_uuid, '25%', false, 3),
    (question4_uuid, '32%', false, 4);
    
    -- Insert quiz options for question 5
    INSERT INTO course_quiz_options (question_id, option_text, is_correct, order_index) VALUES 
    (question5_uuid, 'Nėra skirtumo', false, 1),
    (question5_uuid, 'Debeto kortelė naudoja jūsų pinigus, kredito - banko skolintus pinigus', true, 2),
    (question5_uuid, 'Kredito kortelė yra saugesnė', false, 3),
    (question5_uuid, 'Debeto kortelė turi aukštesnes palūkanas', false, 4);
    
END $$;