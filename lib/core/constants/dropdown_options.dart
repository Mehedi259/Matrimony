/// Dropdown options and constants for the matrimony app
class DropdownOptions {
  // How did you find us?
  static const List<String> howDidYouFindUs = [
    'Social Media (Facebook, Instagram, etc.)',
    'Google Search',
    'Friend/Family Referral',
    'YouTube',
    'Online Advertisement',
    'Community Event',
    'Other',
  ];

  // Religion/Sect
  static const List<String> religionSect = [
    'Sunni',
    'Salafi',
  ];

  // Marital Status - Brother
  static const List<String> maritalStatusBrother = [
    'Never been married',
    'Married (Polygyny)',
    'Annulment (Khula)',
    'Divorced',
    'Widowed',
  ];

  // Marital Status - Sister
  static const List<String> maritalStatusSister = [
    'Never been married',
    'Annulment (Khula)',
    'Divorced',
    'Widowed',
  ];

  // Marital Status (deprecated - use gender-specific lists above)
  static const List<String> maritalStatus = [
    'Never been married',
    'Married (Polygyny)',
    'Annulment (Khula)',
    'Divorced',
    'Widowed',
  ];

  // Yes/No options
  static const List<String> yesNo = [
    'Yes',
    'No',
  ];

  // Children count
  static const List<String> childrenCount = [
    'None',
    '1',
    '2',
    '3',
    '4',
    '5+',
  ];

  // Prayer frequency
  static const List<String> prayerFrequency = [
    'Yes',
    'Mostly',
    'No',
  ];

  // Relocation openness
  static const List<String> relocationOptions = [
    'Yes',
    'No',
    'Maybe (open for discussion)',
    'Not right now, but at a later time',
  ];

  // Hijab/Dress style
  static const List<String> dressStyle = [
    'No Hijab',
    'Hijab and Pants',
    'Hijab and Abaya',
    'Niqab',
  ];

  // Ethnicity options
  static const List<String> ethnicities = [
    'Afghan', 'African-American', 'Albanian', 'Algerian', 'American', 'Andorran',
    'Ango', 'Anguillan', 'Antigua', 'Argentine', 'Armenian', 'Australian',
    'Austrian', 'Azerbaijani', 'Bahamian', 'Bahraini', 'Bangladeshi', 'Bar',
    'Barbadian', 'Belarusian', 'Belgian', 'Belizean', 'Beninese', 'Bermudian',
    'Bhutanese', 'Black', 'Bolivian', 'Bosnian', 'Botswanan', 'Brazilian',
    'British', 'British Virgin Islander', 'Bruneian', 'Bulgarian', 'Burkinan',
    'Burmese', 'Burundian', 'Cambodian', 'Cameroonian', 'Canadian', 'Cape Verdean',
    'Cayman Islander', 'Central African', 'Chadian', 'Chilean', 'Chinese',
    'Colombian', 'Comoran', 'Congolese (Congo)', 'Congolese (DRC)', 'Cook Islander',
    'Costa Rican', 'Croatian', 'Cuban', 'Cymraes', 'Cymro', 'Cypriot', 'Czech',
    'Danish', 'Djiboutian', 'Dominican', 'Citizen of the Dominican Republic',
    'Dutch', 'East Timorese', 'Ecuadorean', 'Egyptian', 'Emirati',
    'Equatorial Guinean', 'Eritrean', 'Estonian', 'Ethiopian', 'Faroese',
    'Fijian', 'Filipino', 'Finnish', 'French', 'Gabonese', 'Gambian', 'Georgian',
    'German', 'Ghanaian', 'Gibraltarian', 'Greek', 'Greenlandic', 'Grenadian',
    'Guamanian', 'Guatemalan', 'Citizen of Guinea-Bissau', 'Guinean', 'Guyanese',
    'Haitian', 'Honduran', 'Hong Konger', 'Hungarian', 'Icelandic', 'Indian',
    'Indonesian', 'Iranian', 'Iraqi', 'Irish', 'Italian', 'Ivorian', 'Jamaican',
    'Japanese', 'Jordanian', 'Kashmiri', 'Kazakh', 'Kenyan', 'Kittitian',
    'Citizen of Kiribati', 'Kosovan', 'Kurdish', 'Kuwaiti', 'Kyrgyz', 'Lao',
    'Latvian', 'Lebanese', 'Liberian', 'Libyan', 'Liechtenstein citizen',
    'Lithuanian', 'Luxembourger', 'Macanese', 'Macedonian', 'Malagasy',
    'Malawian', 'Malaysian', 'Maldivian', 'Malian', 'Maltese', 'Marshallese',
    'Martiniquais', 'Mauritanian', 'Mauritian', 'Mexican', 'Micronesian',
    'Mixed Race', 'Moldovan', 'Monegasque', 'Mongolian', 'Montenegrin',
    'Montserratian', 'Moroccan', 'Mosotho', 'Mozambican', 'Namibian', 'Nauruan',
    'Nepalese', 'New Zealander', 'Nicaraguan', 'Nigerian', 'Nigerien', 'Niuean',
    'North Korean', 'Northern Irish', 'Norwegian', 'Omani', 'Pakistani', 'Palauan',
    'Palestinian', 'Panamanian', 'Papua New Guinean', 'Paraguayan', 'Peruvian',
    'Pitcairn Islander', 'Polish', 'Portuguese', 'Prydeinig', 'Puerto Rican',
    'Qatari', 'Romanian', 'Russian', 'Rwandan', 'Salvadorean', 'Sammarinese',
    'Samoan', 'Sao Tomean', 'Saudi Arabian', 'Scottish', 'Senegalese', 'Serbian',
    'Seychelles', 'Sierra Leonean', 'Singaporean', 'Slovak', 'Slovenian',
    'Solomon Islander', 'Somali', 'South African', 'South Korean', 'South Sudanese',
    'Spanish', 'Sri Lankan', 'St Helenian', 'St Lucian', 'Sudanese', 'Surinamese',
    'Swazi', 'Swedish', 'Swiss', 'Syrian', 'Taiwanese', 'Tajik', 'Tanzanian',
    'Thai', 'Togolese', 'Tongan', 'Trinidadian', 'Tristanian', 'Tunisian',
    'Turkish', 'Turkmen', 'Turks and Caicos Islander', 'Tuvaluan', 'Ugandan',
    'Ukrainian', 'Uruguayan', 'Uzbek', 'Vatican citizen', 'Citizen of Vanuatu',
    'Venezuelan', 'Vietnamese', 'Vincentian', 'Wallisian', 'Welsh', 'White',
    'Yemeni', 'Zambian', 'Zimbabwean', 'Other', 'Open to other Ethnicities',
  ];

