module Ifdoc
  require 'ifdoc/attr_cacheable'
  require 'ifdoc/config'
  require 'ifdoc/project'
  require 'ifdoc/extractor'
  require 'ifdoc/comment_block'
  require 'ifdoc/block'
  require 'ifdoc/transformer'
  require 'ifdoc/example'

  def self.root(*a)
    File.join File.expand_path('../../', __FILE__), *a
  end
end
