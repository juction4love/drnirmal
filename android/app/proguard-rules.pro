
# =========================
# GENERAL OPTIMIZATION
# =========================
-dontwarn
-optimizationpasses 5
-overloadaggressively
-allowaccessmodification

# =========================
# LOG REMOVAL (PRODUCTION)
# =========================
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# =========================
# KOTLIN
# =========================
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }

# =========================
# MVVM (VIEWMODEL)
# =========================
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keep class * extends androidx.lifecycle.AndroidViewModel { *; }

# =========================
# ROOM DATABASE
# =========================
-keep class androidx.room.** { *; }
-keep @androidx.room.Entity class * { *; }
-keep @androidx.room.Dao class * { *; }

# =========================
# RETROFIT / NETWORK
# =========================
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keep interface retrofit2.* { *; }

# =========================
# OKHTTP
# =========================
-keep class okhttp3.** { *; }

# =========================
# GSON / JSON
# =========================
-keep class com.google.gson.** { *; }
-keep class * { @com.google.gson.annotations.SerializedName <fields>; }

# =========================
# ENCRYPTION (VERY IMPORTANT - DO NOT OBFUSCATE)
# =========================
-keep class * extends javax.crypto.Cipher { *; }
-keep class *EncryptionService* { *; }

# =========================
# ANXIETY MODULE (CUSTOM)
# =========================
-keep class *AnxietyEntry* { *; }
-keep class *AnxietyRepository* { *; }
-keep class *AnxietyViewModel* { *; }

# =========================
# FLUTTER (IF USED)
# =========================
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# =========================
# SAFETY FINAL
# =========================
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-dontwarn javax.annotation.**