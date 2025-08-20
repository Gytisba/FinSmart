import React from 'react';
import { ArrowLeft, ExternalLink, FileText, Globe, Phone, Mail } from 'lucide-react';

interface ResourcesProps {
  onBack: () => void;
}

export const Resources: React.FC<ResourcesProps> = ({ onBack }) => {
  const officialResources = [
    {
      name: 'Lietuvos bankas',
      description: 'Oficialus Lietuvos centrinis bankas, finansinės priežiūros institucija',
      url: 'https://www.lb.lt',
      category: 'official',
      services: ['Finansinė priežiūra', 'Mokėjimų sistemos', 'Statistika']
    },
    {
      name: 'VMI (Valstybės mokesčių inspekcija)',
      description: 'Mokesčių administravimas, deklaravimas, konsultacijos',
      url: 'https://www.vmi.lt',
      category: 'official',
      services: ['Mokesčių deklaravimas', 'GPM skaičiuoklės', 'Konsultacijos']
    },
    {
      name: 'SODRA',
      description: 'Valstybės socialinio draudimo sistemos valdyba',
      url: 'https://www.sodra.lt',
      category: 'official',
      services: ['Pensijos', 'Socialinis draudimas', 'Išmokos']
    },
    {
      name: 'Konkurencijos taryba',
      description: 'Vartotojų teisių apsauga, finansinių paslaugų priežiūra',
      url: 'https://kt.gov.lt',
      category: 'official',
      services: ['Vartotojų apsauga', 'Skundų nagrinėjimas', 'Konsultacijos']
    }
  ];

  const educationalResources = [
    {
      name: 'Finansų mokykla',
      description: 'Nemokama finansinio švietimo programa lietuviams',
      url: 'https://www.finansumokykla.lt',
      category: 'education',
      services: ['Nemokamos pamokos', 'Webinarai', 'E-kursai']
    },
    {
      name: 'Investuok.lt',
      description: 'Investavimo ir taupymo edukacinis portalas',
      url: 'https://www.investuok.lt',
      category: 'education',
      services: ['Investavimo gidai', 'Rinkos analizės', 'Skaičiuoklės']
    },
    {
      name: 'Europos vartotojų centras',
      description: 'ES vartotojų teisių konsultacijos ir parama',
      url: 'https://www.ecc.lt',
      category: 'education',
      services: ['Konsultacijos', 'Ginčų sprendimas', 'Informacija']
    }
  ];

  const toolsAndCalculators = [
    {
      name: 'Pensijų skaičiuoklė',
      description: 'SODRA pensijų skaičiavimo įrankis',
      url: 'https://www.sodra.lt/pensiju-skaiciuokle',
      category: 'tools'
    },
    {
      name: 'Mokesčių skaičiuoklės',
      description: 'VMI GPM ir kitų mokesčių skaičiavimas',
      url: 'https://www.vmi.lt/skaiciuokles',
      category: 'tools'
    },
    {
      name: 'Banko paskolų palyginimas',
      description: 'Finansinio tarpininkavimo paslaugų lyginimas',
      url: 'https://www.lb.lt/paslaugos',
      category: 'tools'
    }
  ];

  const emergencyContacts = [
    {
      service: 'VMI konsultacijų centras',
      phone: '1882',
      email: 'info@vmi.lt',
      hours: 'Pirmadieniais-penktadieniais 8:00-17:00'
    },
    {
      service: 'SODRA klientų aptarnavimas',
      phone: '1883',
      email: 'info@sodra.lt',
      hours: 'Pirmadieniais-penktadieniais 8:00-17:00'
    },
    {
      service: 'Lietuvos banko konsultacijos',
      phone: '+370 5 268 0029',
      email: 'info@lb.lt',
      hours: 'Pirmadieniais-penktadieniais 8:30-17:30'
    },
    {
      service: 'Vartotojų teisių apsauga',
      phone: '1813',
      email: 'info@kt.gov.lt',
      hours: 'Pirmadieniais-penktadieniais 8:00-17:00'
    }
  ];

  const ResourceCard: React.FC<{
    resource: any;
    showServices?: boolean;
  }> = ({ resource, showServices = true }) => (
    <div className="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200 p-6">
      <div className="flex items-start justify-between mb-3">
        <h3 className="text-lg font-semibold text-gray-900">{resource.name}</h3>
        <ExternalLink className="h-4 w-4 text-gray-400" />
      </div>
      
      <p className="text-gray-600 mb-4">{resource.description}</p>
      
      {showServices && resource.services && (
        <div className="mb-4">
          <h4 className="text-sm font-medium text-gray-700 mb-2">Paslaugos:</h4>
          <div className="flex flex-wrap gap-2">
            {resource.services.map((service: string, index: number) => (
              <span
                key={index}
                className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full"
              >
                {service}
              </span>
            ))}
          </div>
        </div>
      )}
      
      <a
        href={resource.url}
        target="_blank"
        rel="noopener noreferrer"
        className="inline-flex items-center space-x-2 text-blue-600 hover:text-blue-800 font-medium transition-colors"
      >
        <Globe className="h-4 w-4" />
        <span>Apsilankyti svetainėje</span>
      </a>
    </div>
  );

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="mb-8">
        <button
          onClick={onBack}
          className="flex items-center space-x-2 text-blue-600 hover:text-blue-800 transition-colors mb-6"
        >
          <ArrowLeft className="h-4 w-4" />
          <span>Grįžti</span>
        </button>

        <div className="text-center">
          <FileText className="h-16 w-16 text-blue-600 mx-auto mb-4" />
          <h1 className="text-3xl font-bold text-gray-900 mb-4">Išteklių centras</h1>
          <p className="text-xl text-gray-600">
            Naudingos nuorodos, kontaktai ir įrankiai finansų valdymui
          </p>
        </div>
      </div>

      {/* Official Resources */}
      <section className="mb-12">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Oficialios institucijos</h2>
        <div className="grid md:grid-cols-2 gap-6">
          {officialResources.map((resource, index) => (
            <ResourceCard key={index} resource={resource} />
          ))}
        </div>
      </section>

      {/* Educational Resources */}
      <section className="mb-12">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Edukaciniai ištekliai</h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {educationalResources.map((resource, index) => (
            <ResourceCard key={index} resource={resource} />
          ))}
        </div>
      </section>

      {/* Tools and Calculators */}
      <section className="mb-12">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Įrankiai ir skaičiuoklės</h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {toolsAndCalculators.map((resource, index) => (
            <ResourceCard key={index} resource={resource} showServices={false} />
          ))}
        </div>
      </section>

      {/* Emergency Contacts */}
      <section className="mb-12">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Svarbūs kontaktai</h2>
        <div className="grid md:grid-cols-2 gap-6">
          {emergencyContacts.map((contact, index) => (
            <div key={index} className="bg-white rounded-lg shadow-md p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-3">{contact.service}</h3>
              
              <div className="space-y-3">
                <div className="flex items-center space-x-3">
                  <Phone className="h-4 w-4 text-green-600" />
                  <span className="text-gray-700">{contact.phone}</span>
                </div>
                
                <div className="flex items-center space-x-3">
                  <Mail className="h-4 w-4 text-blue-600" />
                  <a href={`mailto:${contact.email}`} className="text-blue-600 hover:underline">
                    {contact.email}
                  </a>
                </div>
                
                <div className="text-sm text-gray-500">
                  <strong>Darbo laikas:</strong> {contact.hours}
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* PDF Downloads */}
      <section className="bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-xl p-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-6">Nemokami vadovai PDF formatu</h2>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <h4 className="font-semibold text-gray-900 mb-2">Asmeninių finansų gidas pradedantiesiems</h4>
            <p className="text-sm text-gray-600 mb-3">25 puslapių vadovas biudžeto sudarymui ir taupymui</p>
            <button className="text-blue-600 hover:text-blue-800 font-medium text-sm">
              ⬇️ Atsisiųsti PDF
            </button>
          </div>
          
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <h4 className="font-semibold text-gray-900 mb-2">Investavimo principai Lietuvoje</h4>
            <p className="text-sm text-gray-600 mb-3">40 puslapių vadovas investavimo pradžiamokslį</p>
            <button className="text-blue-600 hover:text-blue-800 font-medium text-sm">
              ⬇️ Atsisiųsti PDF
            </button>
          </div>
          
          <div className="bg-white rounded-lg p-4 shadow-sm">
            <h4 className="font-semibold text-gray-900 mb-2">Pensijų sistema Lietuvoje 2024</h4>
            <p className="text-sm text-gray-600 mb-3">Pilnas vadovas visoms pensijų kaupimo pakopoms</p>
            <button className="text-blue-600 hover:text-blue-800 font-medium text-sm">
              ⬇️ Atsisiųsti PDF
            </button>
          </div>
        </div>
      </section>
    </div>
  );
};