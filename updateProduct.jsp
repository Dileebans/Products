<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Product</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 70%;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #333;
        }

        form {
            margin-bottom: 20px;
        }

        label {
            font-size: 1.2em;
            color: #333;
        }

        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1.1em;
        }

        button {
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            font-size: 1.2em;
            cursor: pointer;
            border-radius: 5px;
            border: none;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #2980b9;
        }

        .message {
            text-align: center;
            font-size: 1.2em;
            margin-top: 30px;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
        }

        .links {
            text-align: center;
            margin-top: 20px;
        }

        .links a {
            text-decoration: none;
            color: #3498db;
            font-size: 1.1em;
            margin: 0 10px;
        }

        .links a:hover {
            color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Update Product</h1>
        <% 
            String url = "jdbc:mysql://localhost:3306/mydb";
            String user = "root";
            String password = "";
            String nameParam = request.getParameter("name");
            String priceParam = request.getParameter("price");
            String quantityParam = request.getParameter("quantity");
            Connection conn = null;
            PreparedStatement pstmt = null;

            if (nameParam != null && priceParam != null && quantityParam != null) {
                try {
                    double price = Double.parseDouble(priceParam);
                    int quantity = Integer.parseInt(quantityParam);
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, password);
                    String query = "UPDATE products SET price = ?, quantity = ? WHERE name = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setDouble(1, price);
                    pstmt.setInt(2, quantity);
                    pstmt.setString(3, nameParam);
                    int rowsAffected = pstmt.executeUpdate();
        %>
                    <div class="message <%= (rowsAffected > 0) ? "success" : "error" %>">
                        <%= (rowsAffected > 0) ? "Product details updated successfully." : "No matching product found to update." %>
                    </div>
                    <div class="links">
                        <a href="productList.jsp"><button>Check Products</button></a>
                        <a href="insert.jsp"><button>Insert Product</button></a>
                    </div>
        <% 
                } catch (Exception e) {
                    out.println("<div class='message error'>An error occurred: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
                }
            } else {
        %>
            <form action="updateProduct.jsp" method="POST">
                <label for="name">Product Name:</label>
                <input type="text" id="name" name="name" required><br><br>
                <label for="price">Product Price:</label>
                <input type="number" id="price" name="price" step="0.01" required><br><br>
                <label for="quantity">Product Quantity:</label>
                <input type="number" id="quantity" name="quantity" required><br><br>
                <button type="submit">Update Product</button>
            </form>
        <% } %>
    </div>
</body>
</html>
