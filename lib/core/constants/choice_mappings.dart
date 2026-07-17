/// Maps Flutter display labels to backend API keys and vice versa.
/// Backend uses snake_case keys for all choice fields.
/// This file ensures correct keys are sent to and received from the API.
///
/// Source of truth: Backend's questions/choices.py
class ChoiceMappings {
  // ===== MARITAL STATUS =====
  static const Map<String, String> maritalStatusDisplayToKey = {
    'Never been married': 'never_married',
    'Married (Polygyny)': 'polygyny',
    'Annulment (Khula)': 'khula',
    'Divorced': 'divorced',
    'Widowed': 'widowed',
  };

  static final Map<String, String> maritalStatusKeyToDisplay =
      _reverseMap(maritalStatusDisplayToKey);

  // ===== RELIGION / SECT =====
  static const Map<String, String> sectDisplayToKey = {
    'Sunni': 'sunni',
    'Salafi': 'salafi',
  };

  static final Map<String, String> sectKeyToDisplay =
      _reverseMap(sectDisplayToKey);

  // ===== HOW FOUND =====
  static const Map<String, String> howFoundDisplayToKey = {
    'By Referral': 'referral',
    'Instagram': 'instagram',
    'FaiyadFit': 'faiyad_fit',
    'Youtube': 'youtube',
    'A Muslim Homemaker': 'a_muslim_homemaker',
    'IronFitCoaching': 'iron_fit_coaching',
    'A Muslim Guide': 'a_muslim_guide',
    'Facebook': 'facebook',
    'Other': 'other',
  };

  static final Map<String, String> howFoundKeyToDisplay =
      _reverseMap(howFoundDisplayToKey);

