module Astro

  class RouteSegment
    include Virtus.value_object

    values do
      attribute :factor_id, Integer
      attribute :from, Astro::Body
      attribute :to, Astro::Body
    end

    CLASS_FACTOR = { 0 => 1, 1 => 5, 2 => 9, 3 => 12}

    def factor
      @factor ||= (fv - 1) / (fv + 1.to_r)
    end


    def members
      [from,to]
    end

    def loc
      [from,to]
    end

    def valid?
      ! (factor_id.nil? || from == to)
    end

    def eql?(other)
      instance_of?(other.class) &&
      factor_id == other.factor_id &&
      [[from,to],[to,from]].include?([other.from,other.to])
    end

    def ==(other)
      other.kind_of?(self.class) &&
      other.factor_id == factor_id &&
      [[other.from, other.to],[other.to, other.from]].include?([from,to])
    end

    def to_s
      "[" + loc.map(&:initial).join("") + "]"
      #"#{first.name} to #{last.name}: #{length.round(1)}d = #{length(1.0)
      # .round(1)}r"
    end


    def length
      distance * factor
    end

    def distance
      @distance ||= BigDecimal.new(from - to, Astro::DISTANCE_PRECISION)
    end

    def inverse
      self.class.new(factor_id: factor_id, to: from, from: to)
    end

    private
    def fv
      CLASS_FACTOR[factor_id]
    end
  end
end
