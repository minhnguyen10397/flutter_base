// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.jetbrains.kotlin.android) apply false
}

// Ensure all subprojects have access to repositories
subprojects {
    repositories {
        google()
        mavenCentral()
        mavenLocal()
    }
}
