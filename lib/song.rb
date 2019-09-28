class Songs
  attr_accessor :name, :album, :length
  attr_reader :id

  def self.new_from_db(row)

    new_song = self.new
    new_song.id = row[0]
    new_song.name = row[1]
    new_song.length = row[2]
    new_song

  end

  def self.all
    sql = <<-SQL
      SELECT * FROM songs
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_one_by_name(name)
    sql = <<-SQL
      SELECT * FROM songs
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM songs WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Song.new(result[0], result[1], result[2], result[3])

  end

  def self.create(name:, album:, length:)
    song = Song.new(name, album, length)
    song.save
    song
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY
        name TEXT
        album TEXT
        length INT
      )
    SQL

    DB[:conn].execute(sql)
  end


  def initialize(id=nil, name, album)
    @id = id
    @name = name
    @album = album
    @length = length
  end

  def save
    sql = <<-SQL
      INSERT INTO songs(name, album, length)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql.name, sql.album, sql.length)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
  end

end