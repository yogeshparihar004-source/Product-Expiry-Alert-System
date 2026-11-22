
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Expiry Alert System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">✦</div>
            <div>
                <h2>ExpiryGuard</h2>
                <small>Inventory Manager</small>
            </div>
        </div>

        <p class="menu-label">MAIN MENU</p>
        <a class="nav-link active" href="index.jsp">⌂ &nbsp; Dashboard</a>
        <a class="nav-link" href="addProduct.jsp">＋ &nbsp; Add Product</a>
        <a class="nav-link" href="ProductServlet?action=list">▤ &nbsp; View Products</a>
        <a class="nav-link" href="ProductServlet?action=alerts">◷ &nbsp; Expiry Alerts</a>

        <div class="sidebar-note">
            <span>✦ Smart Inventory</span>
            <p>Track products. Reduce waste. Stay organized.</p>
        </div>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <span class="eyebrow">INVENTORY MANAGEMENT</span>
                <h1>Dashboard</h1>
                <p class="muted">Welcome! Manage your products in one place.</p>
            </div>
            <a class="btn btn-primary" href="addProduct.jsp">＋ Add New Product</a>
        </header>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <strong>Error:</strong>
                <%= request.getAttribute("errorMessage") %>
                <p>MySQL service, database name, table columns aur JDBC driver check karein.</p>
            </div>
        <% } %>

        <section class="welcome-banner">
            <div>
                <span class="banner-tag">SMART INVENTORY SYSTEM</span>
                <h2>Never miss an expiry date.</h2>
                <p>Keep your inventory organized and identify expired or soon-to-expire products.</p>
                <a class="btn btn-light" href="ProductServlet?action=alerts">
                    Check Expiry Alerts →
                </a>
            </div>
            <div class="banner-symbol">◷</div>
        </section>

        <section class="section-heading">
            <div>
                <h2>Quick Actions</h2>
                <p class="muted">Choose what you want to do.</p>
            </div>
        </section>

        <section class="action-grid">
            <a class="action-card" href="addProduct.jsp">
                <div class="action-icon purple">＋</div>
                <h3>Add Product</h3>
                <p>Save a new product and its expiry date.</p>
                <span class="card-link">Add a product →</span>
            </a>

            <a class="action-card" href="ProductServlet?action=list">
                <div class="action-icon blue">▤</div>
                <h3>View Products</h3>
                <p>See your complete inventory and manage records.</p>
                <span class="card-link">Open inventory →</span>
            </a>

            <a class="action-card" href="ProductServlet?action=alerts">
                <div class="action-icon orange">◷</div>
                <h3>Expiry Alerts</h3>
                <p>Check expired products and those expiring within 7 days.</p>
                <span class="card-link">View alerts →</span>
            </a>
        </section>

        <section class="info-panel">
            <div class="info-icon">✓</div>
            <div>
                <h3>Simple. Organized. Reliable.</h3>
                <p>Product information is stored in your MySQL database.</p>
            </div>
        </section>

        <footer class="footer">
            Product Expiry Alert System <span>•</span> Advance Java Mini Project
        </footer>
    </main>
</div>
</body>
</html>
