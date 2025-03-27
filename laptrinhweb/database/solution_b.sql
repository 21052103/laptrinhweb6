--truy vấn

-- Câu 1: Liệt kê các hóa đơn của khách hàng, hiển thị mã user, tên user, mã hóa đơn
SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id
FROM users
JOIN orders ON users.id = orders.user_id;

-- Câu 2: Liệt kê số lượng hóa đơn của khách hàng
SELECT users.id AS user_id, users.name AS user_name, COUNT(orders.id) AS total_orders
FROM users
LEFT JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name;

-- Câu 3: Liệt kê thông tin hóa đơn (mã đơn hàng, số sản phẩm)
SELECT orders.id AS order_id, COUNT(order_details.product_id) AS total_products
FROM orders
JOIN order_details ON orders.id = order_details.order_id
GROUP BY orders.id;

-- Câu 4: Liệt kê thông tin mua hàng của người dùng, gộp theo mã đơn hàng
SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id, GROUP_CONCAT(products.name) AS product_names
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_details ON orders.id = order_details.order_id
JOIN products ON order_details.product_id = products.id
GROUP BY users.id, users.name, orders.id;

-- Câu 5: Liệt kê 7 người dùng có số lượng đơn hàng nhiều nhất
SELECT users.id AS user_id, users.name AS user_name, COUNT(orders.id) AS total_orders
FROM users
JOIN orders ON users.id = orders.user_id
GROUP BY users.id, users.name
ORDER BY total_orders DESC
LIMIT 7;

-- Câu 6: Liệt kê 7 người mua sản phẩm có tên "Samsung" hoặc "Apple"
SELECT DISTINCT users.id AS user_id, users.name AS user_name, orders.id AS order_id, products.name AS product_name
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_details ON orders.id = order_details.order_id
JOIN products ON order_details.product_id = products.id
WHERE products.name LIKE '%Samsung%' OR products.name LIKE '%Apple%'
LIMIT 7;

-- Câu 7: Liệt kê danh sách mua hàng của user gồm giá tiền mỗi đơn hàng
SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id, SUM(products.price) AS total_price
FROM users
JOIN orders ON users.id = orders.user_id
JOIN order_details ON orders.id = order_details.order_id
JOIN products ON order_details.product_id = products.id
GROUP BY users.id, users.name, orders.id;

-- Câu 8: Chọn ra 1 đơn hàng có giá tiền lớn nhất của mỗi user
SELECT user_id, user_name, order_id, total_price FROM (
    SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id, SUM(products.price) AS total_price,
    RANK() OVER (PARTITION BY users.id ORDER BY SUM(products.price) DESC) AS rnk
    FROM users
    JOIN orders ON users.id = orders.user_id
    JOIN order_details ON orders.id = order_details.order_id
    JOIN products ON order_details.product_id = products.id
    GROUP BY users.id, users.name, orders.id
) AS ranked_orders WHERE rnk = 1;

-- Câu 9: Chọn ra 1 đơn hàng có giá tiền nhỏ nhất của mỗi user
SELECT user_id, user_name, order_id, total_price FROM (
    SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id, SUM(products.price) AS total_price,
    RANK() OVER (PARTITION BY users.id ORDER BY SUM(products.price) ASC) AS rnk
    FROM users
    JOIN orders ON users.id = orders.user_id
    JOIN order_details ON orders.id = order_details.order_id
    JOIN products ON order_details.product_id = products.id
    GROUP BY users.id, users.name, orders.id
) AS ranked_orders WHERE rnk = 1;

-- Câu 10: Chọn ra 1 đơn hàng có số sản phẩm nhiều nhất của mỗi user
SELECT user_id, user_name, order_id, total_products FROM (
    SELECT users.id AS user_id, users.name AS user_name, orders.id AS order_id, COUNT(order_details.product_id) AS total_products,
    RANK() OVER (PARTITION BY users.id ORDER BY COUNT(order_details.product_id) DESC) AS rnk
    FROM users
    JOIN orders ON users.id = orders.user_id
    JOIN order_details ON orders.id = order_details.order_id
    GROUP BY users.id, users.name, orders.id
) AS ranked_orders WHERE rnk = 1;
