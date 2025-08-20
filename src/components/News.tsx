import React from 'react';
import { ArrowLeft, Newspaper, Calendar, TrendingUp, AlertCircle } from 'lucide-react';

interface NewsProps {
  onBack: () => void;
}

export const News: React.FC<NewsProps> = ({ onBack }) => {
  const news = [
    {
      id: 1,
      title: 'ECB sumažino palūkanų normas - kas tai reiškia lietuviams?',
      summary: 'Europos centrinis bankas vėl mažino pagrindinę palūkanų normą. Sužinokite, kaip tai paveiks būsto paskolas ir indėlius.',
      date: '2024-01-15',
      category: 'Bankininkystė',
      importance: 'high',
      content: `
        Europos centrinis bankas (ECB) sausio mėnesį priėmė sprendimą sumažinti pagrindinę palūkanų normą iki 3,75%. 
        Tai jau ketvirtas palūkanų mažinimas per pastaruosius metus.
        
        **Kas keičiasi lietuviams:**
        - Būsto paskolų palūkanos gali mažėti 0,1-0,3 procentinio punkto
        - Indėlių palūkanos banke taip pat mažės
        - Investicijos į obligacijas gali tapti mažiau patrauklios
        
        **Ekspertų rekomendacijos:**
        Finansų analitikai pataria dabar peržiūrėti savo investicijų portfelį ir apsvarstyti didesnę dalį investuoti į akcijas.
      `
    },
    {
      id: 2,
      title: 'Pensijų reforma: nauji sprendimai dėl II pakopos',
      summary: 'Seimas priėmė pataisas, keičiančias pensijų kaupimo II pakopoje tvarką. Svarbūs pokyčiai visiems dalyviams.',
      date: '2024-01-12',
      category: 'Pensijos',
      importance: 'high',
      content: `
        Lietuvos Seimas priėmė svarbias pensijų sistemos pataisas, kurios palies visus II pakopos dalyvius.
        
        **Pagrindiniai pokyčiai:**
        - Galimybė keisti pensijų fondą kartą per ketvirtį (anksčiau - kartą per metus)
        - Sumažinti fondo valdymo mokesčiai iki 0,8% (anksčiau iki 1,2%)
        - Naujos investicinės strategijos galimybės
        
        **Kas turėtų keisti fondą:**
        Jei jūsų dabartinio fondo valdymo mokestis viršija 1%, apsvarstykite perėjimą į pigesnį fondą.
      `
    },
    {
      id: 3,
      title: 'Mokesčių deklaravimo sezonas: svarbiausi termini 2024m.',
      summary: 'VMI priminė apie mokesčių deklaravimo terminus ir naujas galimybes gauti mokesčių lengvatas.',
      date: '2024-01-10',
      category: 'Mokesčiai',
      importance: 'medium',
      content: `
        Valstybės mokesčių inspekcija (VMI) paskelbė 2024 metų mokesčių deklaravimo tvarkaraštį.
        
        **Svarbūs terminai:**
        - Kovo 1 d. - deklaravimo pradžia
        - Gegužės 31 d. - paskutinė deklaravimo diena
        - Liepos 31 d. - mokesčių mokėjimo terminas
        
        **Mokestinės lengvatos:**
        - Gydymo išlaidos iki 1,200€
        - Mokymosi išlaidos iki 2,000€
        - Pensijų kaupimas iki 2,000€
      `
    },
    {
      id: 4,
      title: 'Kriptovaliutų reguliavimas ES: MiCA direktyvos poveikis',
      summary: 'Nauja ES direktyva keičia kriptovaliutų prekybos taisykles. Sužinokite, kas laukia investuotojų.',
      date: '2024-01-08',
      category: 'Investicijos',
      importance: 'medium',
      content: `
        Europos Sąjungos MiCA (Markets in Crypto-Assets) direktyva oficialiai įsigaliojo 2024 metais.
        
        **Pagrindiniai pokyčiai:**
        - Griežtesnė kriptovaliutų biržų priežiūra
        - Privalomas licencijavimas paslaugų teikėjams
        - Didesnė investuotojų apsauga
        
        **Investuotojams:**
        Patariama naudotis tik licencijuotų paslaugų teikėjų paslaugomis ir atidžiai vertinti investicijų rizikas.
      `
    },
    {
      id: 5,
      title: 'Lietuvos BVP augo 2,8% - stabilumas tęsiasi',
      summary: 'Statistikos departamento duomenys rodo stabilų ekonomikos augimą, nepaisant globalių iššūkių.',
      date: '2024-01-05',
      category: 'Ekonomika',
      importance: 'low',
      content: `
        Lietuvos statistikos departamento duomenimis, 2023 m. ketvirtąjį ketvirtį šalies BVP augo 2,8% metų amžiuje.
        
        **Augimo faktoriai:**
        - Išaugęs vidaus vartojimas (+3,2%)
        - Eksporto augimas (+1,8%)
        - Investicijos į infrastruktūrą (+4,1%)
        
        **Prognozės 2024m:**
        Ekonomistai prognozuoja 2,5-3% BVP augimą artimiausiais metais.
      `
    }
  ];

  const getImportanceColor = (importance: string) => {
    switch (importance) {
      case 'high': return 'bg-red-100 text-red-800 border-red-200';
      case 'medium': return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'low': return 'bg-green-100 text-green-800 border-green-200';
      default: return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  const getImportanceIcon = (importance: string) => {
    switch (importance) {
      case 'high': return <AlertCircle className="h-4 w-4" />;
      case 'medium': return <TrendingUp className="h-4 w-4" />;
      case 'low': return <Calendar className="h-4 w-4" />;
      default: return <Calendar className="h-4 w-4" />;
    }
  };

  const getCategoryColor = (category: string) => {
    const colors = {
      'Bankininkystė': 'bg-blue-100 text-blue-800',
      'Pensijos': 'bg-orange-100 text-orange-800',
      'Mokesčiai': 'bg-red-100 text-red-800',
      'Investicijos': 'bg-green-100 text-green-800',
      'Ekonomika': 'bg-purple-100 text-purple-800'
    };
    return colors[category as keyof typeof colors] || 'bg-gray-100 text-gray-800';
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors mb-6"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>Grįžti</span>
        </button>

        <div className="text-center">
          <Newspaper className="h-16 w-16 text-blue-600 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Finansų naujienos</h1>
          <p className="text-xl text-gray-600">
            Sekite svarbiausius Lietuvos ir pasaulio finansų rinkų įvykius
          </p>
        </div>
      </div>

      <div className="space-y-6">
        {news.map((article) => (
          <article key={article.id} className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300">
            <div className="p-6">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center space-x-3">
                  <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoryColor(article.category)}`}>
                    {article.category}
                  </span>
                  <div className={`flex items-center space-x-1 px-2 py-1 rounded-full text-xs font-medium border ${getImportanceColor(article.importance)}`}>
                    {getImportanceIcon(article.importance)}
                    <span>
                      {article.importance === 'high' ? 'Svarbu' : 
                       article.importance === 'medium' ? 'Vidutinis' : 'Informacinis'}
                    </span>
                  </div>
                </div>
                <div className="flex items-center text-sm text-gray-500">
                  <Calendar className="h-4 w-4 mr-1" />
                  {new Date(article.date).toLocaleDateString('lt-LT')}
                </div>
              </div>

              <h2 className="text-xl font-bold text-gray-900 mb-3">{article.title}</h2>
              <p className="text-gray-600 mb-4">{article.summary}</p>

              <details className="group">
                <summary className="cursor-pointer text-blue-600 hover:text-blue-800 font-medium">
                  Skaityti daugiau ▾
                </summary>
                <div className="mt-4 prose prose-sm max-w-none">
                  {article.content.split('\n').map((paragraph, index) => {
                    if (paragraph.trim().startsWith('**') && paragraph.trim().endsWith('**')) {
                      return (
                        <h4 key={index} className="font-semibold text-gray-900 mt-4 mb-2">
                          {paragraph.replace(/\*\*/g, '')}
                        </h4>
                      );
                    }
                    if (paragraph.trim().startsWith('- ')) {
                      return (
                        <li key={index} className="ml-4">
                          {paragraph.replace(/^- /, '')}
                        </li>
                      );
                    }
                    if (paragraph.trim()) {
                      return (
                        <p key={index} className="text-gray-700 mb-2">
                          {paragraph}
                        </p>
                      );
                    }
                    return null;
                  })}
                </div>
              </details>
            </div>
          </article>
        ))}
      </div>

      <div className="mt-12 bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-6">
        <h3 className="text-lg font-semibold text-gray-900 mb-2">Prenumeruokite naujienas</h3>
        <p className="text-gray-600 mb-4">
          Gaukite svarbiausias Lietuvos finansų naujienas tiesiog į savo el. paštą
        </p>
        <div className="flex gap-3">
          <input
            type="email"
            placeholder="Jūsų el. paštas"
            className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          />
          <button className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors">
            Prenumeruoti
          </button>
        </div>
      </div>
    </div>
  );
};