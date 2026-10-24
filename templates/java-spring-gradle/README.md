# Java: Spring Boot (Gradle)

Builds the JAR with Gradle, then runs it on a small JRE-only image.

## Requirements

- `build.gradle` (or `build.gradle.kts`) in the project root
- Java 21 (change both image tags if you use 17)

To avoid a second "plain" JAR in `build/libs/`, add this to `build.gradle`:

```groovy
jar {
    enabled = false
}
```

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t spring-gradle-app .
docker run -d --name spring-gradle-app -p 8080:8080 spring-gradle-app
```

Open http://localhost:8080
