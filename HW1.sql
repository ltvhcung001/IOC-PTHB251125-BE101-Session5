CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50)
);

INSERT INTO products (product_id, product_name, category) VALUES
(1, 'Laptop Dell', 'Electronics'),
(2, 'IPhone 15', 'Electronics'),
(3, 'Bàn học gỗ', 'Furniture'),
(4, 'Ghế xoay', 'Furniture');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    total_price INT
);

INSERT INTO orders (order_id, product_id, quantity, total_price) VALUES
(101, 1, 2, 2200),
(102, 2, 3, 3300),
(103, 3, 5, 2500),
(104, 4, 4, 1600),
(105, 1, 1, 1100);

-- 1. Viết truy vấn hiển thị tổng doanh thu (SUM(total_price)) và số lượng sản phẩm bán được (SUM(quantity)) cho từng nhóm danh mục (category)
select p.category, sum(o.total_price) "Tổng doanh thu", sum(o.quantity) as "Tổng số lượng"
from orders o join products p on o.product_id = p.product_id
group by p.category;

-- 2. Chỉ hiển thị những nhóm có tổng doanh thu lớn hơn 2000
select category
from orders o join products p on o.product_id = p.product_id
group by category
having sum(total_price) > 2000;

-- 3. Sắp xếp kết quả theo tổng doanh thu giảm dần
select category
from orders o join products p on o.product_id = p.product_id
group by category
having sum(total_price) > 2000
order by sum(total_price) desc;


