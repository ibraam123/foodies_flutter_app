# 🍽️ Foodies – Weekly Meal Planner App

**Foodies** is a Flutter mobile app designed to help users plan their weekly meals with ease. It allows users to explore meals by category, ingredient, and country, and to save favorites for offline viewing. With Firebase Authentication and Firestore, users can securely sync their meal plans and preferences across devices.

---

## 📝 Brief Description

This Android mobile application helps users plan their weekly meals. Users can:
- View a random "Meal of the Day"
- Browse meals by country, ingredient, or category
- Save favorite meals (available offline using Hive)
- Plan meals for each day of the week
- Sync data online using Firebase
- Log in via Firebase Authentication or use the app as a guest

🔗 API used: [TheMealDB API](https://themealdb.com/api.php)

---

## 🚀 Project Features

- 🍱 **Meal of the Day**: View an inspirational random meal.
- 🔍 **Meal Search**: Search meals based on country, ingredient, or category.
- 📚 **Categories & Countries**: View meals by cuisine and type.
- ❤️ **Favorites**: Add/remove meals to favorites (stored locally with Hive – no Firebase here).
- 🗓️ **Weekly Meal Plan**: Add meals for each day of the current week.
- 🔄 **Data Sync**: Sync and backup data using Firebase Firestore.
- 📶 **Offline Mode**: Access saved favorites and weekly plans even without internet.
  
---

## 🔐 Authentication

- ✅ Simple email/password login and registration using Firebase Authentication.
- ☁️ Once logged in, data is backed up and restored from Firestore.

---

## 🛠️ Tech Stack

| Tech               | Purpose                                      |
|--------------------|----------------------------------------------|
| **Flutter**         | UI & Logic                                   |
| **Hive**            | Local storage for favorite meals             |
| **http**            | Fetching data from TheMealDB API            |
| **Firebase Auth**   | User Authentication                         |
| **Firebase Firestore** | Data sync and backup                   |
| **TheMealDB API**   | Meal data provider ([API Link](https://themealdb.com/api.php)) |

---

## 📸 Screenshots

![Foodies  - mockup](https://github.com/user-attachments/assets/0439905b-f653-4b30-9c94-28127d048c44)


---

## 📦 Installation

1. Clone the repository  
2. Run `flutter pub get`  
3. Setup Firebase and add your `google-services.json`  
4. Run the app with `flutter run`

---

## 🧠 Future Improvements

- Add user notifications for meal times.
- Implement meal suggestions based on user preferences.
- Enhance UI/UX with animations and theme options.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

