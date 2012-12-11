package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbcp.ConnectionFactory;
import org.apache.commons.dbcp.DriverManagerConnectionFactory;
import org.apache.commons.dbcp.PoolableConnectionFactory;
import org.apache.commons.dbcp.PoolingDriver;
import org.apache.commons.pool.ObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import protocol.DatabaseProtocol;

/**
 * Initial and manage the connetion pool
 * 
 * @author damon
 * 
 */
class DBConnPool {
	private static final Logger logger = LoggerFactory
			.getLogger(DBConnPool.class);

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

		try {
			// Add JDBC Driver into JVM
			Class.forName(DatabaseProtocol.JDBC_DRIVER_NAME);

			// Create general connection pool
			GenericObjectPool connectionPool = new GenericObjectPool(null);

			// Set the parameters of the connection pool
			connectionPool.setMaxActive(DatabaseProtocol.MAX_ACTIVE_NUM);
			connectionPool.setMaxIdle(DatabaseProtocol.MAX_IDLE_NUM);
			connectionPool.setMaxWait(DatabaseProtocol.MAX_WAIT_NUM);

			// Create the pool factory
			Properties prop = new Properties();

			prop.setProperty("user", DatabaseProtocol.USER_NAME);
			prop.setProperty("password", DatabaseProtocol.PASSWORD);
			prop.setProperty("useUnicode", DatabaseProtocol.USE_UNICODE);
			prop.setProperty("characterEncoding",
					DatabaseProtocol.CHARACTER_ENCODING);
			ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(
					DatabaseProtocol.DB_CONN_URL, prop);

			// Create PoolableConnectionFactory
			new PoolableConnectionFactory(connectionFactory, connectionPool,
					null, null, false, true);

			// Create Connetion Pool Driver
			Class.forName(DatabaseProtocol.POOL_DRIVER_NAME);
			PoolingDriver driver = (PoolingDriver) DriverManager
					.getDriver("jdbc:apache:commons:dbcp:");

			// Regiser the pool to JVM
			driver.registerPool(DatabaseProtocol.POOL_NAME, connectionPool);

		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.info("Create Connetion Pool：{} Successfully",
				DatabaseProtocol.POOL_NAME);
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
			ObjectPool connectionPool = driver
					.getConnectionPool(DatabaseProtocol.POOL_NAME);

			logger.info("NumActive: {}", connectionPool.getNumActive());
			logger.info("NumIdle: ", connectionPool.getNumIdle());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
