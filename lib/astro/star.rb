module Astro
  class Star
    include Virtus.model

    TEMPS = (0..9).to_a + (0..4).to_a * 2

    ASTRO_CONVERSION_FACTOR = 1.0/50

    MASSES = {
        "F" => (1.0..1.4),
        "K" => (0.45..0.8),
        "M" => (0.08..0.45),
        "G" => (0.8..1.4),
        "B" => (2.1..16.0),
        "O" => (16.0..24.0),
        "A" => (1.4..2.1)
    }

    LUMINOSITY = ["VI","IV"] + Array.new(8,"V")

    attribute :name, String
    attribute :star_type, String
    attribute :position, Astro::Position
    attribute :stellar_temp, Integer
    attribute :stellar_mass, Float
    attribute :stellar_luminosity, String
    attribute :id, Integer
    attribute :initial, Boolean


    def import_position(c_str)
      h = Hash[[:x, :y, :z].zip(c_str.split(/,/))]
      self.position = Position.new(h)
    end

    def set_stellar_values
      self.stellar_temp       = rand_temp
      self.stellar_mass       = rand_mass
      self.stellar_luminosity = rand_luminosity
    end

    def rand_temp
      TEMPS.sample
    end

    def rand_mass
      rand(MASSES[@star_type]).round(2)
    end

    def rand_luminosity
      LUMINOSITY.sample
    end

    def spectral_class
      [star_type, stellar_temp.to_s, stellar_luminosity].join("")
    end

    def -(val)
      position - val.position
    end

    def to_record
      [
          "Star", #Body Type Star, Multiple, White Dwarf, Route
          id, #Indicate Multiple Stars with same id.
          name,
          position.x * ASTRO_CONVERSION_FACTOR - 10,
          position.y * ASTRO_CONVERSION_FACTOR - 10,
          position.z * ASTRO_CONVERSION_FACTOR * 2, #already had a pos/negative
          stellar_mass,
          0,
          0,
          spectral_class,
          "", #color: blank to have astrosyntesis assign a value
          "" #notes
      ]
    end
  end
end