  // ===== ETHNICITY =====
  static const Map<String, String> ethnicityDisplayToKey = {
    'Open to other Ethnicities': 'open_other',
    'Afghan': 'afghan',
    'African-American': 'african_american',
    'Albanian': 'albanian',
    'Algerian': 'algerian',
    'American': 'american',
    'Andorran': 'andorran',
    'Ango': 'angolan',
    'Anguillan': 'anguillan',
    'Antigua': 'antiguan',
    'Argentine': 'argentine',
    'Armenian': 'armenian',
    'Australian': 'australian',
    'Austrian': 'austrian',
    'Azerbaijani': 'azerbaijani',
    'Bahamian': 'bahamian',
    'Bahraini': 'bahraini',
    'Bangladeshi': 'bangladeshi',
    'Barbadian': 'barbadian',
    'Belarusian': 'belarusian',
    'Belgian': 'belgian',
    'Belizean': 'belizean',
    'Beninese': 'beninese',
    'Bermudian': 'bermudian',
    'Bhutanese': 'bhutanese',
    'Black': 'black',
    'Bolivian': 'bolivian',
    'Bosnian': 'bosnian',
    'Botswanan': 'botswanan',
    'Brazilian': 'brazilian',
    'British': 'british',
    'British Virgin Islander': 'british_vi',
    'Bruneian': 'bruneian',
    'Bulgarian': 'bulgarian',
    'Burkinan': 'burkinan',
    'Burmese': 'burmese',
    'Burundian': 'burundian',
    'Cambodian': 'cambodian',
    'Cameroonian': 'cameroonian',
    'Canadian': 'canadian',
    'Cape Verdean': 'cape_verdean',
    'Cayman Islander': 'cayman_islander',
    'Central African': 'central_african',
    'Chadian': 'chadian',
    'Chilean': 'chilean',
    'Chinese': 'chinese',
    'Colombian': 'colombian',
    'Comoran': 'comoran',
    'Congolese (Congo)': 'congolese_rep',
    'Congolese (DRC)': 'congolese_drc',
    'Cook Islander': 'cook_islander',
    'Costa Rican': 'costa_rican',
    'Croatian': 'croatian',
    'Cuban': 'cuban',
    'Cymraes': 'cymraes',
    'Cymro': 'cymro',
    'Cypriot': 'cypriot',
    'Czech': 'czech',
    'Danish': 'danish',
    'Djiboutian': 'djiboutian',
    'Dominican': 'dominican',
    'Citizen of the Dominican Republic': 'dominican_rep',
    'Dutch': 'dutch',
    'East Timorese': 'east_timorese',
    'Ecuadorean': 'ecuadorean',
    'Egyptian': 'egyptian',
    'Emirati': 'emirati',
    'Equatorial Guinean': 'equatorial_guinean',
    'Eritrean': 'eritrean',
    'Estonian': 'estonian',
    'Ethiopian': 'ethiopian',
    'Faroese': 'faroese',
    'Fijian': 'fijian',
    'Filipino': 'filipino',
    'Finnish': 'finnish',
    'French': 'french',
    'Gabonese': 'gabonese',
    'Gambian': 'gambian',
    'Georgian': 'georgian',
    'German': 'german',
    'Ghanaian': 'ghanaian',
    'Gibraltarian': 'gibraltarian',
    'Greek': 'greek',
    'Greenlandic': 'greenlandic',
    'Grenadian': 'grenadian',
    'Guamanian': 'guamanian',
    'Guatemalan': 'guatemalan',
    'Citizen of Guinea-Bissau': 'guinea_bissau',
    'Guinean': 'guinean',
    'Guyanese': 'guyanese',
    'Haitian': 'haitian',
    'Honduran': 'honduran',
    'Hong Konger': 'hong_konger',
    'Hungarian': 'hungarian',
    'Icelandic': 'icelandic',
    'Indian': 'indian',
    'Indonesian': 'indonesian',
    'Iranian': 'iranian',
    'Iraqi': 'iraqi',
    'Irish': 'irish',
    'Italian': 'italian',
    'Ivorian': 'ivorian',
    'Jamaican': 'jamaican',
    'Japanese': 'japanese',
    'Jordanian': 'jordanian',
    'Kashmiri': 'kashmiri',
    'Kazakh': 'kazakh',
    'Kenyan': 'kenyan',
    'Kittitian': 'kittitian',
    'Citizen of Kiribati': 'kiribati',
    'Kosovan': 'kosovan',
    'Kurdish': 'kurdish',
    'Kuwaiti': 'kuwaiti',
    'Kyrgyz': 'kyrgyz',
    'Lao': 'lao',
    'Latvian': 'latvian',
    'Lebanese': 'lebanese',
    'Liberian': 'liberian',
    'Libyan': 'libyan',
    'Liechtenstein citizen': 'liechtenstein',
    'Lithuanian': 'lithuanian',
    'Luxembourger': 'luxembourger',
    'Macanese': 'macanese',
    'Macedonian': 'macedonian',
    'Malagasy': 'malagasy',
    'Malawian': 'malawian',
    'Malaysian': 'malaysian',
    'Maldivian': 'maldivian',
    'Malian': 'malian',
    'Maltese': 'maltese',
    'Marshallese': 'marshallese',
    'Martiniquais': 'martiniquais',
    'Mauritanian': 'mauritanian',
    'Mauritian': 'mauritian',
    'Mexican': 'mexican',
    'Micronesian': 'micronesian',
    'Mixed Race': 'mixed_race',
    'Moldovan': 'moldovan',
    'Monegasque': 'monegasque',
    'Mongolian': 'mongolian',
    'Montenegrin': 'montenegrin',
    'Montserratian': 'montserratian',
    'Moroccan': 'moroccan',
    'Mosotho': 'mosotho',
    'Mozambican': 'mozambican',
    'Namibian': 'namibian',
    'Nauruan': 'nauruan',
    'Nepalese': 'nepalese',
    'New Zealander': 'new_zealander',
    'Nicaraguan': 'nicaraguan',
    'Nigerian': 'nigerian',
    'Nigerien': 'nigerien',
    'Niuean': 'niuean',
    'North Korean': 'north_korean',
    'Northern Irish': 'northern_irish',
    'Norwegian': 'norwegian',
    'Omani': 'omani',
    'Pakistani': 'pakistani',
    'Palauan': 'palauan',
    'Palestinian': 'palestinian',
    'Panamanian': 'panamanian',
    'Papua New Guinean': 'papua_new_guinean',
    'Paraguayan': 'paraguayan',
    'Peruvian': 'peruvian',
    'Pitcairn Islander': 'pitcairn_islander',
    'Polish': 'polish',
    'Portuguese': 'portuguese',
    'Prydeinig': 'prydeinig',
    'Puerto Rican': 'puerto_rican',
    'Qatari': 'qatari',
    'Romanian': 'romanian',
    'Russian': 'russian',
    'Rwandan': 'rwandan',
    'Salvadorean': 'salvadorean',
    'Sammarinese': 'sammarinese',
    'Samoan': 'samoan',
    'Sao Tomean': 'sao_tomean',
    'Saudi Arabian': 'saudi_arabian',
    'Scottish': 'scottish',
    'Senegalese': 'senegalese',
    'Serbian': 'serbian',
    'Seychelles': 'seychellois',
    'Sierra Leonean': 'sierra_leonean',
    'Singaporean': 'singaporean',
    'Slovak': 'slovak',
    'Slovenian': 'slovenian',
    'Solomon Islander': 'solomon_islander',
    'Somali': 'somali',
    'South African': 'south_african',
    'South Korean': 'south_korean',
    'South Sudanese': 'south_sudanese',
    'Spanish': 'spanish',
    'Sri Lankan': 'sri_lankan',
    'St Helenian': 'st_helenian',
    'St Lucian': 'st_lucian',
    'Sudanese': 'sudanese',
    'Surinamese': 'surinamese',
    'Swazi': 'swazi',
    'Swedish': 'swedish',
    'Swiss': 'swiss',
    'Syrian': 'syrian',
    'Taiwanese': 'taiwanese',
    'Tajik': 'tajik',
    'Tanzanian': 'tanzanian',
    'Thai': 'thai',
    'Togolese': 'togolese',
    'Tongan': 'tongan',
    'Trinidadian': 'trinidadian',
    'Tristanian': 'tristanian',
    'Tunisian': 'tunisian',
    'Turkish': 'turkish',
    'Turkmen': 'turkmen',
    'Turks and Caicos Islander': 'turks_caicos',
    'Tuvaluan': 'tuvaluan',
    'Ugandan': 'ugandan',
    'Ukrainian': 'ukrainian',
    'Uruguayan': 'uruguayan',
    'Uzbek': 'uzbek',
    'Vatican citizen': 'vatican',
    'Citizen of Vanuatu': 'vanuatu',
    'Venezuelan': 'venezuelan',
    'Vietnamese': 'vietnamese',
    'Vincentian': 'vincentian',
    'Wallisian': 'wallisian',
    'Welsh': 'welsh',
    'White': 'white',
    'Yemeni': 'yemeni',
    'Zambian': 'zambian',
    'Zimbabwean': 'zimbabwean',
    'Other': 'other',
  };

