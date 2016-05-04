# Diagram: https://gist.github.com/JoshCheek/e60015c983bbe842cffeb02b75452937
require_relative 'setup'
ActiveRecord::Schema.define do
  self.verbose = false

  # MIGRATIONS
  # <-- your work goes here
end


# MODELS
# <-- your work goes here


# TESTS
class SchoolTest < Minitest::Test
  def test_teachers_have_a_name
    assert_equal 'Tammy', Teacher.new(name: 'Tammy').name
  end

  def test_courses_have_a_name
    assert_equal 'Calc 1', Course.new(name: 'Calc 1').name
  end

  def test_students_have_a_name
    assert_equal 'Jimmy', Student.new(name: 'Jimmy').name
  end

  def test_students_have_contact_info
    assert_equal 'phone: 125-933-8257', Student.new(contact_info: 'phone: 125-933-8257').contact_info
  end

  def test_grades_have_a_letter
    assert_equal 'A', Grade.new(letter: 'A').letter
  end

  def test_grades_have_a_percentage
    assert_equal 90, Grade.new(percentage: 90).percentage
  end

  def test_enrollments_have_a_student
    sam = Student.new name: 'Sam'
    enrollment = Enrollment.new student: sam
    assert_equal sam, enrollment.student
  end

  def test_students_have_many_enrollments
    sam = Student.create! name: 'Sam' do |student|
      student.enrollments.build
      student.enrollments.build
    end
    assert_equal 2, sam.enrollments.count
  end

  def test_enrollments_have_a_course
    course = Course.new name: 'Calc'
    enrollment = Enrollment.new course: course
    assert_equal course, enrollment.course
  end

  def test_courses_have_many_enrollments
    calc = Course.create! name: 'Calc' do |course|
      course.enrollments.build
      course.enrollments.build
    end
    assert_equal 2, calc.enrollments.count
  end

  def test_enrollments_have_a_grade
    grade = Grade.new letter: 'B'
    enrollment = Enrollment.new grade: grade
    assert_equal grade, enrollment.grade
  end

  def test_grades_have_many_enrollments
    grade = Grade.create! letter: 'B' do |course|
      course.enrollments.build
      course.enrollments.build
      course.enrollments.build
    end
    assert_equal 3, grade.enrollments.count
  end

  def test_teachers_have_courses
    john = Teacher.create! name: 'John' do |teacher|
      teacher.courses.build name: 'Math'
      teacher.courses.build name: 'Science'
    end
    assert_equal ['Math', 'Science'], john.courses.pluck(:name)
  end

  def test_courses_belong_to_a_teacher
    john = Teacher.create! name: 'John'
    course = Course.new teacher: john
    assert_equal 'John', course.teacher.name
  end

  def test_coures_have_students_through_enrollments
    jimmy   = Student.new name: 'Jimmy'
    jeremy  = Student.new name: 'Jeremy'
    johnny  = Student.new name: 'Johnny'
    history = Course.create name: 'History' do |course|
      course.enrollments.build student: jimmy
      course.enrollments.build student: johnny
    end
    assert_equal ['Jimmy', 'Johnny'], history.students.pluck(:name)
  end

  def test_teachers_have_students_through_their_courses_enrollments
    ben     = Teacher.new name: 'Ben'
    belle   = Teacher.new name: 'Belle'
    barry   = Teacher.new name: 'Barry'

    jimmy   = Student.new name: 'Jimmy'
    johnny  = Student.new name: 'Johnny'
    jeremy  = Student.new name: 'Jeremy'

    Course.create name: 'History' do |course|
      course.teacher = ben
      course.enrollments.build student: jimmy
    end
    Course.create name: 'Science' do |course|
      course.teacher = belle
      course.enrollments.build student: jimmy
      course.enrollments.build student: jeremy
    end
    Course.create name: 'Math' do |course|
      course.teacher = ben
      course.enrollments.build student: johnny
    end

    assert_equal ['Jimmy', 'Johnny'], ben.students.pluck(:name)
    assert_equal ['Jimmy', 'Jeremy'], belle.students.pluck(:name)
    assert_equal [],                  barry.students.pluck(:name)
  end

  def test_students_have_teachers_through_their_enrollments_courses
    ben     = Teacher.new name: 'Ben'
    belle   = Teacher.new name: 'Belle'
    barry   = Teacher.new name: 'Barry'

    jimmy   = Student.new name: 'Jimmy'
    jeremy  = Student.new name: 'Johnny'
    johnny  = Student.new name: 'Jeremy'

    Course.create name: 'History' do |course|
      course.teacher = ben
      course.enrollments.build student: jimmy
    end
    Course.create name: 'Science' do |course|
      course.teacher = belle
      course.enrollments.build student: jimmy
      course.enrollments.build student: jeremy
    end
    Course.create name: 'Math' do |course|
      course.teacher = ben
      course.enrollments.build student: johnny
    end

    assert_equal ['Ben', 'Belle'], jimmy.teachers.pluck(:name)
    assert_equal ['Belle'],        jeremy.teachers.pluck(:name)
    assert_equal ['Ben'],          johnny.teachers.pluck(:name)
  end

  def test_students_have_grades_through_their_enrollments
    jimmy = Student.create! name: 'Jimmy' do |student|
      student.enrollments.build grade: Grade.new(letter: 'A')
      student.enrollments.build grade: Grade.new(letter: 'C')
      student.enrollments.build grade: Grade.new(letter: 'A')
    end
    assert_equal ['A', 'C', 'A'], jimmy.grades.pluck(:letter)
  end

  def test_grades_have_students_through_their_enrollments
    f = Grade.create! letter: 'F' do |grade|
      grade.enrollments.build student: Student.new(name: 'Alfie')
      grade.enrollments.build student: Student.new(name: 'Billy')
    end
    b = Grade.create! letter: 'B' do |grade|
      grade.enrollments.build student: Student.new(name: 'Charlie')
    end
    assert_equal ['Alfie', 'Billy'], f.students.pluck(:name)
    assert_equal ['Charlie'],        b.students.pluck(:name)
  end
end
