import React, { useState } from 'react';
import { ArrowLeft, Calculator as CalcIcon, PiggyBank, TrendingUp, Home } from 'lucide-react';

interface CalculatorProps {
  onBack: () => void;
}

export const Calculator: React.FC<CalculatorProps> = ({ onBack }) => {
  const [activeCalculator, setActiveCalculator] = useState<'budget' | 'compound' | 'loan' | null>(null);

  // Budget Calculator State
  const [income, setIncome] = useState<string>('');
  const [expenses, setExpenses] = useState({
    housing: '',
    food: '',
    transport: '',
    entertainment: '',
    other: ''
  });

  // Compound Interest Calculator State
  const [principal, setPrincipal] = useState<string>('');
  const [monthlyContribution, setMonthlyContribution] = useState<string>('');
  const [interestRate, setInterestRate] = useState<string>('');
  const [years, setYears] = useState<string>('');

  // Loan Calculator State
  const [loanAmount, setLoanAmount] = useState<string>('');
  const [loanRate, setLoanRate] = useState<string>('');
  const [loanYears, setLoanYears] = useState<string>('');

  const calculators = [
    {
      id: 'budget' as const,
      title: 'Biudžeto skaičiuoklė',
      description: 'Apskaičiuokite savo mėnesio biudžetą ir sužinokite, kiek galite taupyti',
      icon: PiggyBank,
      color: 'from-emerald-500 to-green-600'
    },
    {
      id: 'compound' as const,
      title: 'Sudėtinių palūkanų skaičiuoklė',
      description: 'Sužinokite, kaip augs jūsų investicijos laiku',
      icon: TrendingUp,
      color: 'from-blue-500 to-indigo-600'
    },
    {
      id: 'loan' as const,
      title: 'Paskolos skaičiuoklė',
      description: 'Apskaičiuokite mėnesinius paskolos mokėjimus',
      icon: Home,
      color: 'from-purple-500 to-pink-600'
    }
  ];

  const calculateBudget = () => {
    const totalIncome = parseFloat(income) || 0;
    const totalExpenses = Object.values(expenses).reduce((sum, expense) => sum + (parseFloat(expense) || 0), 0);
    const savings = totalIncome - totalExpenses;
    const savingsPercentage = totalIncome > 0 ? (savings / totalIncome) * 100 : 0;
    
    return { totalIncome, totalExpenses, savings, savingsPercentage };
  };

  const calculateCompoundInterest = () => {
    const p = parseFloat(principal) || 0;
    const pmt = parseFloat(monthlyContribution) || 0;
    const r = (parseFloat(interestRate) || 0) / 100 / 12;
    const n = (parseFloat(years) || 0) * 12;
    
    if (r === 0) {
      return p + (pmt * n);
    }
    
    const compoundPrincipal = p * Math.pow(1 + r, n);
    const compoundContributions = pmt * ((Math.pow(1 + r, n) - 1) / r);
    
    return compoundPrincipal + compoundContributions;
  };

  const calculateLoanPayment = () => {
    const p = parseFloat(loanAmount) || 0;
    const r = (parseFloat(loanRate) || 0) / 100 / 12;
    const n = (parseFloat(loanYears) || 0) * 12;
    
    if (r === 0) {
      return p / n;
    }
    
    return (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
  };

  const renderCalculatorContent = () => {
    switch (activeCalculator) {
      case 'budget':
        const budgetResult = calculateBudget();
        return (
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Įveskite duomenis</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Mėnesio pajamos (€)
                  </label>
                  <input
                    type="number"
                    value={income}
                    onChange={(e) => setIncome(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="1400"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Būstas (nuoma, komunaliniai) (€)
                  </label>
                  <input
                    type="number"
                    value={expenses.housing}
                    onChange={(e) => setExpenses({...expenses, housing: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="500"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Maistas (€)
                  </label>
                  <input
                    type="number"
                    value={expenses.food}
                    onChange={(e) => setExpenses({...expenses, food: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="300"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Transportas (€)
                  </label>
                  <input
                    type="number"
                    value={expenses.transport}
                    onChange={(e) => setExpenses({...expenses, transport: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="150"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Pramogos (€)
                  </label>
                  <input
                    type="number"
                    value={expenses.entertainment}
                    onChange={(e) => setExpenses({...expenses, entertainment: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="200"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Kitos išlaidos (€)
                  </label>
                  <input
                    type="number"
                    value={expenses.other}
                    onChange={(e) => setExpenses({...expenses, other: e.target.value})}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                    placeholder="100"
                  />
                </div>
              </div>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Rezultatai</h3>
              <div className="bg-gradient-to-r from-emerald-50 to-green-50 border border-emerald-200 rounded-lg p-6">
                <div className="space-y-4">
                  <div className="flex justify-between">
                    <span className="text-gray-700">Bendros pajamos:</span>
                    <span className="font-semibold text-gray-900">€{budgetResult.totalIncome.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-700">Bendros išlaidos:</span>
                    <span className="font-semibold text-red-600">-€{budgetResult.totalExpenses.toFixed(2)}</span>
                  </div>
                  <hr className="border-emerald-200" />
                  <div className="flex justify-between text-lg">
                    <span className="font-semibold">Lieka taupymui:</span>
                    <span className={`font-bold ${budgetResult.savings >= 0 ? 'text-emerald-600' : 'text-red-600'}`}>
                      €{budgetResult.savings.toFixed(2)}
                    </span>
                  </div>
                  <div className="text-center">
                    <span className={`text-sm ${budgetResult.savingsPercentage >= 20 ? 'text-emerald-600' : budgetResult.savingsPercentage >= 10 ? 'text-yellow-600' : 'text-red-600'}`}>
                      {budgetResult.savingsPercentage.toFixed(1)}% pajamų
                    </span>
                  </div>
                </div>
                
                <div className="mt-6 p-4 bg-white rounded-lg">
                  <h4 className="font-medium text-gray-900 mb-2">Rekomendacijos:</h4>
                  <p className="text-sm text-gray-600">
                    {budgetResult.savingsPercentage >= 20 ? 
                      'Puiku! Jūs taupote daugiau nei rekomenduojama.' :
                      budgetResult.savingsPercentage >= 10 ?
                      'Gerai! Bandykite padidinti taupymo dalį iki 20%.' :
                      'Rekomenduojame peržiūrėti išlaidas ir padidinti taupymą.'}
                  </p>
                </div>
              </div>
            </div>
          </div>
        );
        
      case 'compound':
        const futureValue = calculateCompoundInterest();
        const totalContributions = (parseFloat(principal) || 0) + ((parseFloat(monthlyContribution) || 0) * (parseFloat(years) || 0) * 12);
        const earnings = futureValue - totalContributions;
        
        return (
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Įveskite duomenis</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Pradinė suma (€)
                  </label>
                  <input
                    type="number"
                    value={principal}
                    onChange={(e) => setPrincipal(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="1000"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Mėnesinis įnašas (€)
                  </label>
                  <input
                    type="number"
                    value={monthlyContribution}
                    onChange={(e) => setMonthlyContribution(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="200"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Metinės palūkanos (%)
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    value={interestRate}
                    onChange={(e) => setInterestRate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="7"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Investavimo laikotarpis (metai)
                  </label>
                  <input
                    type="number"
                    value={years}
                    onChange={(e) => setYears(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="20"
                  />
                </div>
              </div>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Rezultatai</h3>
              <div className="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-6">
                <div className="space-y-4">
                  <div className="flex justify-between">
                    <span className="text-gray-700">Įnešta iš viso:</span>
                    <span className="font-semibold text-gray-900">€{totalContributions.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-700">Palūkanų pelnas:</span>
                    <span className="font-semibold text-emerald-600">+€{earnings.toFixed(2)}</span>
                  </div>
                  <hr className="border-blue-200" />
                  <div className="flex justify-between text-lg">
                    <span className="font-semibold">Galutinė suma:</span>
                    <span className="font-bold text-blue-600">€{futureValue.toFixed(2)}</span>
                  </div>
                </div>
                
                <div className="mt-6 p-4 bg-white rounded-lg">
                  <h4 className="font-medium text-gray-900 mb-2">Sudėtinių palūkanų galia:</h4>
                  <p className="text-sm text-gray-600">
                    Per {years} metų jūsų investicijos užaugs 
                    <span className="font-semibold text-emerald-600"> {((earnings / totalContributions) * 100).toFixed(1)}%</span> 
                    dėl sudėtinių palūkanų poveikio.
                  </p>
                </div>
              </div>
            </div>
          </div>
        );
        
      case 'loan':
        const monthlyPayment = calculateLoanPayment();
        const totalPayments = monthlyPayment * (parseFloat(loanYears) || 0) * 12;
        const totalInterest = totalPayments - (parseFloat(loanAmount) || 0);
        
        return (
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Įveskite duomenis</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Paskolos suma (€)
                  </label>
                  <input
                    type="number"
                    value={loanAmount}
                    onChange={(e) => setLoanAmount(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                    placeholder="150000"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Metinės palūkanos (%)
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    value={loanRate}
                    onChange={(e) => setLoanRate(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                    placeholder="3.5"
                  />
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Paskolos trukmė (metai)
                  </label>
                  <input
                    type="number"
                    value={loanYears}
                    onChange={(e) => setLoanYears(e.target.value)}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                    placeholder="25"
                  />
                </div>
              </div>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Rezultatai</h3>
              <div className="bg-gradient-to-r from-purple-50 to-pink-50 border border-purple-200 rounded-lg p-6">
                <div className="space-y-4">
                  <div className="flex justify-between">
                    <span className="text-gray-700">Mėnesio mokėjimas:</span>
                    <span className="font-bold text-purple-600 text-xl">€{monthlyPayment.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-700">Bendra mokėjimų suma:</span>
                    <span className="font-semibold text-gray-900">€{totalPayments.toFixed(2)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-700">Palūkanų suma:</span>
                    <span className="font-semibold text-red-600">€{totalInterest.toFixed(2)}</span>
                  </div>
                </div>
                
                <div className="mt-6 p-4 bg-white rounded-lg">
                  <h4 className="font-medium text-gray-900 mb-2">Patarimas:</h4>
                  <p className="text-sm text-gray-600">
                    Jūsų mėnesinis mokėjimas neturėtų viršyti 30-40% mėnesio pajamų. 
                    Šiai paskolai reikėtų uždirbti bent €{(monthlyPayment / 0.35).toFixed(0)} per mėnesį.
                  </p>
                </div>
              </div>
            </div>
          </div>
        );
        
      default:
        return null;
    }
  };

  if (activeCalculator) {
    return (
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-6">
          <button
            onClick={() => setActiveCalculator(null)}
            className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors"
          >
            <ArrowLeft className="h-4 w-4" />
            <span>Grįžti į skaičiuokles</span>
          </button>
        </div>

        <div className="bg-white rounded-xl shadow-lg overflow-hidden">
          <div className={`bg-gradient-to-r ${calculators.find(c => c.id === activeCalculator)?.color} text-white p-6`}>
            <h1 className="text-2xl font-bold">
              {calculators.find(c => c.id === activeCalculator)?.title}
            </h1>
          </div>

          <div className="p-8">
            {renderCalculatorContent()}
          </div>
        </div>
      </div>
    );
  }

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
          <CalcIcon className="h-16 w-16 text-blue-600 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Finansų skaičiuoklės</h1>
          <p className="text-xl text-gray-600">
            Naudokitės mūsų finansų skaičiuoklėmis, kad geriau planuotumėte savo finansus
          </p>
        </div>
      </div>

      <div className="grid md:grid-cols-3 gap-6">
        {calculators.map((calc) => {
          const Icon = calc.icon;
          return (
            <div
              key={calc.id}
              onClick={() => setActiveCalculator(calc.id)}
              className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer transform hover:scale-105"
            >
              <div className={`h-32 bg-gradient-to-r ${calc.color} relative rounded-t-xl`}>
                <div className="absolute inset-0 bg-black bg-opacity-20 rounded-t-xl"></div>
                <div className="relative flex items-center justify-center h-full">
                  <Icon className="h-12 w-12 text-white" />
                </div>
              </div>

              <div className="p-6">
                <h3 className="text-lg font-bold text-gray-900 mb-2">{calc.title}</h3>
                <p className="text-gray-600 text-sm mb-4">{calc.description}</p>
                <button className={`w-full bg-gradient-to-r ${calc.color} text-white py-2 rounded-lg hover:shadow-lg transition-all duration-200`}>
                  Naudoti skaičiuoklę
                </button>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};