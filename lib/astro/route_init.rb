module Astro
  class RouteInit
    CATALOG = [
        ["c", "d", "f", "1"],
        ["b", "z", "w", "1"],
        ["z", "w", "u", "1"],
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

    attr_reader :catalog, :map

    def initialize(map, c = CATALOG)
      @catalog = c
      @map = map
      init_segments_from_catalog
      init_routes_from_catalog
    end

    def self.map
      self.new(Astro::RouteMap.new).map
    end

    def init_segments_from_catalog
      @catalog.each do |args|
        factor = args.pop
        args.map!{|i| find_body(i)}
        args.each_cons(2).each do |from, to|
          @map.add_segment find_body(from), find_body(to), factor
        end
      end
    end

    def init_routes_from_catalog
      @catalog.each do |args|
        next if args.count < 3 # 2 element routes already setup with segments
        segs = args.
            each_cons(2).
            map{|f,t| [find_body(f), find_body(t)]}.
            map{|f,t| @map.segments[f,t]}
        @map.add_route segs
      end
    end

    def find_body(i)
      i.is_a?(String) ? Astro::Body.find_by_initial(i) : i
    end


  end
end