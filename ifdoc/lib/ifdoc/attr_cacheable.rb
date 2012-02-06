module Ifdoc
  module AttrCacheable
    def attr_cacheable(*attrs)
      attrs.each do |attr|

        self.send :alias_method, :"cached_#{attr}", attr

        self.send :define_method, attr do |*args|
          @attr_cache ||= Hash.new
          @attr_cache[[attr, args]] = self.send :"cached_#{attr}", *args
        end

      end
    end
  end
end