  static final Map<String, String> ethnicityKeyToDisplay =
      _reverseMap(ethnicityDisplayToKey);

  // ===== NATIONALITY =====
  // Nationality uses the same key pattern as ethnicity.
  // The ethnicityDisplayToKey map is a superset, so we reuse it.
  static const Map<String, String> nationalityDisplayToKey =
      ethnicityDisplayToKey;

  static final Map<String, String> nationalityKeyToDisplay =
      ethnicityKeyToDisplay;

  // ===== PRAYER =====
  static const Map<String, String> prayerDisplayToKey = {
    'Yes': 'yes',
    'Mostly': 'mostly',
    'No': 'no',
  };

  static final Map<String, String> prayerKeyToDisplay =
      _reverseMap(prayerDisplayToKey);

  // ===== RELOCATION =====
  static const Map<String, String> relocationDisplayToKey = {
    'Yes': 'yes',
    'No': 'no',
    'Maybe (open for discussion)': 'maybe',
    'Not right now, but at a later time': 'later',
  };

  static final Map<String, String> relocationKeyToDisplay =
      _reverseMap(relocationDisplayToKey);

  // ===== DRESS STYLE =====
  static const Map<String, String> dressDisplayToKey = {
    'No Hijab': 'no_hijab',
    'Hijab and Pants': 'hijab_pants',
    'Hijab and Abaya': 'hijab_abaya',
    'Niqab': 'niqab',
  };

  static final Map<String, String> dressKeyToDisplay =
      _reverseMap(dressDisplayToKey);

