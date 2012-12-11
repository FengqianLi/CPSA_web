package protocol;

public class DatabaseProtocol {
	// Connection pool name
	public static final String POOL_NAME = "connectPool";
	// Database connection Url
	public static final String DB_CONN_URL = "jdbc:mysql://127.0.0.1:3306/huawei";
	// JDBC driver name
	public static final String JDBC_DRIVER_NAME = "com.mysql.jdbc.Driver";
	// Connection pool driver name
	public static final String POOL_DRIVER_NAME = "org.apache.commons.dbcp.PoolingDriver";
	// User name of database
	public static final String USER_NAME = "huawei";
	// Password of database
	public static final String PASSWORD = "huawei";
	// Whether use unicode
	public static final String USE_UNICODE = "true";
	// Database encoding
	public static final String CHARACTER_ENCODING = "UTF-8";
	// The Maximum number of active connection
	public static final int MAX_ACTIVE_NUM = 10;
	// The Maximum number of idle connection
	public static final int MAX_IDLE_NUM = 5;
	// The Maximum number of connetion waiting
	public static final int MAX_WAIT_NUM = 100;
}
