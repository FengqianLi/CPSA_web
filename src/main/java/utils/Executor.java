package utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;

import org.slf4j.LoggerFactory;

import ch.qos.logback.classic.Logger;

public class Executor {
	private final static Logger logger = (Logger) LoggerFactory
			.getLogger("Executor");

	public static void execute(int sId) {

		Properties pathProp = new Properties();
		FileInputStream pathFis;
		try {
			String path = MailTo.class.getClassLoader().getResource("").toURI()
					.getPath();
			pathFis = new FileInputStream(path + "config.xml");
			pathProp.loadFromXML(pathFis);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (InvalidPropertiesFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}

		String[] cmd = { "/bin/sh", "-c",
				pathProp.getProperty("run_path") + " " + sId };
		logger.debug(pathProp.getProperty("run_path") + " " + sId);
		try {
			Process proc = Runtime.getRuntime().exec(cmd);
			proc.waitFor();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {

	}

}
