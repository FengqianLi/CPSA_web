package utils;

import java.io.File;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ListFile {
	private ArrayList<String> list = new ArrayList<String>();
	private String rootDir;
	private static final Logger logger = LoggerFactory
			.getLogger(ListFile.class);

	public ListFile(String rootDir) {
		this.rootDir = rootDir;
	}

	public ArrayList<String> getFileList() {
		logger.debug("list: {}", rootDir);
		print(rootDir);
		return list;
	}

	private void print(String rootDir) {
		File mFile = new File(rootDir);
		if (mFile.isDirectory()) {
			list.add(getPath(mFile));
			String[] str = mFile.list();
			for (int i = 0; i < str.length; i++) {
				print(mFile.getPath() + "/" + str[i]);
			}
		} else {
			list.add(getPath(mFile));
		}
	}

	private String getPath(File mFile) {
		String fullPath = mFile.getPath();
		String[] str = fullPath.split("//");
		return str[str.length - 1];
	}
}