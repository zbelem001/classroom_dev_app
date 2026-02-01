plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.docuresume.docuresume_flutter"
    compileSdk = 36
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.docuresume.docuresume_flutter"
        minSdk = flutter.minSdkVersion  // Android 6.0 - Required for file_picker
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        
        // Disable NDK - not needed for this app
        ndk {
            abiFilters.clear()
        }
    }
    
    buildFeatures {
        // Disable native build
        buildConfig = false
    }
    
    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

