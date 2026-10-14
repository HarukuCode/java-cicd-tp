package fr.tp.demo;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public final class App {
    public static void main(String[] args) throws IOException {
        int port = Integer.parseInt(System.getenv().getOrDefault("PORT", "8080"));
        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", port), 0);
        server.createContext("/", exchange -> {
            String path = exchange.getRequestURI().getPath();
            if (!exchange.getRequestMethod().equals("GET")) {
                respond(exchange, 405, "Méthode non autorisée\n");
            } else if (path.equals("/health")) {
                respond(exchange, 200, "OK\n");
            } else if (path.equals("/")) {
                respond(exchange, 200, Greeting.message());
            } else {
                respond(exchange, 404, "Ressource inconnue\n");
            }
        });
        Runtime.getRuntime().addShutdownHook(new Thread(() -> server.stop(0)));
        server.start();
        System.out.println("Application démarrée sur le port " + port);
    }

    private static void respond(HttpExchange exchange, int status, String text)
            throws IOException {
        byte[] body = text.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=utf-8");
        exchange.sendResponseHeaders(status, body.length);
        try (var output = exchange.getResponseBody()) {
            output.write(body);
        } finally {
            exchange.close();
        }
    }
}
