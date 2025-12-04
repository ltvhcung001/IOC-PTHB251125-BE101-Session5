CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO customers (customer_id, customer_name, city) VALUES
(1, 'Nguyễn Văn A', 'Hà Nội'),
(2, 'Trần Thị B', 'Đà Nẵng'),
(3, 'Lê Văn C', 'Hồ Chí Minh'),
(4, 'Phạm Thị D', 'Hà Nội');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_price INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO orders (order_id, customer_id, order_date, total_price) VALUES
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-05', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO order_items (item_id, order_id, product_id, quantity, price) VALUES
(1, 101, 1, 2, 1500),
(2, 102, 2, 1, 1500),
(3, 103, 3, 5, 500),
(4, 104, 2, 4, 1000);

-- 1. Viết truy vấn hiển thị tổng doanh thu và tổng số đơn hàng của mỗi khách hàng:
-- Chỉ hiển thị khách hàng có tổng doanh thu > 2000
-- Dùng ALIAS: total_revenue và order_count

select c.customer_id, c.customer_name, 
	   sum(ot.quantity * ot.price) as "total_revenue", count(ot.order_id) as "order_count"
from order_items ot 
	join orders o on o.order_id = ot.order_id 
	join customers c on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(ot.quantity * ot.price) > 2000;

-- 2. Viết truy vấn con (Subquery) để tìm doanh thu trung bình của tất cả khách hàng
-- Sau đó hiển thị những khách hàng có doanh thu lớn hơn mức trung bình đó
select c.customer_id, c.customer_name
from order_items ot
	join orders o on o.order_id = ot.order_id 
	join customers c on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(ot.quantity * ot.price) > (select avg(ot.quantity * ot.price) from order_items ot);

-- 3. Dùng HAVING + GROUP BY để lọc ra thành phố có tổng doanh thu cao nhất
select c.city, sum(ot.price * ot.quantity)
from order_items ot
	join orders o on o.order_id = ot.order_id 
	join customers c on c.customer_id = o.customer_id
group by c.city
having sum(ot.price * ot.quantity) >=ALL (
	select sum(ot.price * ot.quantity)
	from order_items ot
		join orders o on o.order_id = ot.order_id 
		join customers c on c.customer_id = o.customer_id
	group by c.city
);

-- 4. (Mở rộng) Hãy dùng INNER JOIN giữa customers, orders, order_items để hiển thị chi tiết:
-- Tên khách hàng, tên thành phố, tổng sản phẩm đã mua, tổng chi tiêu

select c.customer_name "Tên khách hàng", c.city "Thành phố",
	count(ot.product_id) "Tổng sản phẩm đã mua",
	sum(ot.price * ot.quantity) "Tổng chi tiêu"
from order_items ot
	join orders o on o.order_id = ot.order_id 
	join customers c on c.customer_id = o.customer_id
group by c.customer_name, c.city;
