create table departments(
	dept_id serial primary key,
	dept_name varchar(100)
);

create table employees(
	emp_id serial primary key,
	emp_name varchar(100),
	dept_id int references departments(dept_id),
	salary numeric(10, 2),
	hire_date date
);

create table projects(
	project_id serial primary key,
	project_name varchar(100),
	dept_id int references departments(dept_id)
);

-- 1.ALIAS:
-- Hiển thị danh sách nhân viên gồm: Tên nhân viên, Phòng ban, Lương
-- dùng bí danh bảng ngắn (employees as e,departments as d). 
select e.emp_name "Tên nhân viên", d.dept_name "Phòng ban", e.salary "Lương"
from employees e 
	join departments d on d.dept_id = e.dept_id;

-- 2. Aggregate Functions:
-- Tính:
-- Tổng quỹ lương toàn công ty
-- Mức lương trung bình
-- Lương cao nhất, thấp nhất
-- Số nhân viên
select sum(e.salary) "Tổng quỹ lương toàn công ty", 
	   max(e.salary) "Mức lương cao nhất", 
	   min(e.salary) "Mức lương thấp nhất",
	   avg(e.salary) "Mức lương trung bình",
	   count(e.emp_id) "Số nhân viên"
from employees e 
	join departments d on d.dept_id = e.dept_id;

-- 3. GROUP BY / HAVING:
-- a. Tính mức lương trung bình của từng phòng ban
select d.dept_name, avg(e.salary) "Lương trung bình"
from employees e 
	join departments d on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name;

-- chỉ hiển thị những phòng ban có lương trung bình > 15.000.000
select d.dept_name, avg(e.salary) "Lương trung bình"
from employees e 
	join departments d on d.dept_id = e.dept_id
group by d.dept_id, d.dept_name
having avg(e.salary) > 15000000;

-- 4. JOIN:
-- Liệt kê danh sách dự án (project) cùng với phòng ban phụ trách và nhân viên thuộc phòng ban đó
select p.project_name "Tên dự án", d.dept_name "Phòng ban",  e.emp_name "Tên nhân viên"
from employees e 
	join departments d on d.dept_id = e.dept_id
	join projects p on p.dept_id = d.dept_id;

-- 5. Subquery:
-- Tìm nhân viên có lương cao nhất trong mỗi phòng ban
-- Gợi ý: Subquery lồng trong WHERE salary = (SELECT MAX(...))
select e.emp_name
from employees e 
	join departments d on d.dept_id = e.dept_id
where e.salary = (
	select max(e.salary)
	from employees e 
		join departments d1 on d1.dept_id = e.dept_id
	where e.dept_id = d1.dept_id
);

-- 6. UNION và INTERSECT:
-- UNION: Liệt kê danh sách tất cả các phòng ban có nhân viên hoặc có dự án
select d.dept_name
from employees e 
	join departments d on d.dept_id = e.dept_id
union
select d.dept_name
from projects p
	join departments d on d.dept_id = p.dept_id;
--INTERSECT: Liệt kê các phòng ban vừa có nhân viên vừa có dự án
select d.dept_name
from employees e 
	join departments d on d.dept_id = e.dept_id
intersect
select d.dept_name
from projects p
	join departments d on d.dept_id = p.dept_id;
