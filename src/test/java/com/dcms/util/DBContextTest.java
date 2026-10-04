package com.dcms.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class DBContextTest {

    @Test
    @DisplayName("Verify SQL Server JDBC Driver is present in classpath")
    public void testDriverPresent() {
        assertDoesNotThrow(() -> {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        }, "Microsoft SQL Server driver must be loadable in classpath");
    }

    @Test
    @DisplayName("Verify Safe Close method handles null without throwing NullPointerException")
    public void testSafeCloseHandlesNull() {
        assertDoesNotThrow(() -> {
            DBContext.close(null, null, null);
        }, "DBContext.close() must safely handle null parameters");
    }
}
