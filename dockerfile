FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

RUN jar xf target/apirest-0.0.1-SNAPSHOT.jar

RUN jdeps --ignore-missing-deps -q \
    --recursive \
    --multi-release 21 \
    --print-module-deps \
    --class-path 'BOOT-INF/lib/*' \
    target/apirest-0.0.1-SNAPSHOT.jar > deps.info

RUN jlink \
    --add-modules $(cat deps.info) \
    --strip-debug \
    --compress=2 \
    --no-header-files \
    --no-man-pages \
    --output /custom-jre

FROM gcr.io/distroless/base-debian12

ENV JAVA_HOME=/opt/java/jre
ENV PATH="$JAVA_HOME/bin:$PATH"

COPY --from=build /custom-jre $JAVA_HOME
COPY --from=build /app/target/apirest-0.0.1-SNAPSHOT.jar /app/

WORKDIR /app

ENTRYPOINT ["java", "-jar", "apirest-0.0.1-SNAPSHOT.jar"]
