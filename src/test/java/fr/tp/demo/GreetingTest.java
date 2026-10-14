package fr.tp.demo;

public final class GreetingTest {
    public static void main(String[] args) {
        String expected = "Bonjour Docker et GitLab CI\n";
        if (!expected.equals(Greeting.message())) {
            throw new AssertionError("Le message retourné ne correspond pas au message attendu.");
        }
        System.out.println("SUCCÈS : le test du message est passé.");
    }
}
