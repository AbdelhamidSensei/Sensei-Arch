# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**

# Hive
-keep class **$HiveAdapter { *; }
-keep class * extends hive.HiveObject { *; }

# Geolocator / permission_handler
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# flutter_map
-dontwarn com.google.protobuf.**

# Reflection / annotations
-keepattributes Signature
-keepattributes *Annotation*

# Strip release logs
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}

# Keep our entities (Hive + freezed-generated)
-keep class com.abdelhamidsensei.metrogo.** { *; }