  // Countries list for location
  static const List<String> countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda',
    'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas',
    'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin',
    'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei',
    'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia', 'Cameroon', 'Canada',
    'Cape Verde', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia',
    'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic',
    'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'East Timor', 'Ecuador',
    'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Ethiopia',
    'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana',
    'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
    'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland',
    'Italy', 'Ivory Coast', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya',
    'Kiribati', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon',
    'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg',
    'North Macedonia', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali',
    'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia',
    'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar',
    'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger',
    'Nigeria', 'North Korea', 'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine',
    'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland',
    'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis',
    'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino',
    'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles',
    'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia',
    'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan',
    'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania',
    'Thailand', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey',
    'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates',
    'United Kingdom', 'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu',
    'Vatican City', 'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe',
  ];

  // Nationalities (same as ethnicities minus some entries)
  static const List<String> nationalities = [
    'Afghan', 'Albanian', 'Algerian', 'American', 'Andorran', 'Ango',
    'Anguillan', 'Antigua', 'Argentine', 'Armenian', 'Australian', 'Austrian',
    'Azerbaijani', 'Bahamian', 'Bahraini', 'Bangladeshi', 'Bar', 'Barbadian',
    'Belarusian', 'Belgian', 'Belizean', 'Beninese', 'Bermudian', 'Bhutanese',
    'Bolivian', 'Bosnian', 'Botswanan', 'Brazilian', 'British',
    'British Virgin Islander', 'Bruneian', 'Bulgarian', 'Burkinan', 'Burmese',
    'Burundian', 'Cambodian', 'Cameroonian', 'Canadian', 'Cape Verdean',
    'Cayman Islander', 'Central African', 'Chadian', 'Chilean', 'Chinese',
    'Colombian', 'Comoran', 'Congolese (Congo)', 'Congolese (DRC)',
    'Cook Islander', 'Costa Rican', 'Croatian', 'Cuban', 'Cymraes', 'Cymro',
    'Cypriot', 'Czech', 'Danish', 'Djiboutian', 'Dominican',
    'Citizen of the Dominican Republic', 'Dutch', 'East Timorese', 'Ecuadorean',
    'Egyptian', 'Emirati', 'Equatorial Guinean', 'Eritrean', 'Estonian',
    'Ethiopian', 'Faroese', 'Fijian', 'Filipino', 'Finnish', 'French',
    'Gabonese', 'Gambian', 'Georgian', 'German', 'Ghanaian', 'Gibraltarian',
    'Greek', 'Greenlandic', 'Grenadian', 'Guamanian', 'Guatemalan',
    'Citizen of Guinea-Bissau', 'Guinean', 'Guyanese', 'Haitian', 'Honduran',
    'Hong Konger', 'Hungarian', 'Icelandic', 'Indian', 'Indonesian', 'Iranian',
    'Iraqi', 'Irish', 'Italian', 'Ivorian', 'Jamaican', 'Japanese', 'Jordanian',
    'Kazakh', 'Kenyan', 'Kittitian', 'Citizen of Kiribati', 'Kosovan', 'Kurdish',
    'Kuwaiti', 'Kyrgyz', 'Lao', 'Latvian', 'Lebanese', 'Liberian', 'Libyan',
    'Liechtenstein citizen', 'Lithuanian', 'Luxembourger', 'Macanese',
    'Macedonian', 'Malagasy', 'Malawian', 'Malaysian', 'Maldivian', 'Malian',
    'Maltese', 'Marshallese', 'Martiniquais', 'Mauritanian', 'Mauritian',
    'Mexican', 'Micronesian', 'Moldovan', 'Monegasque', 'Mongolian',
    'Montenegrin', 'Montserratian', 'Moroccan', 'Mosotho', 'Mozambican',
    'Namibian', 'Nauruan', 'Nepalese', 'New Zealander', 'Nicaraguan', 'Nigerian',
    'Nigerien', 'Niuean', 'North Korean', 'Northern Irish', 'Norwegian', 'Omani',
    'Pakistani', 'Palauan', 'Palestinian', 'Panamanian', 'Papua New Guinean',
    'Paraguayan', 'Peruvian', 'Pitcairn Islander', 'Polish', 'Portuguese',
    'Prydeinig', 'Puerto Rican', 'Qatari', 'Romanian', 'Russian', 'Rwandan',
    'Salvadorean', 'Sammarinese', 'Samoan', 'Sao Tomean', 'Saudi Arabian',
    'Scottish', 'Senegalese', 'Serbian', 'Seychelles', 'Sierra Leonean',
    'Singaporean', 'Slovak', 'Slovenian', 'Solomon Islander', 'Somali',
    'South African', 'South Korean', 'South Sudanese', 'Spanish', 'Sri Lankan',
    'St Helenian', 'St Lucian', 'Sudanese', 'Surinamese', 'Swazi', 'Swedish',
    'Swiss', 'Syrian', 'Taiwanese', 'Tajik', 'Tanzanian', 'Thai', 'Togolese',
    'Tongan', 'Trinidadian', 'Tristanian', 'Tunisian', 'Turkish', 'Turkmen',
    'Turks and Caicos Islander', 'Tuvaluan', 'Ugandan', 'Ukrainian', 'Uruguayan',
    'Uzbek', 'Vatican citizen', 'Citizen of Vanuatu', 'Venezuelan', 'Vietnamese',
    'Vincentian', 'Wallisian', 'Welsh', 'Yemeni', 'Zambian', 'Zimbabwean',
  ];

  // Height options for brothers (121cm - 215cm)
  static List<String> get brotherHeights {
    List<String> heights = [];
    for (int cm = 121; cm <= 215; cm++) {
      int feet = cm ~/ 30.48;
      int inches = ((cm % 30.48) / 2.54).round();
      if (inches >= 12) {
        feet++;
        inches = inches - 12;
      }
      heights.add('$cm cm - $feet\' $inches"');
    }
    return heights;
  }

  // Height options for sisters (91cm - 238cm)
  static List<String> get sisterHeights {
    List<String> heights = [];
    for (int cm = 91; cm <= 238; cm++) {
      int feet = cm ~/ 30.48;
      int inches = ((cm % 30.48) / 2.54).round();
      if (inches >= 12) {
        feet++;
        inches = inches - 12;
      }
      heights.add('$cm cm - $feet\' $inches"');
    }
    return heights;
  }

  // Weight options for brothers (40kg - 149kg)
  static List<String> get brotherWeights {
    List<String> weights = [];
    for (int kg = 40; kg <= 149; kg++) {
      int lbs = (kg * 2.20462).round();
      weights.add('$kg kg - $lbs lbs');
    }
    return weights;
  }

  // Weight options for sisters (20kg - 149kg)
  static List<String> get sisterWeights {
    List<String> weights = [];
    for (int kg = 20; kg <= 149; kg++) {
      int lbs = (kg * 2.20462).round();
      weights.add('$kg kg - $lbs lbs');
    }
    return weights;
  }
}
