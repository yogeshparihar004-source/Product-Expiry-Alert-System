
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Alerts | ExpiryGuard</title>
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
        <a class="nav-link" href="ProductServlet?action=list">▤ &nbsp; View Products</a>
        <a class="nav-link active" href="ProductServlet?action=alerts">◷ &nbsp; Expiry Alerts</a>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <span class="eyebrow">INVENTORY / ALERT CENTER</span>
                <h1>Expiry Alerts</h1>
                <p class="muted">Monitor expired and soon-to-expire products.</p>
            </div>
            <a class="btn btn-secondary" href="ProductServlet?action=list">← All Products</a>
        </header>

        <%
            List<Map<String, Object>> products =
                (List<Map<String, Object>>) request.getAttribute("products");
            int expired = 0;
            int soon = 0;

            if (products != null) {
                for (Map<String, Object> p : products) {
                    int days = ((Number)p.get("days_left")).intValue();
                    if (days < 0) {
                        expired++;
                    } else {
                        soon++;
                    }
                }
            }
        %>

        <section class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon red">!</div>
                <div>
                    <p>Expired Products</p>
                    <h2><%= expired %></h2>
                    <span class="stat-description">Expiry date has passed</span>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">◷</div>
                <div>
                    <p>Expiring Soon</p>
                    <h2><%= soon %></h2>
                    <span class="stat-description">Expiry within 7 days</span>
                </div>
            </div>
        </section>

        <div class="alert alert-warning">
            <strong>Attention:</strong>
            Please review these products and take the necessary action.
        </div>

        <div class="table-card">
            <div class="table-heading">
                <div>
                    <h2>Products Requiring Attention</h2>
                    <p class="muted">Expired items and items expiring within 7 days.</p>
                </div>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Expiry Date</th>
                            <th>Days Remaining</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (products != null && !products.isEmpty()) {
                        for (Map<String, Object> p : products) {
                            int days = ((Number)p.get("days_left")).intValue();
                    %>
                        <tr>
                            <td><strong><%= p.get("product_name") %></strong></td>
                            <td><%= p.get("category") %></td>
                            <td><%= p.get("quantity") %></td>
                            <td><%= p.get("expiry_date") %></td>
                            <td>
                                <% if (days < 0) { %>
                                    <span class="status status-expired">
                                        Expired by <%= Math.abs(days) %> day(s)
                                    </span>
                                <% } else if (days == 0) { %>
                                    <span class="status status-warning">Today</span>
                                <% } else { %>
                                    <span class="status status-warning">
                                        <%= days %> day(s)
                                    </span>
                                <% } %>
                            </td>
                            <td>
                                <% if (days < 0) { %>
                                    <span class="status status-expired">Expired</span>
                                <% } else { %>
                                    <span class="status status-warning">Expiring Soon</span>
                                <% } %>
                            </td>
                            <td>
                                <a class="btn btn-small btn-edit"
                                   href="ProductServlet?action=edit&id=<%= p.get("id") %>">Edit</a>
                            </td>
                        </tr>
                    <%  }
                       } else { %>
                        <tr>
                            <td colspan="7" class="empty-state">
                                <div class="empty-icon">✓</div>
                                <strong>All clear!</strong>
                                <p>No expired or soon-to-expire products found.</p>
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
