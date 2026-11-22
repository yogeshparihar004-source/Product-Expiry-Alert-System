
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product | ExpiryGuard</title>
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
        <a class="nav-link active" href="addProduct.jsp">＋ &nbsp; Add Product</a>
        <a class="nav-link" href="ProductServlet?action=list">▤ &nbsp; View Products</a>
        <a class="nav-link" href="ProductServlet?action=alerts">◷ &nbsp; Expiry Alerts</a>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div>
                <span class="eyebrow">INVENTORY / NEW RECORD</span>
                <h1>Add New Product</h1>
                <p class="muted">Enter the details below to add a product.</p>
            </div>
            <a class="btn btn-secondary" href="index.jsp">← Dashboard</a>
        </header>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="form-card">
            <div class="form-card-heading">
                <div class="action-icon purple">＋</div>
                <div>
                    <h2>Product Information</h2>
                    <p class="muted">Fields marked * are required.</p>
                </div>
            </div>

            <form action="ProductServlet" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group full-width">
                        <label for="productName">Product Name *</label>
                        <input type="text" id="productName" name="productName"
                               placeholder="e.g. Fresh Milk" maxlength="100"
                               required>
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
                               min="0" placeholder="Enter quantity" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="expiryDate">Expiry Date *</label>
                        <input type="date" id="expiryDate" name="expiryDate"
                               required>
                        <small class="field-help">Select the product's expiry date.</small>
                    </div>
                </div>

                <div class="form-actions">
                    <a class="btn btn-secondary" href="index.jsp">Cancel</a>
                    <button class="btn btn-primary" type="submit">Save Product →</button>
                </div>
            </form>
        </div>

        <footer class="footer">Product Expiry Alert System • Advance Java Mini Project</footer>
    </main>
</div>
</body>
</html>
