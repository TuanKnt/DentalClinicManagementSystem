package com.dcms.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBContext provides database connection utilities for Microsoft SQL Server.
 * Configured via db.properties in resources with safe fallback.
 */
public class DBContext {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());
    private static final Properties props = new Properties();

    static {
        try (InputStream input = DBContext.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                LOGGER.warning("db.properties not found in classpath, using fallback defaults");
            }
            String driver = props.getProperty("db.driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Class.forName(driver);
        } catch (IOException | ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "Failed to initialize DB driver or load db.properties", ex);
        }
    }

    /**
     * Get a new Connection to Microsoft SQL Server.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        String url = props.getProperty("db.url", "jdbc:sqlserver://localhost:1434;databaseName=DCMS_DB;encrypt=true;trustServerCertificate=true;sendTimeAsDatetime=false");
        String user = props.getProperty("db.user", "sa");
        String pass = props.getProperty("db.password", "123456");
        return DriverManager.getConnection(url, user, pass);
    }


    /**
     * Safely closes JDBC resources to prevent memory and connection leaks.
     */
    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing ResultSet", ex);
            }
        }
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing PreparedStatement", ex);
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing Connection", ex);
            }
        }
    }
}
