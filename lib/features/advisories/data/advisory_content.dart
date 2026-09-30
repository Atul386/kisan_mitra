import '../domain/advisory_models.dart';

/// Static, English-only reference content (translations to follow).
/// Everything here is general information with a link to the official
/// source; no subsidy amounts or eligibility decisions are hard-coded,
/// because they change by season and by state order.
const List<Scheme> kSchemes = [
  Scheme(
    id: 'mahadbt',
    name: 'MahaDBT farmer schemes (Maharashtra)',
    overview:
        'MahaDBT is the Maharashtra government portal where farmers apply online for many '
        'Agriculture Department schemes using one login, and track their applications.',
    eligibility: [
      'Farmers in Maharashtra with agricultural land records.',
      'Each scheme has its own conditions, such as land holding, category or crop.',
    ],
    benefits: [
      'One place to apply for several farmer schemes.',
      'Direct transfer of approved assistance to the bank account, as per scheme rules.',
    ],
    documents: [
      'Identity proof as required by the portal.',
      '7/12 and 8A land records.',
      'Bank account details.',
      'Category certificate, where a scheme asks for it.',
    ],
    officialUrl: 'https://mahadbt.maharashtra.gov.in',
  ),
  Scheme(
    id: 'mechanization',
    name: 'Farm mechanization',
    overview:
        'The Sub-Mission on Agricultural Mechanization (SMAM) supports farmers in buying farm '
        'machinery and equipment, and in setting up custom hiring centres.',
    eligibility: [
      'Individual farmers and some groups or institutions, as defined by the scheme.',
      'Priority and assistance levels can differ by farmer category and equipment type.',
    ],
    benefits: [
      'Financial assistance (subsidy) on approved machinery.',
      'Rates and limits are set by the scheme and may change.',
    ],
    documents: [
      'Identity proof.',
      '7/12 and 8A land records.',
      'Bank account details.',
      'Quotation from an authorised dealer, where required.',
    ],
    officialUrl: 'https://agrimachinery.nic.in',
  ),
  Scheme(
    id: 'micro-irrigation',
    name: 'Micro irrigation (drip and sprinkler)',
    overview:
        'Under the Pradhan Mantri Krishi Sinchayee Yojana (Per Drop More Crop), farmers can get '
        'assistance to install drip and sprinkler systems that save water.',
    eligibility: [
      'Farmers with a reliable water source and cultivable land.',
      'Conditions and assistance level depend on the state and farmer category.',
    ],
    benefits: [
      'Financial assistance towards drip or sprinkler systems.',
      'Saves water and can reduce labour.',
    ],
    documents: [
      '7/12 and 8A land records.',
      'Identity proof.',
      'Bank account details.',
      'Water source details, where asked.',
    ],
    officialUrl: 'https://pmksy.gov.in',
  ),
  Scheme(
    id: 'horticulture',
    name: 'Horticulture development',
    overview:
        'The Mission for Integrated Development of Horticulture (MIDH) supports fruit, vegetable, '
        'flower and spice growers with planting material, protected cultivation and post-harvest facilities.',
    eligibility: [
      'Farmers growing or planning to grow horticulture crops.',
      'Components and eligibility vary by crop and state programme.',
    ],
    benefits: [
      'Assistance for orchards, protected cultivation, nurseries and post-harvest infrastructure.',
      'Training and technical support through the state horticulture department.',
    ],
    documents: [
      'Identity proof.',
      '7/12 and 8A land records.',
      'Bank account details.',
      'Project details for larger components.',
    ],
    officialUrl: 'https://midh.gov.in',
  ),
  Scheme(
    id: 'agri-infra',
    name: 'Agriculture Infrastructure Fund',
    overview:
        'The Agriculture Infrastructure Fund offers medium to long term loans with interest support '
        'for post-harvest and farm-gate infrastructure such as warehouses, cold storage and processing units.',
    eligibility: [
      'Farmers, farmer groups (FPOs, cooperatives), agri-entrepreneurs and others listed by the scheme.',
      'The project must be an eligible agriculture infrastructure project.',
    ],
    benefits: [
      'Loans with interest subvention and credit guarantee support, as per scheme rules.',
    ],
    documents: [
      'Identity and address proof.',
      'Project report.',
      'Land documents for the project site.',
      'Bank account details.',
    ],
    officialUrl: 'https://agriinfra.dac.gov.in',
  ),
];

const List<OfficialService> kPmKisanServices = [
  OfficialService(
    title: 'PM-KISAN official website',
    description: 'Scheme details, new registration and the Farmers Corner.',
    url: 'https://pmkisan.gov.in',
  ),
  OfficialService(
    title: 'New farmer registration',
    description: 'Register from the Farmers Corner on the official website, or visit a CSC.',
    url: 'https://pmkisan.gov.in',
  ),
  OfficialService(
    title: 'e-KYC',
    description: 'Complete e-KYC from the Farmers Corner or at a CSC. It is needed to keep receiving instalments.',
    url: 'https://pmkisan.gov.in',
  ),
  OfficialService(
    title: 'Beneficiary status',
    description: 'On the official website, open Farmers Corner and choose Beneficiary Status to see if your application is approved.',
    url: 'https://pmkisan.gov.in',
  ),
  OfficialService(
    title: 'Payment status and instalments',
    description: 'See instalment dates and payment status on the official website.',
    url: 'https://pmkisan.gov.in',
  ),
  OfficialService(
    title: 'PM-KISAN helpline',
    description: 'Toll-free helpline for questions about registration and payments.',
    phone: '155261',
  ),
];

const List<OfficialService> kInsuranceServices = [
  OfficialService(
    title: 'About PMFBY',
    description:
        'Pradhan Mantri Fasal Bima Yojana insures notified crops against yield loss from natural '
        'calamities, pests and diseases.',
    url: 'https://pmfby.gov.in',
  ),
  OfficialService(
    title: 'Premium information',
    description:
        'Farmers pay a small, fixed share of the sum insured (for example 2% for kharif food and oilseed crops '
        'and 1.5% for rabi); the rest is subsidised. Check current rates and dates on the portal.',
    url: 'https://pmfby.gov.in',
  ),
  OfficialService(
    title: 'Check policy status',
    description: 'Use the official portal to see your application and policy details.',
    url: 'https://pmfby.gov.in',
  ),
  OfficialService(
    title: 'Report crop loss',
    description:
        'Report localised crop loss quickly, within the time limit set by the scheme, through the crop insurance '
        'helpline, the official app or your bank or insurance company.',
    phone: '14447',
  ),
  OfficialService(
    title: 'Claim information',
    description: 'Claim rules, assessment and settlement are explained on the official portal.',
    url: 'https://pmfby.gov.in',
  ),
  OfficialService(
    title: 'Grievance',
    description: 'Raise a complaint through the official portal or the helpline.',
    url: 'https://pmfby.gov.in',
  ),
  OfficialService(
    title: 'Official helpline',
    description: 'National crop insurance helpline.',
    phone: '14447',
  ),
];
