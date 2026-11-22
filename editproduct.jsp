
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.Date"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product | ExpiryGuard</title>
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
                <span class="eyebrow">INVENTORY / EDIT RECORD</span>
                <h1>Edit Product</h1>
                <p class="muted">Update the product information below.</p>
            </div>
            <a class="btn btn-secondary" href="ProductServlet?action=list">← Back to Products</a>
        </header>

        <%
            Map<String, Object> product =
                (Map<String, Object>) request.getAttribute("product");
        %>

        <% if (product == null) { %>
            <div class="alert alert-danger">
                Product details nahi mile. Please View Products se Edit par click karein.
            </div>
            <a class="btn btn-primary" href="ProductServlet?action=list">Open Products</a>
        <% } else { %>

        <div class="form-card">
            <div class="form-card-heading">
                <div class="action-icon blue">✎</div>
                <div>
                    <h2>Update Product Information</h2>
                    <p class="muted">Product ID: #<%= product.get("id") %></p>
                </div>
            </div>

            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= product.get("id") %>">

                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="productName">Product Name *</label>
                        <input type="text" id="productName" name="productName"
                               value="<%= product.get("product_name") %>"
                               maxlength="100" required>
                    </div>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category">
                            <option value="General">General</option>
                            <option value="Dairy">Dairy</option>
                            <option value="Food">Food</option>
                            <option value="Bakery">Bakery</option>
                            <option value="Medicine">Medicine</option>
                            <option value="Beverages">Beverages</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="quantity">Quantity *</label>
                        <input type="number" id="quantity" name="quantity"
                               min="0" value="<%= product.get("quantity") %>" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="expiryDate">Expiry Date *</label>
                        <input type="date" id="expiryDate" name="expiryDate"
                               value="<%= product.get("expiry_date") %>" required>
                    </div>
                </div>

                <script>
                    (function () {
                        var category = "<%= product.get("category") %>";
                        var select = document.getElementById("category");
                        for (var i = 0; i < select.options.length; i++) {
                            if (select.options[i].value === category) {
                                select.selectedIndex = i;
                                break;
                            }
                        }
                        if (select.selectedIndex === -1) {
                            select.value = "General";
                        }
                    })();
                </script>

                <div class="form-actions">
                    <a class="btn btn-secondary" href="ProductServlet?action=list">Cancel</a>
                    <button class="btn btn-primary" type="submit">Save Changes ✓</button>
                </div>
            </form>
        </div>

        <% } %>

        <footer class="footer">Product Expiry Alert System • Advance Java Mini Project</footer>
    </main>
</div>
</body>
</html>
