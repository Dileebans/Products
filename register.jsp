<%@ page import="java.sql.*, java.io.*" %>
<%
    String message = "";
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    if (username != null && password != null && confirmPassword != null) {
        if (!password.equals(confirmPassword)) {
            message = "Passwords do not match!";
        } else {
            Connection conn = null;
            PreparedStatement stmt = null;

            String url = "jdbc:mysql://localhost:3306/mydb";
            String dbUsername = "root";
            String dbPassword = "";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                // Check if the username already exists
                String checkQuery = "SELECT * FROM user WHERE username = ?";
                stmt = conn.prepareStatement(checkQuery);
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    message = "Username already exists!";
                } else {
                    // Insert new user into the database
                    String query = "INSERT INTO user (username, password) VALUES (?, ?)";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    int result = stmt.executeUpdate();

                    if (result > 0) {
                        message = "Registration successful! You can now login.";
                    } else {
                        message = "Error: Registration failed.";
                    }
                }
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .register-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
        }
        label {
            font-size: 14px;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            font-size: 16px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .message {
            text-align: center;
            color: red;
            font-size: 16px;
        }
        .login-btn {
            margin-top: 20px;
            text-align: center;
        }
        .login-btn a {
            text-decoration: none;
            font-size: 16px;
            color: #4CAF50;
        }
    </style>
</head>
<body>

    <div class="register-container">
        <h2>Register</h2>
        <form method="POST" action="register.jsp">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required>

            <label for="password">Password</label>
            <input type="text" id="password" name="password" required> <!-- Change type to "text" -->

            <label for="confirmPassword">Confirm Password</label>
            <input type="text" id="confirmPassword" name="confirmPassword" required> <!-- Change type to "text" -->

            <button type="submit">Register</button>
        </form>

        <div class="message">
            <%= message %>
        </div>

        <%
            if (message.equals("Registration successful! You can now login.")) {
        %>
        <div class="login-btn">
            <a href="login.jsp"><button>Login</button></a>
        </div>
        <% } %>
    </div>

</body>
</html>
