package utils;

import java.io.IOException;

public class Executor {

	public static void execute(int sId) {
		try {
			String []args = {String.valueOf(sId)};
			Process proc = Runtime.getRuntime().exec("ls", args);
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
		// TODO Auto-generated method stub

	}

}
