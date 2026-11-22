
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map"%>
<%@page import="java.sql.Date"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Products | ExpiryGuard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">✦</div>
            <div><h2>ExpiryGuard</h2><small>Inventory Manager</small></div>
        </div>
        <p class="menu-label">MAIN MENU</p>
        <a class="nav-link" href="index.jsp">⌂ &nbsp; Dashboard</a>
        <a class="nav-link" href="addProduct.jsp">＋ &nbsp; Add Product</a>
        <a class="nav-link active" href="ProductServlet?action=list">▤ &nbsp; View Products</a>
        <a class="nav-link" href="ProductServlet?action=alerts">◷ &nbsp; Expiry Alerts</a>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <span class="eyebrow">INVENTORY / PRODUCTS</span>
                <h1>All Products</h1>
                <p class="muted">View, update or remove inventory records.</p>
            </div>
            <a class="btn btn-primary" href="addProduct.jsp">＋ Add Product</a>
        </header>

        <%
            List<Map<String, Object>> products =
                (List<Map<String, Object>>) request.getAttribute("products");
        %>

        <div class="table-card">
            <div class="table-heading">
                <div>
                    <h2>Product Inventory</h2>
                    <p class="muted">
                        Total records:
                        <strong><%= products == null ? 0 : products.size() %></strong>
                    </p>
                </div>
                <a class="btn btn-secondary" href="ProductServlet?action=alerts">
                    View Expiry Alerts
                </a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Product Name</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Expiry Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (products != null && !products.isEmpty()) {
                        for (Map<String, Object> p : products) {
                            int days = ((Number)p.get("days_left")).intValue();
                    %>
                        <tr>
                            <td>#<%= p.get("id") %></td>
                            <td><strong><%= p.get("product_name") %></strong></td>
                            <td><%= p.get("category") %></td>
                            <td><%= p.get("quantity") %></td>
                            <td><%= p.get("expiry_date") %></td>
                            <td>
                                <% if (days < 0) { %>
                                    <span class="status status-expired">Expired</span>
                                <% } else if (days <= 7) { %>
                                    <span class="status status-warning">
                                        <%= days == 0 ? "Expires today" : "Expiring soon" %>
                                    </span>
                                <% } else { %>
                                    <span class="status status-good">Fresh</span>
                                <% } %>
                            </td>
                            <td class="actions">
                                <a class="btn btn-small btn-edit"
                                   href="ProductServlet?action=edit&id=<%= p.get("id") %>">Edit</a>
                                <form action="ProductServlet" method="post"
                                      class="inline-form"
                                      onsubmit="return confirm('Delete this product?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= p.get("id") %>">
                                    <button class="btn btn-small btn-delete" type="submit">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="7" class="empty-state">
                                <div class="empty-icon">▤</div>
                                <strong>No products found</strong>
                                <p>Add your first product to get started.</p>
                                <a class="btn btn-primary" href="addProduct.jsp">＋ Add Product</a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <footer class="footer">Product Expiry Alert System • Advance Java Mini Project</footer>
    </main>
</div>
</body>
</html>
