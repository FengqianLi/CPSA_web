package dao;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;

import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Initial and manage the connetion pool
 * 
 * @author damon
 * 
 */
class DBConnPool {
	private static final Logger logger = LoggerFactory
			.getLogger(DBConnPool.class);

	private static Properties prop = new Properties();

	/**
	 * Set up the connection pool in static initialization
	 */
	static {
		setupPool();
	}

	/**
	 * Set up the connection pool
	 */
	private static void setupPool() {
		logger.info("Initializing the Connetion Pool......");

		FileInputStream fis;
		try {
			String path = DBConnPool.class.getClassLoader().getResource("")
					.toURI().getPath();
			fis = new FileInputStream(path + "config.xml");
			prop.loadFromXML(fis);
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		} catch (InvalidPropertiesFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}

		try {
			// Add JDBC Driver into JVM
			Class.forName(prop.getProperty("jdbc_driver_name"));

			// Create general connection pool
			GenericObjectPool connectionPool = new GenericObjectPool(null);

			// Set the parameters of the connection pool
			connectionPool.setMaxActive(Integer.parseInt(prop
					.getProperty("max_active_num")));
			connectionPool.setMaxIdle(Integer.parseInt(prop
					.getProperty("max_idle_num")));
			connectionPool.setMaxWait(Integer.parseInt(prop
					.getProperty("max_wait_num")));

			Properties userProp = new Properties();
			userProp.setProperty("user", prop.getProperty("db_user"));
			userProp.setProperty("password", prop.getProperty("db_password"));
			ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(
					"jdbc:mysql://" + prop.getProperty("database_ip") + ":"
							+ prop.getProperty("database_port") + "/"
							+ prop.getProperty("database_schema"), userProp);

			// Create PoolableConnectionFactory
			new PoolableConnectionFactory(connectionFactory, connectionPool,
					null, null, false, true);

			// Create Connetion Pool Driver
			Class.forName(prop.getProperty("pool_driver_name"));
			PoolingDriver driver = (PoolingDriver) DriverManager
					.getDriver("jdbc:apache:commons:dbcp:");

			// Regiser the pool to JVM
			driver.registerPool("connectPool", connectionPool);

		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Create Connetion Pool：{} Successfully",
				prop.getProperty("pool_name"));
	}

	/**
	 * Get a connection from the connetion pool
	 * 
	 * @param strPoolName
	 * @return a connection
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	static Connection getConnection(String strPoolName) throws SQLException,
			ClassNotFoundException {
		Connection conn = null;
		conn = DriverManager.getConnection("jdbc:apache:commons:dbcp:"
				+ strPoolName);
		return conn;
	}

	/**
	 * Return the connection to the connection pool
	 * 
	 * @param strPoolName
	 */
	static void closePool(String strPoolName) {
		try {
			PoolingDriver driver = (PoolingDriver) DriverManager
					.getDriver("jdbc:apache:commons:dbcp:");
			driver.closePool(strPoolName);
		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.info("Connection Pool：{} closed successfully", strPoolName);
	}

	/**
	 * Print the state of the connection pool/s
	 */
	static void printDriverStats() {
		try {
			PoolingDriver driver = (PoolingDriver) DriverManager
					.getDriver("jdbc:apache:commons:dbcp:");
			ObjectPool connectionPool = driver.getConnectionPool(prop
					.getProperty("pool_name"));

			logger.info("NumActive: {}", connectionPool.getNumActive());
			logger.info("NumIdle: ", connectionPool.getNumIdle());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
