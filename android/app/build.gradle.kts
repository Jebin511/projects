plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // 🔥 Firebase Google Services
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // ⚙️ Flutter plugin (must be last)
}

android {
    namespace = "com.example.cyber_sheild"
    compileSdk = 35 // 🧱 Use highest available while still targeting Android 9

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.cyber_sheild"
        minSdk = 28         // ✅ Minimum SDK set to Android 9
        targetSdk = 28      // 🎯 Targeting Android 9 explicitly
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase Core
    implementation("com.google.firebase:firebase-core:21.1.1")

    // ✅ Firebase Auth
    implementation("com.google.firebase:firebase-auth:23.0.0")

    // ✅ Google Sign-In
    implementation("com.google.android.gms:play-services-auth:21.1.1")

    // ✅ Permission Handler uses AndroidX Activity
    implementation("androidx.activity:activity:1.8.2")

    // ✅ OkHttp for HTTP requests
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
}