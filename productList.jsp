<%@ page import="java.sql.*" %>

<%
    String url = "jdbc:mysql://localhost:3306/mydb";
    String user = "root";
    String password = "";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        String query = "SELECT * FROM products";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product List</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f4f4f4;
        }
        h1 {
            text-align: center;
            margin-top: 20px;
        }
        .buttons {
            text-align: center;
            margin: 20px;
        }
        .buttons a {
            text-decoration: none;
            margin: 0 10px;
        }
        button {
            padding: 8px 16px;
            font-size: 14px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }
        .remove-btn {
            background-color: #f44336;
            color: white;
        }
        .update-btn {
            background-color: #008CBA;
            color: white;
        }
        button:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <h1>Product List</h1>
    <table>
        <tr>
            <th>Product Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Amount</th>
            <th>Actions</th>
        </tr>
        <%
            while (rs.next()) {
                String name = rs.getString("name");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                int amount = (int) (price * quantity);
        %>
        <tr>
            <td><%= name %></td>
            <td><%= price %></td>
            <td><%= quantity %></td>
            <td><%= amount %></td>
            <td>
                <a href="deleteProduct.jsp?name=<%= name %>">
                    <button class="remove-btn">Remove Product</button>
                </a>
                <a href="updateProduct.jsp?id=<%= rs.getInt("id") %>">
                    <button class="update-btn">Update Product</button>
                </a>
            </td>
        </tr>
        <% } %>
    </table>

    <div class="buttons">
        <a href="inserts.jsp"><button>Insert Product</button></a>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3 style='color:red;'>An error occurred while fetching the product list.</h3>");
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
