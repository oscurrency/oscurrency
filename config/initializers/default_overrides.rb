# This overrides the :per_page attribute for will_paginate.
# The default for will_paginate is 30, which seems a little high.
class ActiveRecord::Base
  def self.per_page
    10
  end
end

# ruby 2.3 see https://stackoverflow.com/questions/36966497/typeerror-no-implicit-conversion-of-nil-into-string-when-eager-loading-result
class Hash
  undef_method :to_proc if self.method_defined?(:to_proc)
end
