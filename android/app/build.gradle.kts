plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.changeme.app.changeme"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.changeme.app.changeme"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "environment"
    
    productFlavors {
        create("development") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            buildConfigField("String", "ENVIRONMENT", "\"development\"")
            buildConfigField("String", "BASE_URL", "\"https://dev-api.example.com\"")
            buildConfigField("String", "API_KEY", "\"dev-api-key\"")
            buildConfigField("boolean", "DEBUG_MODE", "true")
            buildConfigField("boolean", "ENABLE_ANALYTICS", "false")
        }
        
        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            buildConfigField("String", "ENVIRONMENT", "\"staging\"")
            buildConfigField("String", "BASE_URL", "\"https://staging-api.example.com\"")
            buildConfigField("String", "API_KEY", "\"staging-api-key\"")
            buildConfigField("boolean", "DEBUG_MODE", "false")
            buildConfigField("boolean", "ENABLE_ANALYTICS", "true")
        }
        
        create("production") {
            dimension = "environment"
            buildConfigField("String", "ENVIRONMENT", "\"production\"")
            buildConfigField("String", "BASE_URL", "\"https://api.example.com\"")
            buildConfigField("String", "API_KEY", "\"prod-api-key\"")
            buildConfigField("boolean", "DEBUG_MODE", "false")
            buildConfigField("boolean", "ENABLE_ANALYTICS", "true")
        }
    }

    buildTypes {
        debug {
            debuggable = true
            minifyEnabled = false
            shrinkResources = false
        }
        
        release {
            debuggable = false
            minifyEnabled = true
            shrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
