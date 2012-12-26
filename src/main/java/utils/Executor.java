package utils;

import java.io.IOException;

import org.slf4j.LoggerFactory;

import protocol.PathProtocol;

import ch.qos.logback.classic.Logger;

public class Executor {
	private final static Logger logger = (Logger) LoggerFactory
			.getLogger("Executor");

	public static void execute(int sId) {
		String []cmd = {"/bin/sh", "-c",  PathProtocol.RUNPATH + " " + sId};
		logger.debug(PathProtocol.RUNPATH + " " + sId);
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
