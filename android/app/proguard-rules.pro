# Flutter / Dart
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**

# OkHttp / Retrofit
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Gson / JSON
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# Hive
-keep class **$HiveAdapter { *; }
-keep class * extends hive.HiveObject { *; }

# image_picker / image_cropper
-keep class androidx.lifecycle.DefaultLifecycleObserver

# permission_handler
-keep class com.baseflow.permissionhandler.** { *; }

# in_app_purchase
-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**

# Strip logs in release
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# Keep model classes
-keep class com.photorevive.ai.** { *; }
