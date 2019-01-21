
This plugin generate an image that display a math operation between two numbers using Java  code so the advantage of this plugin is that you don’t need any web service or Internet.</br>
In this plugin you can use text instead of  image that is not recommended.
Unfortunately this version doesn’t work in Oracle Database 12C that I hope this problem will be resolved in future versions.
Before install this plugin do below steps:
First, create below function in your schema:
CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED CAPTCHA
   AS import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.Random;
import java.awt.*;
public class CreateCaptcha {
    public static String generateCaptcha(String text) {
         Random rnd = new Random();
        int width = 80;
        int height = 30;
        BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2D = img.createGraphics();
        g2D.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS, RenderingHints.VALUE_FRACTIONALMETRICS_ON);
        g2D.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g2D.setFont(new Font("Arial", Font.BOLD, 18));
        g2D.setColor(Color.WHITE);
        g2D.fillRect(0, 0, width, height);
      for (int i=0; i<rnd.nextInt(2)+4;i++){
               g2D.setColor( new Color(rnd.nextInt(255), rnd.nextInt(255), rnd.nextInt(255)));
               g2D.drawLine(rnd.nextInt(10), rnd.nextInt(height), rnd.nextInt(width), rnd.nextInt(height));
           }
        g2D.setColor(Color.BLUE);
        g2D.drawString(text, 10, 20);
       g2D.dispose();
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            ImageIO.write(img, "png", baos);            
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
           String data = javax.xml.bind.DatatypeConverter.printBase64Binary( baos.toByteArray());
          return "data:image/png;base64," + data;
    }
};

And then create below function:
 CREATE OR REPLACE FUNCTION FN_GETBASE64 (str IN VARCHAR2)
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'CreateCaptcha.generateCaptcha(java.lang.String) return java.lang.String';
