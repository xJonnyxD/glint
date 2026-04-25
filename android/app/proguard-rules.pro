# Flutter / Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Supabase / Realtime
-keep class io.supabase.** { *; }
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Drift SQLite
-keep class com.almightyalpaca.jetbrains.plugins.discord.app.data.rpc.** { *; }
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Awesome Notifications
-keep class me.carda.awesome_notifications.** { *; }
-dontwarn me.carda.awesome_notifications.**

# Hive
-keep class hive.** { *; }
-keep @hive.HiveType class * { *; }

# Kotlin
-keep class kotlin.** { *; }
-dontwarn kotlin.**

# Google Sign In
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Crash reporting - mantener stack traces legibles
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
