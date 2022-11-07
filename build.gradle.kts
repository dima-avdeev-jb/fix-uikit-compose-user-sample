plugins {
    //trick: for the same plugin versions in all sub-modules
    id("com.android.application").version("7.3.0").apply(false)
    id("com.android.library").version("7.3.0").apply(false)
    kotlin("android").version("1.7.10").apply(false)
    kotlin("multiplatform").version("1.7.10").apply(false)
}

buildscript {
    repositories {
        mavenLocal()
        mavenCentral()
        google()
        gradlePluginPortal()
        jetbrainsComposeDev()
    }
    dependencies {
        classpath(deps.kotlinGradlePlugin)
        classpath(deps.androidGradlePlugin)
    }
}

allprojects {
    repositories {
        mavenLocal()
        mavenCentral()
        google()
        jetbrainsComposeDev()
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
