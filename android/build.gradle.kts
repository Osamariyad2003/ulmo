buildscript {
    extra.apply {
        set("kotlin_version", "1.9.22")
        set("compileSdkVersion", 35)
        set("targetSdkVersion", 34)
        set("minSdkVersion", 23)
    }

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.2.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${project.extra["kotlin_version"]}")
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = File("../build")

subprojects {
    project.buildDir = File("${rootProject.buildDir}/${project.name}")
    project.evaluationDependsOn(":app")

   
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
