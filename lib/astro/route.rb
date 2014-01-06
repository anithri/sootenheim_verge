
module Astro
  class Route
    include Virtus.value_object

    values do
      attribute :segments, Array[Astro::RouteSegment]
    end

    def members
      @members ||= segments.map(&:members).flatten(1).uniq
    end

    def from
      segments.first.from
    end

    def to
      segments.last.to
    end

    def loc
      [from,to]
    end

    def to_s
      segments.map(&:to_s).join("=>")
    end

    def valid?
      no_repeats? && contiguous?
    end

    def no_repeats?
      ! segments.combination(2).map{|a,b| a == b}.any?
    end

    def distance
      segments.map(&:distance).inject(&:+)
    end

    def length
      segments.map(&:length).inject(&:+)
    end

    def contiguous?
      return false if segments.empty?
      return true if segments.count == 1
      segments.each_cons(2).map{|a,b| a.to == b.from }.all?
    end

    def extend_route_to(to)
      new_route = self.class.new(segments: segments + [to])
      return nil unless new_route && new_route.valid?
      new_route
    end

    def inverse
      self.class.new segments: segments.reverse.map(&:inverse)
    end
  end
end
__END__
· Body Type.  This must be 'Route'

· Start Body.  This is the name of the body that the route segment starts at.

· End Body.  This is the name of the body that the route segment ends at.

· Route Type.  This is the type of route.  For example, 'Trade' or 'Hyperjump'

· Route Name.  This is the name of this particular route.

· Route Color.  This is the color of the route line, as stored in the format #RRGGBB (similar to an HTML color format).

· Route Style.  This is the line style of the route line (see notes).

· Route Width.  This is the width, in pixels, of the route line.  Must be an integer.



