
package com.expiryalert.util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private String text(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private int positiveInt(String value) {
        int number = Integer.parseInt(value);
        if (number < 0) {
            throw new IllegalArgumentException("Quantity negative nahi ho sakti.");
        }
        return number;
    }

    private void redirect(HttpServletRequest request,
                          HttpServletResponse response,
                          String page) throws IOException {
        response.sendRedirect(request.getContextPath() + "/" + page);
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    private List<Map<String, Object>> getProducts(boolean alerts)
            throws SQLException {

        List<Map<String, Object>> products =
                new ArrayList<Map<String, Object>>();

        String sql = "SELECT id, product_name, category, quantity, " +
                     "expiry_date, DATEDIFF(expiry_date, CURDATE()) AS days_left " +
                     "FROM products ";

        if (alerts) {
            sql += "WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) ";
        }

        sql += "ORDER BY expiry_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> product =
                        new HashMap<String, Object>();

                product.put("id", rs.getInt("id"));
                product.put("product_name", rs.getString("product_name"));
                product.put("category", rs.getString("category"));
                product.put("quantity", rs.getInt("quantity"));
                product.put("expiry_date", rs.getDate("expiry_date"));
                product.put("days_left", rs.getInt("days_left"));

                products.add(product);
            }
        }

        return products;
    }

    private void openProducts(HttpServletRequest request,
                              HttpServletResponse response,
                              boolean alerts)
            throws ServletException, IOException {

        try {
            List<Map<String, Object>> products = getProducts(alerts);

            request.setAttribute("products", products);
            request.setAttribute("pageTitle",
                    alerts ? "Expiry Alerts" : "All Products");

            String page = alerts ? "/alerts.jsp" : "/products.jsp";
            request.getRequestDispatcher(page).forward(request, response);

        } catch (SQLException e) {
            showError(request, response,
                    "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = text(request, "action");

        if (action.length() == 0) {
            action = "list";
        }

        if ("list".equals(action)) {
            openProducts(request, response, false);
            return;
        }

        if ("alerts".equals(action)) {
            openProducts(request, response, true);
            return;
        }

        if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(text(request, "id"));

                String sql = "SELECT id, product_name, category, quantity, " +
                             "expiry_date FROM products WHERE id = ?";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setInt(1, id);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            Map<String, Object> product =
                                    new HashMap<String, Object>();

                            product.put("id", rs.getInt("id"));
                            product.put("product_name",
                                    rs.getString("product_name"));
                            product.put("category",
                                    rs.getString("category"));
                            product.put("quantity", rs.getInt("quantity"));
                            product.put("expiry_date",
                                    rs.getDate("expiry_date"));

                            request.setAttribute("product", product);
                            request.getRequestDispatcher(
                                    "/editproduct.jsp").forward(request, response);
                        } else {
                            redirect(request, response, "products.jsp");
                        }
                    }
                }
            } catch (NumberFormatException e) {
                redirect(request, response, "products.jsp");
            } catch (SQLException e) {
                showError(request, response,
                        "Edit error: " + e.getMessage());
            }
            return;
        }

        redirect(request, response, "index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = text(request, "action");

        try {
            if ("add".equals(action)) {
                String name = text(request, "productName");
                String category = text(request, "category");
                int quantity = positiveInt(text(request, "quantity"));
                Date expiryDate = Date.valueOf(text(request, "expiryDate"));

                if (name.length() == 0) {
                    throw new IllegalArgumentException(
                            "Product name required hai.");
                }

                if (category.length() == 0) {
                    category = "General";
                }

                String sql = "INSERT INTO products " +
                        "(product_name, category, quantity, expiry_date) " +
                        "VALUES (?, ?, ?, ?)";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setString(1, name);
                    ps.setString(2, category);
                    ps.setInt(3, quantity);
                    ps.setDate(4, expiryDate);
                    ps.executeUpdate();
                }

                redirect(request, response, "ProductServlet?action=list");
                return;
            }

            if ("update".equals(action)) {
                int id = Integer.parseInt(text(request, "id"));
                String name = text(request, "productName");
                String category = text(request, "category");
                int quantity = positiveInt(text(request, "quantity"));
                Date expiryDate = Date.valueOf(text(request, "expiryDate"));

                if (name.length() == 0) {
                    throw new IllegalArgumentException(
                            "Product name required hai.");
                }

                if (category.length() == 0) {
                    category = "General";
                }

                String sql = "UPDATE products SET product_name=?, category=?, " +
                        "quantity=?, expiry_date=? WHERE id=?";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setString(1, name);
                    ps.setString(2, category);
                    ps.setInt(3, quantity);
                    ps.setDate(4, expiryDate);
                    ps.setInt(5, id);

                    int updated = ps.executeUpdate();

                    if (updated == 0) {
                        throw new SQLException("Product ID nahi mila.");
                    }
                }

                redirect(request, response, "ProductServlet?action=list");
                return;
            }

            if ("delete".equals(action)) {
                int id = Integer.parseInt(text(request, "id"));

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                             "DELETE FROM products WHERE id = ?")) {

                    ps.setInt(1, id);
                    ps.executeUpdate();
                }

                redirect(request, response, "ProductServlet?action=list");
                return;
            }

            redirect(request, response, "index.jsp");

        } catch (IllegalArgumentException e) {
            showError(request, response,
                    "Invalid input: " + e.getMessage());
        } catch (SQLException e) {
            showError(request, response,
                    "Database error: " + e.getMessage());
        }
    }
}
