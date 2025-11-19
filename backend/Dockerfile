# Dockerfile
# 1단계: 빌드 환경 (Java 17 사용 가정)
FROM eclipse-temurin:17-jdk-focal as builder
WORKDIR /app
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

# 2단계: 실행 환경 (JRE 사용)
FROM eclipse-temurin:17-jre-focal
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]