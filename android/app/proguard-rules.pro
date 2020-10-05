#Flutter Wrapper
# 保持哪些类不被混淆
-dontwarn io.flutter.**
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# 保持自己定义的类不被混淆
#-keep class com.wuiaolong.flutter_andblog.**  { *; }