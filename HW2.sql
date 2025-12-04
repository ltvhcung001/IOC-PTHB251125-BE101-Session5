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

-- 1. Viết truy vấn con (Subquery) để tìm sản phẩm có doanh thu cao nhất trong bảng orders
-- Hiển thị: product_name, total_revenue
select p.product_name, sum(o.total_price) as "total_revenue"
from products p join orders o on p.product_id = o.product_id
group by p.product_name
having sum(o.total_price) >=ALL (
	select sum(o.total_price)
	from products p join orders o on p.product_id = o.product_id
	group by p.product_name
);

-- 2. Viết truy vấn hiển thị tổng doanh thu theo từng nhóm category (dùng JOIN + GROUP BY)
select p.product_name, sum(o.total_price)
from products p join orders o on p.product_id = o.product_id
group by p.product_name;

-- 3. Dùng INTERSECT để tìm ra nhóm category có sản phẩm bán chạy nhất (ở câu 1) cũng nằm trong danh sách 
-- nhóm có tổng doanh thu lớn hơn 3000

select p.category
from products p join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) >=ALL (
	select sum(o.total_price)
	from products p join orders o on p.product_id = o.product_id
	group by p.product_name
)
except
select p.category
from products p join orders o on p.product_id = o.product_id
group by p.category
having sum(o.total_price) <= 3000;




