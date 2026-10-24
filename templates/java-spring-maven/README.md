# Java: Spring Boot (Maven)

Builds the JAR with Maven, then runs it on a small JRE-only image.

## Requirements

- `pom.xml` and `src/` in the project root
- Java 21 (change both image tags if you use 17)
- The build must produce exactly **one** JAR in `target/`

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t spring-app .
docker run -d --name spring-app -p 8080:8080 spring-app
```

Open http://localhost:8080

## Memory settings

```bash
docker run -d --name spring-app -p 8080:8080 \
  -e JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75" \
  --memory 1g \
  spring-app
```

## Pass a Spring profile

```bash
docker run -d --name spring-app -p 8080:8080 -e SPRING_PROFILES_ACTIVE=prod spring-app
```
