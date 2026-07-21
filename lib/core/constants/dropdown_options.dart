/// Dropdown options and constants for the matrimony app
class DropdownOptions {
  // How did you find us?
  static const List<String> howDidYouFindUs = [
    'By Referral',
    'Instagram',
    'FaiyadFit',
    'Youtube',
    'A Muslim Homemaker',
    'IronFitCoaching',
    'A Muslim Guide',
    'Facebook',
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
    'Yemeni', 'Zambian', 'Zimbabwean', 'Other',
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
  static const List<String> brotherHeights = [
    "121cm - 4' 0\"", "122cm - 4' 0\"", "123cm - 4' 0\"", "124cm - 4' 1\"", "125cm - 4' 1\"", "126cm - 4' 2\"", "127cm - 4' 2\"", "128cm - 4' 2\"", "129cm - 4' 3\"", "130cm - 4' 3\"", "131cm - 4' 4\"", "132cm - 4' 4\"", "133cm - 4' 4\"", "134cm - 4' 5\"", "135cm - 4' 5\"", "136cm - 4' 6\"", "137cm - 4' 6\"", "138cm - 4' 6\"", "139cm - 4' 7\"", "140cm - 4' 7\"", "141cm - 4' 8\"", "142cm - 4' 8\"", "143cm - 4' 8\"", "144cm - 4' 9\"", "145cm - 4' 9\"", "146cm - 4' 9\"", "147cm - 4' 10\"", "148cm - 4' 10\"", "149cm - 4' 11\"", "150cm - 4' 11\"", "151cm - 4' 11\"", "152cm - 5' 0\"", "153cm - 5' 0\"", "154cm - 5' 1\"", "155cm - 5' 1\"", "156cm - 5' 1\"", "157cm - 5' 2\"", "158cm - 5' 2\"", "159cm - 5' 3\"", "160cm - 5' 3\"", "161cm - 5' 3\"", "162cm - 5' 4\"", "163cm - 5' 4\"", "164cm - 5' 5\"", "165cm - 5' 5\"", "166cm - 5' 5\"", "167cm - 5' 6\"", "168cm - 5' 6\"", "169cm - 5' 7\"", "170cm - 5' 7\"", "171cm - 5' 7\"", "172cm - 5' 8\"", "173cm - 5' 8\"", "174cm - 5' 9\"", "175cm - 5' 9\"", "176cm - 5' 9\"", "177cm - 5' 10\"", "178cm - 5' 10\"", "179cm - 5' 10\"", "180cm - 5' 11\"", "181cm - 5' 11\"", "182cm - 6' 0\"", "183cm - 6' 0\"", "184cm - 6' 0\"", "185cm - 6' 1\"", "186cm - 6' 1\"", "187cm - 6' 2\"", "188cm - 6' 2\"", "189cm - 6' 2\"", "190cm - 6' 3\"", "191cm - 6' 3\"", "192cm - 6' 4\"", "193cm - 6' 4\"", "194cm - 6' 4\"", "195cm - 6' 5\"", "196cm - 6' 5\"", "197cm - 6' 6\"", "198cm - 6' 6\"", "199cm - 6' 6\"", "200cm - 6' 7\"", "201cm - 6' 7\"", "202cm - 6' 8\"", "203cm - 6' 8\"", "204cm - 6' 8\"", "205cm - 6' 9\"", "206cm - 6' 9\"", "207cm - 6' 9\"", "208cm - 6' 10\"", "209cm - 6' 10\"", "210cm - 6' 11\"", "211cm - 6' 11\"", "212cm - 6' 11\"", "213cm - 7' 0\"", "214cm - 7' 0\"", "215cm - 7' 1\""
  ];

  // Height options for sisters (91cm - 238cm)
  static const List<String> sisterHeights = [
    "91cm - 3' 0\"", "92cm - 3' 0\"", "93cm - 3' 1\"", "94cm - 3' 1\"", "95cm - 3' 1\"", "96cm - 3' 2\"", "97cm - 3' 2\"", "98cm - 3' 3\"", "99cm - 3' 3\"", "100cm - 3' 3\"", "101cm - 3' 4\"", "102cm - 3' 4\"", "103cm - 3' 5\"", "104cm - 3' 5\"", "105cm - 3' 5\"", "106cm - 3' 6\"", "107cm - 3' 6\"", "108cm - 3' 7\"", "109cm - 3' 7\"", "110cm - 3' 7\"", "111cm - 3' 8\"", "112cm - 3' 8\"", "113cm - 3' 8\"", "114cm - 3' 9\"", "115cm - 3' 9\"", "116cm - 3' 10\"", "117cm - 3' 10\"", "118cm - 3' 10\"", "119cm - 3' 11\"", "120cm - 3' 11\"", "121cm - 4' 0\"", "122cm - 4' 0\"", "123cm - 4' 0\"", "124cm - 4' 1\"", "125cm - 4' 1\"", "126cm - 4' 2\"", "127cm - 4' 2\"", "128cm - 4' 2\"", "129cm - 4' 3\"", "130cm - 4' 3\"", "131cm - 4' 4\"", "132cm - 4' 4\"", "133cm - 4' 4\"", "134cm - 4' 5\"", "135cm - 4' 5\"", "136cm - 4' 6\"", "137cm - 4' 6\"", "138cm - 4' 6\"", "139cm - 4' 7\"", "140cm - 4' 7\"", "141cm - 4' 8\"", "142cm - 4' 8\"", "143cm - 4' 8\"", "144cm - 4' 9\"", "145cm - 4' 9\"", "146cm - 4' 9\"", "147cm - 4' 10\"", "148cm - 4' 10\"", "149cm - 4' 11\"", "150cm - 4' 11\"", "151cm - 4' 11\"", "152cm - 5' 0\"", "153cm - 5' 0\"", "154cm - 5' 1\"", "155cm - 5' 1\"", "156cm - 5' 1\"", "157cm - 5' 2\"", "158cm - 5' 2\"", "159cm - 5' 3\"", "160cm - 5' 3\"", "161cm - 5' 3\"", "162cm - 5' 4\"", "163cm - 5' 4\"", "164cm - 5' 5\"", "165cm - 5' 5\"", "166cm - 5' 5\"", "167cm - 5' 6\"", "168cm - 5' 6\"", "169cm - 5' 7\"", "170cm - 5' 7\"", "171cm - 5' 7\"", "172cm - 5' 8\"", "173cm - 5' 8\"", "174cm - 5' 9\"", "175cm - 5' 9\"", "176cm - 5' 9\"", "177cm - 5' 10\"", "178cm - 5' 10\"", "179cm - 5' 10\"", "180cm - 5' 11\"", "181cm - 5' 11\"", "182cm - 6' 0\"", "183cm - 6' 0\"", "184cm - 6' 0\"", "185cm - 6' 1\"", "186cm - 6' 1\"", "187cm - 6' 2\"", "188cm - 6' 2\"", "189cm - 6' 2\"", "190cm - 6' 3\"", "191cm - 6' 3\"", "192cm - 6' 4\"", "193cm - 6' 4\"", "194cm - 6' 4\"", "195cm - 6' 5\"", "196cm - 6' 5\"", "197cm - 6' 6\"", "198cm - 6' 6\"", "199cm - 6' 6\"", "200cm - 6' 7\"", "201cm - 6' 7\"", "202cm - 6' 8\"", "203cm - 6' 8\"", "204cm - 6' 8\"", "205cm - 6' 9\"", "206cm - 6' 9\"", "207cm - 6' 9\"", "208cm - 6' 10\"", "209cm - 6' 10\"", "210cm - 6' 11\"", "211cm - 6' 11\"", "212cm - 6' 11\"", "213cm - 7' 0\"", "214cm - 7' 0\"", "215cm - 7' 1\"", "216cm - 7' 1\"", "217cm - 7' 1\"", "218cm - 7' 2\"", "219cm - 7' 2\"", "220cm - 7' 3\"", "221cm - 7' 3\"", "222cm - 7' 3\"", "223cm - 7' 4\"", "224cm - 7' 4\"", "225cm - 7' 5\"", "226cm - 7' 5\"", "227cm - 7' 5\"", "228cm - 7' 6\"", "229cm - 7' 6\"", "230cm - 7' 7\"", "231cm - 7' 7\"", "232cm - 7' 7\"", "233cm - 7' 8\"", "234cm - 7' 8\"", "235cm - 7' 9\"", "236cm - 7' 9\"", "237cm - 7' 9\"", "238cm - 7' 10\""
  ];

  // Weight options for brothers (40kg - 149kg)
  static const List<String> brotherWeights = [
    "40kg - 88lbs", "41kg - 90lbs", "42kg - 92lbs", "43kg - 94lbs", "44kg - 97lbs", "45kg - 99lbs", "46kg - 101lbs", "47kg - 103lbs", "48kg - 105lbs", "49kg - 108lbs", "50kg - 110lbs", "51kg - 112lbs", "52kg - 114lbs", "53kg - 116lbs", "54kg - 119lbs", "55kg - 121lbs", "56kg - 123lbs", "57kg - 125lbs", "58kg - 127lbs", "59kg - 130lbs", "60kg - 132lbs", "61kg - 134lbs", "62kg - 136lbs", "63kg - 138lbs", "64kg - 141lbs", "65kg - 143lbs", "66kg - 145lbs", "67kg - 147lbs", "68kg - 149lbs", "69kg - 152lbs", "70kg - 154lbs", "71kg - 156lbs", "72kg - 158lbs", "73kg - 160lbs", "74kg - 163lbs", "75kg - 165lbs", "76kg - 167lbs", "77kg - 169lbs", "78kg - 171lbs", "79kg - 174lbs", "80kg - 176lbs", "81kg - 178lbs", "82kg - 180lbs", "83kg - 182lbs", "84kg - 185lbs", "85kg - 187lbs", "86kg - 189lbs", "87kg - 191lbs", "88kg - 194lbs", "89kg - 196lbs", "90kg - 198lbs", "91kg - 200lbs", "92kg - 202lbs", "93kg - 205lbs", "94kg - 207lbs", "95kg - 209lbs", "96kg - 211lbs", "97kg - 213lbs", "98kg - 216lbs", "99kg - 218lbs", "100kg - 220lbs", "101kg - 222lbs", "102kg - 224lbs", "103kg - 227lbs", "104kg - 229lbs", "105kg - 231lbs", "106kg - 233lbs", "107kg - 235lbs", "108kg - 238lbs", "109kg - 240lbs", "110kg - 242lbs", "111kg - 244lbs", "112kg - 246lbs", "113kg - 249lbs", "114kg - 251lbs", "115kg - 253lbs", "116kg - 255lbs", "117kg - 257lbs", "118kg - 260lbs", "119kg - 262lbs", "120kg - 264lbs", "121kg - 266lbs", "122kg - 268lbs", "123kg - 271lbs", "124kg - 273lbs", "125kg - 275lbs", "126kg - 277lbs", "127kg - 279lbs", "128kg - 282lbs", "129kg - 284lbs", "130kg - 286lbs", "131kg - 288lbs", "132kg - 291lbs", "133kg - 293lbs", "134kg - 295lbs", "135kg - 297lbs", "136kg - 299lbs", "137kg - 302lbs", "138kg - 304lbs", "139kg - 306lbs", "140kg - 308lbs", "141kg - 310lbs", "142kg - 313lbs", "143kg - 315lbs", "144kg - 317lbs", "145kg - 319lbs", "146kg - 321lbs", "147kg - 324lbs", "148kg - 326lbs", "149kg - 328lbs"
  ];

  // Weight options for sisters (20kg - 149kg)
  static const List<String> sisterWeights = [
    "20kg - 44lbs", "21kg - 46lbs", "22kg - 48lbs", "23kg - 50lbs", "24kg - 52lbs", "25kg - 55lbs", "26kg - 57lbs", "27kg - 59lbs", "28kg - 61lbs", "29kg - 63lbs", "30kg - 66lbs", "31kg - 68lbs", "32kg - 70lbs", "33kg - 72lbs", "34kg - 74lbs", "35kg - 77lbs", "36kg - 79lbs", "37kg - 81lbs", "38kg - 83lbs", "39kg - 85lbs", "40kg - 88lbs", "41kg - 90lbs", "42kg - 92lbs", "43kg - 94lbs", "44kg - 97lbs", "45kg - 99lbs", "46kg - 101lbs", "47kg - 103lbs", "48kg - 105lbs", "49kg - 108lbs", "50kg - 110lbs", "51kg - 112lbs", "52kg - 114lbs", "53kg - 116lbs", "54kg - 119lbs", "55kg - 121lbs", "56kg - 123lbs", "57kg - 125lbs", "58kg - 127lbs", "59kg - 130lbs", "60kg - 132lbs", "61kg - 134lbs", "62kg - 136lbs", "63kg - 138lbs", "64kg - 141lbs", "65kg - 143lbs", "66kg - 145lbs", "67kg - 147lbs", "68kg - 149lbs", "69kg - 152lbs", "70kg - 154lbs", "71kg - 156lbs", "72kg - 158lbs", "73kg - 160lbs", "74kg - 163lbs", "75kg - 165lbs", "76kg - 167lbs", "77kg - 169lbs", "78kg - 171lbs", "79kg - 174lbs", "80kg - 176lbs", "81kg - 178lbs", "82kg - 180lbs", "83kg - 182lbs", "84kg - 185lbs", "85kg - 187lbs", "86kg - 189lbs", "87kg - 191lbs", "88kg - 194lbs", "89kg - 196lbs", "90kg - 198lbs", "91kg - 200lbs", "92kg - 202lbs", "93kg - 205lbs", "94kg - 207lbs", "95kg - 209lbs", "96kg - 211lbs", "97kg - 213lbs", "98kg - 216lbs", "99kg - 218lbs", "100kg - 220lbs", "101kg - 222lbs", "102kg - 224lbs", "103kg - 227lbs", "104kg - 229lbs", "105kg - 231lbs", "106kg - 233lbs", "107kg - 235lbs", "108kg - 238lbs", "109kg - 240lbs", "110kg - 242lbs", "111kg - 244lbs", "112kg - 246lbs", "113kg - 249lbs", "114kg - 251lbs", "115kg - 253lbs", "116kg - 255lbs", "117kg - 257lbs", "118kg - 260lbs", "119kg - 262lbs", "120kg - 264lbs", "121kg - 266lbs", "122kg - 268lbs", "123kg - 271lbs", "124kg - 273lbs", "125kg - 275lbs", "126kg - 277lbs", "127kg - 279lbs", "128kg - 282lbs", "129kg - 284lbs", "130kg - 286lbs", "131kg - 288lbs", "132kg - 291lbs", "133kg - 293lbs", "134kg - 295lbs", "135kg - 297lbs", "136kg - 299lbs", "137kg - 302lbs", "138kg - 304lbs", "139kg - 306lbs", "140kg - 308lbs", "141kg - 310lbs", "142kg - 313lbs", "143kg - 315lbs", "144kg - 317lbs", "145kg - 319lbs", "146kg - 321lbs", "147kg - 324lbs", "148kg - 326lbs", "149kg - 328lbs"
  ];


}
