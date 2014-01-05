module Astro
  class Position
  include Virtus.model

    attribute :x, Float
    attribute :y, Float
    attribute :z, Float

    def - (val)
      Math.sqrt([:x,:y,:z].map do |v|
        (attributes[v] - val.attributes[v])**2
      end.inject(:+))
    end
  end
end