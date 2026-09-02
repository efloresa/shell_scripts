/*
 * Creado por ERIK.FLORES 
 * Creado el 02/09/2024
 * Creado para monitorear el alert log y enviar mensajes de error al Telegram
 * */

import java.io.File;
import java.io.RandomAccessFile;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class OracleAlertLogMonitor {

    private static final String TELEGRAM_API_URL = "https://api.telegram.org/bot5565295977:AAHS1KW10CMcDuxTVD4olf6Py8xxvrVU9dk/sendMessage";
    private static final String CHAT_ID = "7343413063";
    private static final String ALERT_LOG_PATH = "/u01/app/oracle/diag/rdbms/bdcoreatm/srvbdatm/trace/alert_srvbdatm.log"; // Ruta al alert log
    private static long lastPosition = 0;  // Para llevar el seguimiento de la posición de lectura

    public static void main(String[] args) {
        while (true) {  // Ciclo infinito para monitorear continuamente
            try {
                monitorAlertLog();
                Thread.sleep(5000);  // Revisar el archivo cada 5 segundos
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void monitorAlertLog() throws IOException {
        File logFile = new File(ALERT_LOG_PATH);
        if (!logFile.exists()) {
            System.out.println("Alert log not found!");
            return;
        }

        try (RandomAccessFile file = new RandomAccessFile(logFile, "r")) {
            file.seek(lastPosition);  // Ir a la última posición leída

            String line;
            while ((line = file.readLine()) != null) {
                if (line.contains("ORA-")) {
                    System.out.println("Error detected: " + line);  // Mostrar en consola el error detectado
                    sendTelegramMessage("Oracle Error detected: " + line);
                }
            }

            lastPosition = file.getFilePointer();  // Actualizar la posición al final del archivo
        }
    }

    private static void sendTelegramMessage(String message) throws IOException {
        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
        String urlString = TELEGRAM_API_URL + "?chat_id=" + CHAT_ID + "&text=" + encodedMessage;
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            System.out.println("Message sent successfully.");
        } else {
            System.out.println("Failed to send message. Response code: " + responseCode);
        }
    }
}

