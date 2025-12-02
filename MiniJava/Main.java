import java.io.*;
import java_cup.runtime.Symbol;

public class Main {
    public static void main(String[] args) {
        try {
            // Verifica se o usuário passou o arquivo de teste
            if (args.length == 0) {
                System.out.println("Uso: java Main <arquivo_teste>");
                return;
            }

            System.out.println("Iniciando analise do arquivo: " + args[0]);

            // 1. Cria o Scanner (Léxico) lendo do arquivo
            MiniJavaScanner scanner = new MiniJavaScanner(new FileReader(args[0]));

            // 2. Cria o Parser (Sintático) passando o Scanner
            MiniJavaParser parser = new MiniJavaParser(scanner);

            // 3. Inicia a análise
            Symbol result = parser.parse();

            System.out.println("-----------------------------------------");
            System.out.println("Sucesso! O codigo foi aceito sintaticamente.");
            System.out.println("-----------------------------------------");

        } catch (Exception e) {
            System.out.println("-----------------------------------------");
            System.err.println("Erro durante a analise:");
            e.printStackTrace();
            System.out.println("-----------------------------------------");
        }
    }
}