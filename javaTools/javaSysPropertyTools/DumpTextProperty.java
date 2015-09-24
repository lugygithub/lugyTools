// dump java virtual machine system properties

import java.util.Properties;;
import java.util.Enumeration;;

public class DumpTextProperty {
	public static void main(String[] args) {
		Properties p = System.getProperties();
		Enumeration keys = p.keys();

		while (keys.hasMoreElements()) {
			  String key = (String)keys.nextElement();
			  String value = (String)p.get(key);
			  key = "\033[01;34m" + key + "\033[00m";
			  System.out.println(key + ": " + value);
		}//end while

	}//end main()
}//end class dumpProperty

