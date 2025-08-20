import React, { useState } from 'react';
import { ArrowLeft, Search, Book } from 'lucide-react';

interface GlossaryProps {
  onBack: () => void;
}

export const Glossary: React.FC<GlossaryProps> = ({ onBack }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');

  const terms = [
    {
      term: 'Infliacija',
      english: 'Inflation',
      definition: 'Kainų lygio augimas ekonomikoje per tam tikrą laikotarpį, dėl kurio mažėja pinigų perkamoji galia.',
      category: 'economics',
      example: 'Jei infliacija 3%, tai kas šiandien kainuoja 100€, po metų kainuos 103€.'
    },
    {
      term: 'Dividendai',
      english: 'Dividends',
      definition: 'Bendrovės pelnų dalis, paskirstoma akcininkams proporcingai jų turimų akcijų skaičiui.',
      category: 'investments',
      example: 'Jei bendrovė moka 2€ dividendų už akciją, o jūs turite 100 akcijų, gausite 200€.'
    },
    {
      term: 'Sudėtinės palūkanos',
      english: 'Compound Interest',
      definition: 'Palūkanos, skaičiuojamos ne tik nuo pradinės sumos, bet ir nuo anksčiau sukauptų palūkanų.',
      category: 'banking',
      example: 'Investavus 1000€ su 5% metinėmis palūkanomis, po metų turėsite 1050€, po dvejų - 1102,50€.'
    },
    {
      term: 'ETF',
      english: 'Exchange-Traded Fund',
      definition: 'Investicinis fondas, kuriam priklauso įvairios akcijos ar obligacijos, prekiaujamos biržoje kaip paprastos akcijos.',
      category: 'investments',
      example: 'S&P 500 ETF leidžia investuoti į 500 didžiausių JAV bendrovių vienu pirkimu.'
    },
    {
      term: 'Diversifikacija',
      english: 'Diversification',
      definition: 'Investicinės rizikos paskirstymas tarp skirtingų aktyvų, sektorių ar geografinių regionų.',
      category: 'investments',
      example: 'Vietoj investavimo į vieną bendrovę, paskirstykite pinigus tarp akcijų, obligacijų ir nekilnojamojo turto.'
    },
    {
      term: 'Likvidumas',
      english: 'Liquidity',
      definition: 'Turto gebėjimas būti greitai ir lengvai paverčiamu pinigais be didelių nuostolių.',
      category: 'banking',
      example: 'Einamoji sąskaita turi didelį likvidumą, o nekilnojamasis turtas - mažą.'
    },
    {
      term: 'SODRA',
      english: 'Social Insurance',
      definition: 'Valstybės socialinio draudimo fondo valdyba - Lietuvos socialinio draudimo sistema.',
      category: 'pensions',
      example: 'SODRA renka įmokas pensijoms, ligų išmokoms ir nedarbingumo kompensacijoms.'
    },
    {
      term: 'VMI',
      english: 'Tax Authority',
      definition: 'Valstybės mokesčių inspekcija - institucija, administruojanti mokesčius Lietuvoje.',
      category: 'taxes',
      example: 'VMI administruoja GPM, PVM, pelno mokestį ir kitus mokesčius.'
    },
    {
      term: 'GPM',
      english: 'Personal Income Tax',
      definition: 'Gyventojų pajamų mokestis - mokestis, mokamas nuo fizinių asmenų pajamų.',
      category: 'taxes',
      example: '2024m. GPM tarifas Lietuvoje - 20% (standartinis) arba 15% (mažesnėms pajamoms).'
    },
    {
      term: 'Pensijų fondas',
      english: 'Pension Fund',
      definition: 'Specializuota įstaiga, kaupianti ir investuojanti lėšas pensijų mokėjimams.',
      category: 'pensions',
      example: 'II pakopos pensijų fondai Lietuvoje: SEB, Swedbank, Luminor ir kt.'
    }
  ];

  const categories = [
    { id: 'all', name: 'Visi terminai', count: terms.length },
    { id: 'economics', name: 'Ekonomika', count: terms.filter(t => t.category === 'economics').length },
    { id: 'investments', name: 'Investicijos', count: terms.filter(t => t.category === 'investments').length },
    { id: 'banking', name: 'Bankininkystė', count: terms.filter(t => t.category === 'banking').length },
    { id: 'pensions', name: 'Pensijos', count: terms.filter(t => t.category === 'pensions').length },
    { id: 'taxes', name: 'Mokesčiai', count: terms.filter(t => t.category === 'taxes').length }
  ];

  const filteredTerms = terms.filter(term => {
    const matchesSearch = term.term.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         term.english.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         term.definition.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || term.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const getCategoryColor = (category: string) => {
    const colors = {
      economics: 'bg-blue-100 text-blue-800',
      investments: 'bg-green-100 text-green-800',
      banking: 'bg-purple-100 text-purple-800',
      pensions: 'bg-orange-100 text-orange-800',
      taxes: 'bg-red-100 text-red-800'
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
          <Book className="h-16 w-16 text-blue-600 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Finansų žodynas</h1>
          <p className="text-xl text-gray-600">
            Sužinokite finansų terminų reikšmes lietuvių ir anglų kalbomis
          </p>
        </div>
      </div>

      <div className="bg-white rounded-xl shadow-lg overflow-hidden">
        <div className="p-6 border-b border-gray-200">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
              <input
                type="text"
                placeholder="Ieškoti terminų..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            
            <div className="flex flex-wrap gap-2">
              {categories.map((category) => (
                <button
                  key={category.id}
                  onClick={() => setSelectedCategory(category.id)}
                  className={`px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                    selectedCategory === category.id
                      ? 'bg-blue-600 text-white'
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                >
                  {category.name} ({category.count})
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className="divide-y divide-gray-200">
          {filteredTerms.length > 0 ? (
            filteredTerms.map((term, index) => (
              <div key={index} className="p-6 hover:bg-gray-50 transition-colors">
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">{term.term}</h3>
                    <p className="text-sm text-gray-500">{term.english}</p>
                  </div>
                  <span className={`px-2 py-1 rounded-full text-xs font-medium ${getCategoryColor(term.category)}`}>
                    {categories.find(c => c.id === term.category)?.name}
                  </span>
                </div>
                
                <p className="text-gray-700 mb-4">{term.definition}</p>
                
                <div className="bg-blue-50 border-l-4 border-blue-400 p-3 rounded-r-lg">
                  <p className="text-sm text-blue-800">
                    <span className="font-medium">Pavyzdys:</span> {term.example}
                  </p>
                </div>
              </div>
            ))
          ) : (
            <div className="p-12 text-center">
              <div className="text-gray-400 mb-4">
                <Book className="h-12 w-12 mx-auto" />
              </div>
              <h3 className="text-lg font-medium text-gray-900 mb-2">Terminų nerasta</h3>
              <p className="text-gray-500">
                Pabandykite keisti paieškos žodžius arba kategoriją
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};