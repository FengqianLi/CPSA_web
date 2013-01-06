package utils;

import java.io.IOException;

import org.slf4j.LoggerFactory;

import protocol.Config;

import ch.qos.logback.classic.Logger;

public class Executor {
	private final static Logger logger = (Logger) LoggerFactory
			.getLogger("Executor");

	public static void execute(int sId) {

		String[] cmd = { "/bin/sh", "-c",
				Config.prop.getProperty("run_path") + " " + sId };
		logger.debug(Config.prop.getProperty("run_path") + " " + sId);
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
