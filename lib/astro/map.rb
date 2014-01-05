module Astro
  class Map
    include Virtus.model
    attribute :stars, Array[Astro::Star]
    attribute :routes, Array[Route]

    attr_accessor :filename

    GREAT_ROUTE = []
    def to_yaml_properties
      attributes.keys.map{|a| "@#{a}".intern }
    end

    def self.load_from(filename)
      out = new(YAML.load_file(filename))
      out.filename = filename
      out
    end

    def save(filename = nil)
      filename ||= @filename
      puts "saving map to: #{filename}"
      File.open(filename, "w"){|f| f.puts self.to_yaml}
    end

    def export_to_astrosynthesis(filename = 'etc/to_import.csv')
      puts "export to #{filename}"
      File.open(filename, "w"){|f| f.puts to_csv}
    end

    def to_csv
      stars_to_csv + "\n" + routes_to_csv
    end

    def stars_to_csv
      stars.
          sort_by{|s| s.name}.
          map(&:to_record).
          map{|r| r.join(",")}.
          join("\n")
    end

    def routes_to_csv
      letter = "A"
      routes.map do |route|
        letter.succ!
        route.to_record("Route #{route.raw_factor.to_s + letter}")
      end.join("\n")
    end

    def find_star_by_name(name)
      @stars.detect{|s| s.name == name}
    end

    def find_star_by_letter(letter)
      @stars.detect{|s| s.name[0].downcase == letter.downcase}
    end

    def find_star(key)
      return key if key.is_a?(Star)
      return find_star_by_name(key) if key.length > 1
      find_star_by_letter(key)
    end

    def extants
      coords = stars.map(&:position)
      [
          [coords.map(&:x).min, coords.map(&:x).max],
          [coords.map(&:y).min, coords.map(&:y).max],
          [coords.map(&:z).min, coords.map(&:z).max]
      ]
    end

    def distance(from, to)
      find_star(from) - find_star(to)
    end

    def add_route(raw_factor, *path)
      path.flatten!
      new_route =  Route.new({
          raw_factor: raw_factor,
          members: path.map{|e| find_star(e)}
                             })
      routes << new_route
    end

    def distance_along_path(*path)
      path.flatten!
      return 0 if path.count < 2
      path.each_cons(2).map do |from, to|
        distance(from, to) * hyper_factor(from, to)
      end.inject(:+)
    end

    def hyper_factor(f, t)
      return 1 if routes.empty?
      from, to = find_star(f), find_star(t)
      routes.select{|r| r.on_route?(from, to)}.map(&:factor).min || 1
    end
  end
end