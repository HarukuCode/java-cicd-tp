FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /build
COPY src/main/java/ ./src/
RUN mkdir -p classes \
    && javac --release 21 -encoding UTF-8 -d classes src/fr/tp/demo/*.java \
    && jar --create --file app.jar --main-class fr.tp.demo.App -C classes .

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S app && adduser -S -G app app
COPY --from=builder --chown=app:app /build/app.jar /app/app.jar
ENV PORT=8080
USER app
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