  // ===== CHILDREN COUNT =====
  static const Map<String, String> childrenCountDisplayToKey = {
    'None': '0',
    '1': '1',
    '2': '2',
    '3': '3',
    '4': '4',
    '5+': '5_plus',
  };

  static final Map<String, String> childrenCountKeyToDisplay =
      _reverseMap(childrenCountDisplayToKey);

  // ===== EDUCATION =====
  static const Map<String, String> educationDisplayToKey = {
    'High School Graduate': 'high_school',
    'Associates Degree': 'associates',
    'Technical Degree': 'technical',
    'College': 'college',
    'Bachelors Degree': 'bachelors',
    'Masters Degree': 'masters',
    'Graduate Degree': 'graduate',
    'J.D./M.D./PhD': 'jd_md_phd',
    'Other': 'other',
  };

  static final Map<String, String> educationKeyToDisplay =
      _reverseMap(educationDisplayToKey);

  // ===== INCOME =====
  static const Map<String, String> incomeDisplayToKey = {
    '£0 - £12k': '0_12k',
    '£12k - £20k': '12_20k',
    '£20k - £50k': '20_50k',
    '£50k - £100k': '50_100k',
    '£100k - £300k': '100_300k',
    '£300k - £500k': '300_500k',
    '£500k+': '500k_plus',
    'Would rather not share': 'rather_not_say',
    'Unemployed': 'unemployed',
  };

  static final Map<String, String> incomeKeyToDisplay =
      _reverseMap(incomeDisplayToKey);

  // ===== BODY FRAME =====
  static const Map<String, String> frameDisplayToKey = {
    'Petite': 'petite',
    'Slim': 'slim',
    'Average': 'average',
    'Fit/Athletic': 'fit_athletic',
    'Muscular': 'muscular',
    'Curvy': 'curvy',
    'A few Extra Pounds': 'few_extra',
    'Wider frame': 'wider_frame',
    'Bulky': 'bulky',
  };

  static final Map<String, String> frameKeyToDisplay =
      _reverseMap(frameDisplayToKey);

  // ===== LANGUAGES =====
  static const Map<String, String> languageDisplayToKey = {
    'Arabic': 'arabic',
    'English': 'english',
    'French': 'french',
    'Spanish': 'spanish',
    'Urdu': 'urdu',
    'Hindi': 'hindi',
    'Bengali': 'bengali',
    'Turkish': 'turkish',
    'Hausa': 'hausa',
    'Swahili': 'swahili',
    'Malay': 'malay',
    'Indonesian': 'indonesian',
    'Somali': 'somali',
    'Persian/Farsi': 'persian',
    'Pashto': 'pashto',
    'Punjabi': 'punjabi',
    'German': 'german',
    'Portuguese': 'portuguese',
    'Russian': 'russian',
    'Chinese (Mandarin)': 'chinese',
    'Other': 'other',
  };

  static final Map<String, String> languageKeyToDisplay =
      _reverseMap(languageDisplayToKey);

  // ===== WALI RELATION =====
  static const Map<String, String> waliRelationDisplayToKey = {
    'Father': 'father',
    'Brother': 'brother',
    'Uncle': 'uncle',
    'Grandfather': 'grandfather',
    'Other': 'other',
  };

  static final Map<String, String> waliRelationKeyToDisplay =
      _reverseMap(waliRelationDisplayToKey);

  // =====================================================================
  // UTILITY METHODS
  // =====================================================================

  /// Convert a single display label to backend key
  static String displayToKey(String display, Map<String, String> mapping) {
    return mapping[display] ?? display;
  }

  /// Convert a single backend key to display label
  static String keyToDisplay(String key, Map<String, String> reverseMapping) {
    return reverseMapping[key] ?? key;
  }

  /// Convert a list of display labels to backend keys
  static List<String> displaysToKeys(
      List<String> displays, Map<String, String> mapping) {
    return displays.map((d) => mapping[d] ?? d).toList();
  }

  /// Convert a list of backend keys to display labels
  static List<String> keysToDisplays(
      List<String> keys, Map<String, String> reverseMapping) {
    return keys.map((k) => reverseMapping[k] ?? k).toList();
  }

  /// Create a reverse map (value → key)
  static Map<String, String> _reverseMap(Map<String, String> map) {
    return map.map((key, value) => MapEntry(value, key));
  }
}
