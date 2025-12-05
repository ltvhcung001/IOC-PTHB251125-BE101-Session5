create table students(
	student_id serial primary key,
	full_name varchar(100),
	major varchar(50)
);

create table courses(
	course_id serial primary key,
	course_name varchar(100),
	credit int
);

create table enrollments(
	student_id int references students(student_id),
	course_id int references courses(course_id),
	score numeric(5, 2)
);


-- 1. ALIAS:
-- Liệt kê danh sách sinh viên cùng tên môn học và điểm
-- dùng bí danh bảng ngắn (vd. s, c, e) và bí danh cột như Tên sinh viên, Môn học, Điểm
select s.full_name "Tên sinh viên", c.course_name "Môn học", e.score "Điểm"
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id;

-- 2. Aggregate Functions:
-- Tính cho từng sinh viên:
-- Điểm trung bình
-- Điểm cao nhất
-- Điểm thấp nhất
select s.full_name "Tên sinh viên", max(e.score) "Điểm cao nhất", min(e.score) "Điểm thấp nhất", avg(e.score) "Điểm trung bình"
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
group by s.full_name;

-- 3. GROUP BY / HAVING:
-- Tìm ngành học (major) có điểm trung bình cao hơn 7.5
select c.course_name 
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
group by c.course_name
having avg(e.score) > 7.5;

-- 4. JOIN: Liệt kê tất cả sinh viên, môn học, số tín chỉ và điểm (JOIN 3 bảng)
select s.full_name "Tên sinh viên", c.course_name "Môn học", c.credit "Số tín chỉ", e.score "Điểm"
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id;
	
-- 5. Subquery:
-- Tìm sinh viên có điểm trung bình cao hơn điểm trung bình toàn trường
-- Gợi ý: dùng AVG(score) trong subquery
select s.full_name
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
group by s.full_name
having avg(e.score) > (
	select avg(e.score)
	from enrollments e
);


-- 6. UNION và INTERSECT:
-- UNION: Danh sách sinh viên có điểm >= 9 hoặc đã học ít nhất một môn 

select s.full_name
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
where e.score >= 9
union 
select s.full_name
from students s 
	join enrollments e on e.student_id = s.student_id;

-- INTERSECT: Danh sách sinh viên thỏa cả hai điều kiện trên
select s.full_name
from students s 
	join enrollments e on e.student_id = s.student_id
	join courses c on c.course_id = e.course_id
where e.score >= 9;

