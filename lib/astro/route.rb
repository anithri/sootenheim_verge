module Astro
  class Route

    CATALOG = [["c", "d", "f", "1"],
               ["b", "z", "w", "u", "1"],
               ["d", "e", "2"],
               ["e", "g", "k", "2"],
               ["l", "m", "o", "2"],
               ["r", "s", "t", "2"],
               ["a", "b", "3"],
               ["a", "c", "3"],
               ["f", "g", "3"],
               ["f", "j", "3"],
               ["i", "j", "3"],
               ["h", "k", "3"],
               ["k", "l", "3"],
               ["m", "n", "3"],
               ["n", "p", "3"],
               ["o", "p", "3"],
               ["p", "q", "3"],
               ["q", "s", "3"],
               ["s", "v", "3"],
               ["s", "w", "3"],
               ["t", "u", "3"],
               ["y", "z", "3"]]


    CLASS_FACTOR = [1, 5, 9, 12]

    include Virtus.model

    attribute :factor_id, Integer
    attribute :members, Array[Astro::Body]

    def factor
      (CLASS_FACTOR[factor_id] - 1) / (CLASS_FACTOR[factor_id] + 1.to_r)
    end

    def on_route?(star)
      members.include?(star)
    end

    def to_s
      "#{members.first.name} to #{members.last.name}: #{length.round(1)}d = #{length(1.0).round(1)}r"
    end

    def length(f = factor)
      members.each_cons(2).map { |f, t| f - t }.sum * f
    end

    def self.init_catalog
      out = []
      CATALOG.each do |args|
        factor = args.pop
        args.map! { |i| Astro::Body.find_by_initial(i) }

        (2..args.length).each do |size|
          args.each_cons(size).each do |members|
            f = members[0]
            t = args[-1]
            r = Route.new(members: members, factor_id: factor)
            out << r
            f.add_route(t, r)
            t.add_route(f, r)
          end
        end
      end
      out
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



