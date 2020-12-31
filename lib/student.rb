require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  # Creates the students table in the database
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  # Drops the students table from the database
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  # Saves an instance of the Student class to the database and then sets the given students `id` attribute
  # Updates a record if called on an object that is already persisted
  def save
    
    if self.id
      self.update

    else

      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

    end
    
  end

  # Creates a student with two attributes, name and grade, and saves it into the students table.
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  # Updates the record associated with a given instance
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  # Creates an instance with corresponding attribute values
  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2], row[0])
    new_student
  end

  # Returns an instance of student that matches the name from the DB
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[1], result[2], result[0])
  end

end
