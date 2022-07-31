class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  # Access database connection with DB[:conn]
  # REMINDER: `self.<method_name>` is a CLASS method
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    # The ?s above are placeholders for the values below:
    DB[:conn].execute(sql, self.name, self.album)

    # Get the song ID from the DB & save it to the Ruby instance
    self.id = DB[:conn].execute('SELECT last_insert_rowid() FROM songs')[0][0]

    # Return the Ruby instance
    self
  end

  def self.create name:, album:
    song = Song.new name: name, album: album
    # Return the newly created Song
    song.save
  end
end
