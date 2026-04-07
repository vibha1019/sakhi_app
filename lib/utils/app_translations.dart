class AppTranslations {
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      // Home Screen
      'welcome': 'Welcome back!',
      'your_business_friend': 'Your Business Friend',
      'micromitra': 'MicroMitra',
      
      // Features
      'pricing_calculator': 'Pricing Calculator',
      'pricing_desc': 'Calculate fair prices for your products',
      'marketing_tools': 'Marketing Tools',
      'marketing_desc': 'Create flyers and ads instantly',
      'finance_tracker': 'Finance Tracker',
      'finance_desc': 'Track income and expenses',
      'business_tips': 'Business Tips',
      'tips_desc': 'Learn business strategies',
      
      // Pricing Screen
      'calculate_fair_prices': 'Calculate Fair Prices',
      'never_undercharge': 'Never undercharge again!',
      'material_cost': 'Material Cost',
      'enter_material_cost': 'Enter cost of materials in ₹',
      'labor_hours': 'Labor Hours',
      'how_many_hours': 'How many hours did it take?',
      'calculate_price': 'Calculate Price',
      'suggested_price': 'Suggested Price',
      'includes_profit': 'This includes 40% profit margin',
      'pricing_tips': 'Pricing Tips',
      
      // Finance Screen
      'current_balance': 'Current Balance',
      'income': 'Income',
      'expense': 'Expense',
      'expenses': 'Expenses',
      'recent_transactions': 'Recent Transactions',
      'add_transaction': 'Add Transaction',
      'try_voice_input': 'Try Voice Input',
      'say_example': 'Say "I earned 200 rupees today"',
      'listening': 'Listening...',
      'say_something': 'Say something...',
      'no_transactions': 'No transactions yet.\nTap + to add your first one!',
      'amount': 'Amount',
      'description': 'Description',
      'example_description': 'e.g. Sold embroidered saree',
      
      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'share': 'Share',
      'download': 'Download',
      'login': 'Login',
      'logout': 'Logout',
      'settings': 'Settings',
      'language': 'Language',
    },
    
    'hi': {
      // Home Screen
      'welcome': 'स्वागत है!',
      'your_business_friend': 'आपका व्यापार मित्र',
      'micromitra': 'माइक्रोमित्र',
      
      // Features
      'pricing_calculator': 'मूल्य निर्धारण',
      'pricing_desc': 'अपने उत्पादों के लिए उचित मूल्य की गणना करें',
      'marketing_tools': 'विपणन उपकरण',
      'marketing_desc': 'तुरंत फ्लायर्स और विज्ञापन बनाएं',
      'finance_tracker': 'वित्त ट्रैकर',
      'finance_desc': 'आय और व्यय को ट्रैक करें',
      'business_tips': 'व्यापार सुझाव',
      'tips_desc': 'व्यापार रणनीतियाँ सीखें',
      
      // Pricing Screen
      'calculate_fair_prices': 'उचित मूल्य की गणना करें',
      'never_undercharge': 'फिर कभी कम कीमत न लें!',
      'material_cost': 'सामग्री लागत',
      'enter_material_cost': '₹ में सामग्री की लागत दर्ज करें',
      'labor_hours': 'काम के घंटे',
      'how_many_hours': 'इसमें कितने घंटे लगे?',
      'calculate_price': 'मूल्य की गणना करें',
      'suggested_price': 'सुझाया गया मूल्य',
      'includes_profit': 'इसमें 40% लाभ शामिल है',
      'pricing_tips': 'मूल्य निर्धारण युक्तियाँ',
      
      // Finance Screen
      'current_balance': 'वर्तमान शेष',
      'income': 'आय',
      'expense': 'व्यय',
      'expenses': 'व्यय',
      'recent_transactions': 'हाल के लेनदेन',
      'add_transaction': 'लेनदेन जोड़ें',
      'try_voice_input': 'आवाज इनपुट आज़माएं',
      'say_example': 'कहें "मैंने आज 200 रुपये कमाए"',
      'listening': 'सुन रहा है...',
      'say_something': 'कुछ कहें...',
      'no_transactions': 'अभी तक कोई लेनदेन नहीं।\nपहला जोड़ने के लिए + दबाएं!',
      'amount': 'राशि',
      'description': 'विवरण',
      'example_description': 'जैसे कि कढ़ाई की साड़ी बेची',
      
      // Common
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'share': 'साझा करें',
      'download': 'डाउनलोड करें',
      'login': 'लॉगिन',
      'logout': 'लॉगआउट',
      'settings': 'सेटिंग्स',
      'language': 'भाषा',
    },
  };

  static String get(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? 
           _translations['en']?[key] ?? 
           key;
  }
}