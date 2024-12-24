<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 80%;
            margin: 20px auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            margin-bottom: 30px;
        }

        label {
            font-size: 1.1em;
            color: #333;
            margin-right: 10px;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
        }

        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            font-size: 1.2em;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #45a049;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .message {
            text-align: center;
            margin-top: 20px;
            font-size: 1.2em;
            color: green;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Insert Products</h1>
        <form method="post">
            <label for="productName">Product Name:</label>
            <input type="text" id="productName" name="productName" required>
            <br><br>
            <label for="productPrice">Product Price:</label>
            <input type="number" id="productPrice" name="productPrice" step="0.01" required>
            <br><br>
            <label for="productQuantity">Product Quantity:</label>
            <input type="number" id="productQuantity" name="productQuantity" required>
            <br><br>
            <button type="submit">Add Product</button>
        </form>

        <%
            String url = "jdbc:mysql://localhost:3306/mydb";
            String user = "root";
            String password = "";

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                conn = DriverManager.getConnection(url, user, password);

                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String productName = request.getParameter("productName");
                    String productPrice = request.getParameter("productPrice");
                    String productQuantity = request.getParameter("productQuantity");

                    if (productName != null && !productName.trim().isEmpty() &&
                        productPrice != null && !productPrice.trim().isEmpty() &&
                        productQuantity != null && !productQuantity.trim().isEmpty()) {

                        String insertQuery = "INSERT INTO products (name, price, quantity) VALUES (?, ?, ?)";
                        pstmt = conn.prepareStatement(insertQuery);
                        pstmt.setString(1, productName);
                        pstmt.setBigDecimal(2, new java.math.BigDecimal(productPrice));
                        pstmt.setInt(3, Integer.parseInt(productQuantity));
                        int rows = pstmt.executeUpdate();

                        if (rows > 0) {
                            out.println("<p class='message'>Product added successfully!</p>");
                        } else {
                            out.println("<p class='error'>Failed to add the product. Please try again.</p>");
                        }
                    }
                }

                out.println("<h2>Product List</h2>");
                out.println("<table>");
                out.println("<tr><th>ID</th><th>Name</th><th>Price</th><th>Quantity</th></tr>");
                String selectQuery = "SELECT * FROM products";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(selectQuery);
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getString("name") + "</td>");
                    out.println("<td>" + rs.getBigDecimal("price") + "</td>");
                    out.println("<td>" + rs.getInt("quantity") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<p class='error'>Error closing database resources: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>
</body>
</html>
