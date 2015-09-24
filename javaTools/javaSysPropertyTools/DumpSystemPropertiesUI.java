import java.awt.*;
import javax.swing.*;
import java.util.Properties;
import java.util.Iterator;
import java.util.TreeSet;

public class DumpSystemPropertiesUI extends JPanel {

    JTextArea propertiesTA = new JTextArea(30, 100);

    public DumpSystemPropertiesUI() {
        this.setLayout(new BorderLayout());
        this.add(new JScrollPane(propertiesTA), BorderLayout.CENTER);

		// attach properties to the panel
        Properties p = System.getProperties();
        TreeSet pKeys = new TreeSet(p.keySet());  // TreeSet sorts keys
		Iterator<String> it = pKeys.iterator();

        while(it.hasNext()) {
            String key = it.next();
            propertiesTA.append("" + key + "=" + p.get(key) + "\n");
        }//end while
    }// end constructor

    public static void main(String[] args) {
        JFrame win = new JFrame("a VM's System Properties");
        win.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        win.setContentPane(new DumpSystemPropertiesUI());
        win.pack();
        win.setVisible(true);
    }//end main
}//end DumpSystemPropertiesUI

